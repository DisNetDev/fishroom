import 'dart:io';

import 'package:fishroom/core/repositories/supabase_repository.dart';
import 'package:fishroom/core/usecases/cache_image.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';
import '../../achievements/models/achievement.dart';
import '../../tank_inhabitants/models/inhabitant.dart';

part 'tanks_state.dart';

class TanksCubit extends HydratedCubit<TanksState> {
  TanksCubit({required this.supabaseRepository})
      : super(const TanksState(tanks: [], error: false, readings: []));

  final SupabaseRepository supabaseRepository;

  @override
  TanksState? fromJson(Map<String, dynamic> json) {
    return TanksState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TanksState state) {
    return state.toJson();
  }

  Future<void> addTank(Tank tank, File? image) async {
    try {
      fishLog("Creating a tank...");
      String? localPath;
      String? imageUrl;

      if (image != null) {
        localPath = await cacheImageFromFile(image);
        imageUrl = await supabaseRepository.uploadImage(image);
        tank.imageUrl = imageUrl;
        tank.imageLocalPath = localPath;
      }

      tank.createdAt = DateTime.now().toString();

      await supabaseRepository.insert(
          tableName: SupabaseTable.tanks.tableName, json: tank.toJson());

      emit(state.copyWith(tanks: [...state.tanks, tank]));
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> deleteTank(Tank tank) async {
    try {
      await supabaseRepository.delete(
          tableName: SupabaseTable.tanks.tableName,
          column: SupabaseTable.tanks.id,
          condition: tank.id);
      await supabaseRepository.delete(
          tableName: SupabaseTable.tankReadings.tableName,
          column: SupabaseTable.tankReadings.tankId,
          condition: tank.id);
      List<Tank> stateTanks = state.tanks
          .where((tankInState) => tank.id != tankInState.id)
          .toList();

      List<TankReading> stateReadings = state.readings
          .where((readingInState) => tank.id != readingInState.tankId)
          .toList();

      emit(state.copyWith(tanks: stateTanks, readings: stateReadings));
    } on Exception catch (_) {
      rethrow;
    }
  }

  void rebuildUI() {
    emit(state);
  }

  Future<void> getTanks() async {
    try {
      fishLog("Getting tanks...");
      final data = await supabaseRepository.fetch(
          tableName: SupabaseTable.tanks.tableName,
          conditionalColumn: SupabaseTable.tanks.ownerId,
          condition: supabaseRepository.user!.id);

      if (data != null) {
        List<Tank> tanks = [];
        for (Map<String, dynamic> tankJson in data) {
          tanks.add(Tank.fromJson(tankJson));
        }
        tanks.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        emit(state.copyWith(tanks: tanks));
      } else {
        emit(state.copyWith(error: true));
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<Achievement>> getAvailableAchievements() async {
    List<Achievement> availableAchievements = [];

    try {
      final response = await supabaseRepository.fetchAll(
          tableName: SupabaseTable.achievements.tableName);

      if (response != null) {
        for (Map<String, dynamic> json in response) {
          availableAchievements.add(Achievement.fromJson(json));
        }
      }

      return availableAchievements;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getReadingsForTank(Tank tank) async {
    try {
      fishLog("Getting Tank Readings...");

      final data = await supabaseRepository.fetch(
          tableName: SupabaseTable.tankReadings.tableName,
          conditionalColumn: SupabaseTable.tankReadings.tankId,
          condition: tank.id);

      if (data != null) {
        List<TankReading> readings = [];
        readings.addAll(state.readings);
        for (Map<String, dynamic> json in data) {
          TankReading reading = TankReading.fromJson(json);
          if (!readings
              .any((readingInState) => readingInState.id == reading.id)) {
            readings.add(reading);
          }
        }
        readings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(state.copyWith(readings: readings));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTankReading(TankReading reading, File? image) async {
    try {
      fishLog("Creating a reading...");
      TankReading amendedReading = reading;

      String? imagePath;

      if (image != null) {
        imagePath = await supabaseRepository.uploadImage(image);
        amendedReading = reading.copyWith(imageUrl: imagePath);
      }

      await supabaseRepository.insert(
        tableName: SupabaseTable.tankReadings.tableName,
        json: amendedReading.toJson(),
      );

      List<TankReading> readings = state.readings;
      readings.insert(0, amendedReading);
      readings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(state.copyWith(readings: readings));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTank(Tank tank, File? image) async {
    try {
      fishLog("Updating tank...");
      String? localPath;
      String? imageUrl;

      if (image != null) {
        try {
          localPath = await cacheImageFromFile(image);
          imageUrl = await supabaseRepository.uploadImage(image);
          tank.imageUrl = imageUrl;
          tank.imageLocalPath = localPath;
        } catch (_) {}
      }

      await supabaseRepository.update(
        tableName: SupabaseTable.tanks.tableName,
        json: tank.toJson(),
        conditionalColumn: SupabaseTable.tanks.id,
        condition: tank.id,
      );

      List<Tank> tanks = [];
      tanks.addAll(state.tanks);

      tanks.removeWhere((tankToCheck) => tank.id == tankToCheck.id);
      tanks.insert(0, tank);

      emit(state.copyWith(tanks: tanks));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTankReading(TankReading reading) async {
    try {
      fishLog("Deleting tank reading...");
      await supabaseRepository.delete(
          tableName: SupabaseTable.tankReadings.tableName,
          column: SupabaseTable.tankReadings.id,
          condition: reading.id);
      List<TankReading> readings = [];
      readings.addAll(state.readings);
      readings.removeWhere((removedReading) => removedReading.id == reading.id);

      emit(state.copyWith(readings: readings));
    } catch (_) {
      rethrow;
    }
  }

  void clearCubit() {
    emit(const TanksState(tanks: [], error: false, readings: []));
  }

  Future<void> updateTankStreak(BuildContext context, String tankId) async {
    Tank tank = state.tanks.firstWhere((tank) => tank.id == tankId).copyWith();
    int oldTankStreak = tank.streak;

    try {
      fishLog("Getting tank streak for tank ${tank.id}");
      final data = await supabaseRepository
          .runFunction("get_streak", {"input_tank_id": tank.id});

      tank.streak = int.tryParse(data.toString()) ?? 0;

      if (tank.streak != oldTankStreak) {
        await updateTank(tank, null);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTankInhabitants(
      String tankId, List<Inhabitant> inhabitants) async {
    try {
      Tank tank = state.tanks
          .firstWhere((tank) => tank.id == tankId)
          .copyWith(inhabitants: inhabitants);
      await updateTank(tank, null);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTankLocalImagePath(
      String tankId, String localImagePath) async {
    try {
      Tank tank = state.tanks
          .firstWhere((tank) => tank.id == tankId)
          .copyWith(imageLocalPath: localImagePath);
      await updateTank(tank, null);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTankAchievements(
      String tankId, List<Achievement> achievements) async {
    try {
      Tank tank =
          state.tanks.firstWhere((tank) => tank.id == tankId).copyWith();
      tank.achievementIds =
          achievements.map((achievement) => achievement.id).toList();
      await updateTank(tank, null);
    } catch (e) {
      rethrow;
    }
  }
}
