import 'package:fishroom/core/usecases/can_add_tank.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/app/usecases/logout.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/settings/views/tank_parameters_settings.dart';
import 'package:fishroom/features/upgrade/views/upgrade_to_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/app/cubit/app_cubit.dart';
import '../constants.dart';

class RootDrawer extends StatelessWidget {
  const RootDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        bool pro = state.user!.premium;

        return SafeArea(
          child: Drawer(
            child: Column(
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.2)),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Logo(horizontal: true),
                  ),
                ),

                ListTile(
                  enabled: canAddTank(context),
                  leading: const Icon(Icons.add),
                  title: const Text("Create a Tank"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTankTankName()));
                  },
                ),

                ListTile(
                  title: const Text("Tank Parameters"),
                  subtitle: const Text("Adjust your tank parameters"),
                  subtitleTextStyle:
                      kDateTimeTextStyle.copyWith(color: Colors.grey),
                  leading: const Icon(Symbols.bar_chart_rounded),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TankParametersSettings())),
                ),

                const Expanded(child: SizedBox()),
                ListTile(
                  title: const Text("Compact Mode"),
                  subtitleTextStyle:
                      kDateTimeTextStyle.copyWith(color: Colors.grey),
                  subtitle: const Text(
                      "Lots of tanks? This will make it easier to view them."),
                  trailing: SizedBox(
                    width: 40,
                    child: FittedBox(
                      child: Switch(
                        activeColor: kPrimaryColor,
                        value: state.settings.compactTankTile,
                        onChanged: (value) {
                          try {
                            context.read<AppCubit>().updateSettings(state
                                .settings
                                .copyWith(compactTankTile: value));
                          } catch (e) {
                            showToast(context,
                                title: "Failed to update settings",
                                description: e.toString(),
                                toastType: ToastType.error);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                if (kDebugMode)
                  ListTile(
                    title: const Text("(DEBUG)"),
                    subtitle: Text(
                        "Switch to ${context.read<AppCubit>().state.user!.premium ? "FREE" : "PRO"}"),
                    onTap: () {
                      context.read<AppCubit>().debugToggleFreeAndPro();
                    },
                  ),

                if (!pro)
                  ListTile(
                      leading: const Icon(Icons.arrow_upward_outlined),
                      title: const Text("Upgrade to Pro"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpgradeToPro()))),

                ListTile(
                  enabled: false,
                  leading: const Icon(Symbols.info_rounded),
                  title: const Text("Version Info"),
                  subtitle: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            "Version: ${snapshot.data!.version} - ${pro ? "Pro" : "Free"}");
                      } else {
                        return const Text("Loading version...");
                      }
                    },
                  ),
                  subtitleTextStyle: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  enabled: false,
                  leading: const Icon(Icons.person),
                  title: const Text("Logged in as:"),
                  subtitle: Text(
                      context.read<AppCubit>().state.user?.email ?? "No One?"),
                  subtitleTextStyle: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),

                //Bottom

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    logOut(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
