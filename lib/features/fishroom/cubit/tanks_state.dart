part of 'tanks_cubit.dart';

class TanksState {
  final List<Tank> tanks;
  final bool isLoading;

  const TanksState({
    required this.tanks,
    this.isLoading = false,
  });
}
