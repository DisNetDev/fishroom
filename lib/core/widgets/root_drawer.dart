import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/auth/usecases/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/fishroom/views/create_tank.dart';

class RootDrawer extends StatelessWidget {
  const RootDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Logo(horizontal: true),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Create a Tank"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateTank()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.arrow_upward_outlined),
              title: Text(context.read<AuthCubit>().state.user!.premium
                  ? "Version"
                  : "Upgrade to Pro"),
            ),
            const Expanded(child: SizedBox()),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              subtitle: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasData) {
                    return Text("Version: ${snapshot.data!.version}");
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
  }
}
