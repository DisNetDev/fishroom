import 'package:fishroom/core/usecases/can_add_tank.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/auth/usecases/logout.dart';
import 'package:fishroom/features/create_tank_flow/create_tank_tank_name.dart';
import 'package:fishroom/features/upgrade/views/upgrade_to_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/auth/cubit/auth_cubit.dart';

class RootDrawer extends StatelessWidget {
  const RootDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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

                if (!pro)
                  ListTile(
                      leading: const Icon(Icons.arrow_upward_outlined),
                      title: const Text("Upgrade to Pro"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpgradeToPro()))),

                const Expanded(child: SizedBox()),

                if (kDebugMode)
                  ListTile(
                    title: const Text("(DEBUG)"),
                    subtitle: Text(
                        "Switch to ${context.read<AuthCubit>().state.user!.premium ? "FREE" : "PRO"}"),
                    onTap: () {
                      context.read<AuthCubit>().debugToggleFreeAndPro();
                    },
                  ),

                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
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
                  enabled: false,
                ),
                ListTile(
                  enabled: false,
                  leading: const Icon(Icons.person),
                  title: const Text("Logged in as:"),
                  subtitle: Text(
                      context.read<AuthCubit>().state.user?.email ?? "No One?"),
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
