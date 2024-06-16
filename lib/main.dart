import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/my_tanks/cubit/tanks_cubit.dart';
import 'features/my_tanks/views/my_tanks.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TanksCubit(),
      child: const MaterialApp(
        home: MyTanks(),
      ),
    );
  }
}
