import 'dart:io';

import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/upload_image.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../../core/usecases/show_toast.dart';
import '../../app/cubit/app_cubit.dart';
import '../cubit/community_tank_cubit.dart';
import '../models/ct_post.dart';

class CreatePostModal extends StatefulWidget {
  const CreatePostModal({super.key});

  @override
  State<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  CommunityTankCubit get cubit => context.read<CommunityTankCubit>();
  AppCubit get appCubit => context.read<AppCubit>();
  bool isLoading = false;
  File? image;
  CTPost post = CTPost(
    id: const Uuid().v4(),
    title: '',
    content: '',
    authorID: '',
    authorName: '',
    createdAt: DateTime.now().toUtc().toString(),
    images: [],
    upVotes: 0,
    downVotes: 0,
  );

  @override
  void initState() {
    post = post.copyWith(
        authorID: appCubit.state.user?.uuid ?? '',
        authorName: appCubit.state.user?.username ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(vertical: 50),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: Text("Title"),
              validator: (value) =>
                  value!.isEmpty ? "Title cannot be empty" : null,
              initialValue: post.title,
              onChanged: (value) =>
                  setState(() => post = post.copyWith(title: value)),
              characterLimit: 100,
            ),
            Gap(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ImageUploadWidget(
                onImagePicked: (image) => setState(() => this.image = image),
                image: image,
              ),
            ),
            Gap(20),
            TextInput(
              label: Text("Content"),
              isMultiline: true,
              initialValue: post.content,
              onChanged: (value) =>
                  setState(() => post = post.copyWith(content: value)),
            ),
            Gap(20),
            CustomButton(
              margin: EdgeInsets.symmetric(horizontal: 16),
              text: "Create Post",
              loading: isLoading,
              onPressed: () async {
                if (post.title.isEmpty || post.content.isEmpty) {
                  showToast(context,
                      title: "Error Creating Post",
                      description: "Title and content cannot be empty",
                      toastType: ToastType.error);
                  return;
                }

                try {
                  setState(() => isLoading = true);

                  if (image != null) {
                    final String imageUrl = await uploadImage(context, image!);
                    post = post.copyWith(images: [imageUrl]);
                  }

                  //set createdAt to now
                  post = post.copyWith(
                      createdAt: DateTime.now().toUtc().toString());
                  await cubit.createPost(post);
                  setState(() => isLoading = false);
                  navPop(context);
                } catch (e) {
                  setState(() => isLoading = false);
                  showToast(context,
                      title: "Error Creating Post",
                      description: e.toString(),
                      toastType: ToastType.error);
                }
              },
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }
}
