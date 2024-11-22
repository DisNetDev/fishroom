import 'dart:io';

import 'package:fishroom/core/repositories/supabase_repository.dart';
import 'package:fishroom/core/usecases/cache_image.dart';
import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/database_tables.dart';
import '../../../core/models/tank.dart';
import '../../../core/models/tank_reading.dart';

part 'tanks_state.dart';

class TanksCubit extends Cubit<TanksState> {
  TanksCubit({required this.supabaseRepository})
      : super(const TanksState(tanks: [], error: false, readings: []));

  final SupabaseRepository supabaseRepository;

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

      await supabaseRepository.insert(
          tableName: Table.tanks.tableName, json: tank.toJson());

      emit(state.copyWith(tanks: [...state.tanks, tank]));
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> deleteTank(Tank tank) async {
    try {
      await supabaseRepository.delete(
          tableName: Table.tanks.tableName,
          column: Table.tanks.id,
          condition: tank.id);
      await supabaseRepository.delete(
          tableName: Table.tankReadings.tableName,
          column: Table.tankReadings.tankId,
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

  Future<void> getTanks() async {
    try {
      fishLog("Getting tanks...");
      final data = await supabaseRepository.fetch(
          tableName: Table.tanks.tableName,
          conditionalColumn: Table.tanks.ownerId,
          condition: supabaseRepository.user!.id);
      fishLog(data.toString());

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

  Future<void> getReadingsForTank(Tank tank) async {
    try {
      fishLog("Getting Tank Readings...");

      final data = await supabaseRepository.fetch(
          tableName: Table.tankReadings.tableName,
          conditionalColumn: Table.tankReadings.tankId,
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
        tableName: Table.tankReadings.tableName,
        json: amendedReading.toJson(),
      );

      emit(state.copyWith(readings: [...state.readings, amendedReading]));
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
        } on Exception catch (_) {}
      }

      await supabaseRepository.update(
        tableName: Table.tanks.tableName,
        json: tank.toJson(),
        conditionalColumn: Table.tanks.id,
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
          tableName: Table.tankReadings.tableName,
          column: Table.tankReadings.id,
          condition: reading.id);
      List<TankReading> readings = [];
      readings.addAll(state.readings);
      readings.removeWhere((removedReading) => removedReading.id == reading.id);

      emit(state.copyWith(readings: readings));
    } catch (_) {
      rethrow;
    }
  }

  void clear() {
    emit(const TanksState(tanks: [], error: false, readings: []));
  }
}
