import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/cubit/app_cubit.dart';
import '../widgets/create_post_modal.dart';
import '../widgets/create_username_modal.dart';

class CommunityTankView extends StatefulWidget {
  const CommunityTankView({super.key});

  @override
  State<CommunityTankView> createState() => _CommunityTankViewState();
}

class _CommunityTankViewState extends State<CommunityTankView> {
  AppCubit get appCubit => context.read<AppCubit>();

  void showCreateUsernameModal() async {
    await Future.delayed(const Duration(milliseconds: 100));
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (context) => const CreateUsernameModal(),
    );
  }

  @override
  void initState() {
    if (appCubit.state.user?.username == null) {
      showCreateUsernameModal();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          navReplace(context, Fishroom()),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            scrollControlDisabledMaxHeightRatio: 0.5,
            context: context,
            builder: (context) => const CreatePostModal(),
          ),
        ),
        bottomNavigationBar: RootNavbar(currentIndex: 1),
        body: Center(
          child: Text(
            "Welcome to the Community Tank!",
            style: kHeadingTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
