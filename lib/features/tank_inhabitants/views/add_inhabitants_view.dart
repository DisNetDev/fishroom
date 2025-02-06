import 'package:collection/collection.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/tank_inhabitants/widgets/inhabitant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/models/tank.dart';
import '../../../core/usecases/nav_push.dart';
import '../../../core/widgets/custom_background.dart';
import '../cubit/inhabitants_cubit.dart';
import '../models/inhabitant.dart';

class AddInhabitantsView extends StatefulWidget {
  const AddInhabitantsView(
      {super.key, required this.tank, required this.chosenInhabitant});

  final Tank tank;
  final void Function(Inhabitant) chosenInhabitant;

  @override
  State<AddInhabitantsView> createState() => _AddInhabitantsViewState();
}

class _AddInhabitantsViewState extends State<AddInhabitantsView> {
  InhabitantsCubit get _inhabitantsCubit => context.read<InhabitantsCubit>();

  List<Inhabitant> _inhabitants = [];
  List<Inhabitant> _filteredInhabitants = [];
  bool _isLoading = false;

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
              TextInput(
                hintText: 'Search',
                onChanged: (value) {
                  _searchInhabitants(value);
                },
              ),
              const Gap(20),
              if (_isLoading)
                ...List.generate(
                  10,
                  (index) => InhabitantWidget(
                    inhabitant: Inhabitant.getPlaceholder(),
                    loading: true,
                    onAdd: (_) {},
                  ),
                )
              else if (_filteredInhabitants.isNotEmpty)
                ...List.generate(
                  _filteredInhabitants.length,
                  (index) => InhabitantWidget(
                    inhabitant: _filteredInhabitants[index],
                    onAdd: (inhabitant) {
                      navPop(context);
                      widget.chosenInhabitant(inhabitant);
                    },
                  ),
                )
              else
                const Center(
                  child: Text("No inhabitants found"),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _fetchInhabitants() async {
    setState(() => _isLoading = true);
    try {
      _inhabitants = await _inhabitantsCubit.getAllInhabitants();
      for (Inhabitant inhabitant in _inhabitants) {
        int index = widget.tank.inhabitants.indexWhere(
            (existingInhabitant) => existingInhabitant.id == inhabitant.id);
        if (index != -1) {
          inhabitant.count = widget.tank.inhabitants[index].count;
        }
      }
      _filteredInhabitants = _inhabitants;
    } catch (e) {
      setState(() => _isLoading = false);
      showToast(context,
          title: "Error fetching inhabitants...",
          description: e.toString(),
          toastType: ToastType.error);
    }
    setState(() => _isLoading = false);
  }

  void _searchInhabitants(String value) {
    setState(() {
      _filteredInhabitants = _inhabitants
          .where((inhabitant) =>
              inhabitant.commonName!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              inhabitant.scientificName
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    });
  }
}
