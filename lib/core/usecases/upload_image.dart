import 'dart:io';

import 'package:fishroom/core/repositories/supabase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<String> uploadImage(BuildContext context, File image) async {
  try {
    String? url = await context.read<SupabaseRepository>().uploadImage(image);
    if (url == null) {
      throw "Something went wrong uploading this image. Please try again.";
    }

    return url;
  } catch (e) {
    rethrow;
  }
}
