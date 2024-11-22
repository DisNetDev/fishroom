import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RootSliverAppBar(
        title: "Settings",
        implyLeading: false,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return const SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text("Tank Parameters"),
                  subtitle: Text("Your tank parameters"),
                  leading: Icon(Symbols.bar_chart_rounded),
                  trailing: Icon(Symbols.keyboard_arrow_right_rounded),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
