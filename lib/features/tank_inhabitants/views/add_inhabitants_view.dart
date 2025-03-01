import 'package:fishroom/core/usecases/is_dark_mode.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    _fetchInhabitants();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      if (!_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      }
    } else {
      if (_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              RootSliverAppBar(
                title: 'Add Inhabitants to ${widget.tank.name}',
                sliver: true,
              ),
              SliverToBoxAdapter(
                child: TextInput(
                  hintText: 'Search',
                  onChanged: (value) {
                    _searchInhabitants(value);
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, int index) {
                    if (_isLoading) {
                      return Column(
                        children: [
                          Gap(20),
                          ...List.generate(
                            10,
                            (index) => InhabitantWidget(
                              inhabitant: Inhabitant.getPlaceholder(),
                              loading: true,
                              onAdd: (_) {},
                            ),
                          )
                        ],
                      );
                    } else if (_filteredInhabitants.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredInhabitants.length,
                        itemBuilder: (context, index) {
                          return InhabitantWidget(
                            inhabitant: _filteredInhabitants[index],
                            onAdd: (inhabitant) {
                              navPop(context);
                              widget.chosenInhabitant(inhabitant);
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No inhabitants found"),
                      );
                    }
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
          floatingActionButton: _showScrollToTopButton
              ? FloatingActionButton.small(
                  foregroundColor:
                      isDarkMode(context) ? Colors.white : Colors.black,
                  backgroundColor: isDarkMode(context)
                      ? const Color.fromARGB(255, 19, 19, 19)
                      : Colors.white,
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(Icons.arrow_upward),
                )
              : null,
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
