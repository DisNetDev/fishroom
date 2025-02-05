import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/tank_inhabitants/widgets/inhabitant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/tank.dart';
import '../../../core/widgets/custom_background.dart';
import '../cubit/inhabitants_cubit.dart';
import '../models/inhabitant.dart';

class AddInhabitantsView extends StatefulWidget {
  const AddInhabitantsView({super.key, required this.tank});

  final Tank tank;

  @override
  State<AddInhabitantsView> createState() => _AddInhabitantsViewState();
}

class _AddInhabitantsViewState extends State<AddInhabitantsView> {
  InhabitantsCubit get _inhabitantsCubit => context.read<InhabitantsCubit>();

  List<Inhabitant> _inhabitants = [];
  bool _isLoading = false;

  Future<void> _fetchInhabitants() async {
    setState(() => _isLoading = true);
    try {
      _inhabitants = await _inhabitantsCubit.getAllInhabitants();
    } catch (e) {
      setState(() => _isLoading = false);
      showToast(context,
          title: "Error fetching inhabitants...",
          description: e.toString(),
          toastType: ToastType.error);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _fetchInhabitants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          appBar: RootSliverAppBar(
            title: 'Add Inhabitants to ${widget.tank.name}',
          ),
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              ...List.generate(
                _inhabitants.length,
                (index) => InhabitantWidget(inhabitant: _inhabitants[index]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
