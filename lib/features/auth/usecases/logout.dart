import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

void logOut(BuildContext context) {
  context.read<AuthCubit>().clear();
  context.read<TanksCubit>().clear();
}
