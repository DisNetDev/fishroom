import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'models/units.dart';
import 'services/co2_service.dart';

class Co2KhPhTool extends StatefulWidget {
  const Co2KhPhTool({super.key});

  @override
  State<Co2KhPhTool> createState() => _Co2KhPhToolState();
}

class _Co2KhPhToolState extends State<Co2KhPhTool> {
  final _khCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _targetCo2Ctrl = TextEditingController(text: '30');
  final _volumeCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  KHUnit _khUnit = KHUnit.dKH;
  VolumeUnit _volumeUnit = VolumeUnit.liters;
  DiffusionMethod _method = DiffusionMethod.diffuser;

  double? _co2FromKhPh;
  double? _suggestedPh;
  double? _bps;

  @override
  void dispose() {
    _khCtrl.dispose();
    _phCtrl.dispose();
    _targetCo2Ctrl.dispose();
    _volumeCtrl.dispose();
    super.dispose();
  }

  String? _positiveValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final d = double.tryParse(v.replaceAll(',', '.'));
    if (d == null) return 'Enter a valid number';
    if (d <= 0) return 'Must be > 0';
    return null;
  }

  String? _phValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final d = double.tryParse(v.replaceAll(',', '.'));
    if (d == null) return 'Enter a valid number';
    if (d < 5.0 || d > 8.5) return 'pH 5.0–8.5 recommended';
    return null;
  }

  void _recalculate() {
    double? parse(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.'));

    final kh = parse(_khCtrl);
    final ph = parse(_phCtrl);
    final targetCo2 = parse(_targetCo2Ctrl);
    final vol = parse(_volumeCtrl);

    double? co2;
    double? suggestPh;
    double? bps;

    if (kh != null && ph != null) {
      co2 = CO2Service.co2PpmFromKhPh(khValue: kh, khUnit: _khUnit, pH: ph);
    }
    if (kh != null && targetCo2 != null && targetCo2 > 0) {
      suggestPh = CO2Service.pHFromCo2Kh(
          targetCo2Ppm: targetCo2, khValue: kh, khUnit: _khUnit);
    }
    if (vol != null && targetCo2 != null && targetCo2 > 0) {
      bps = CO2Service.estimateBps(
          tankVolume: vol,
          volumeUnit: _volumeUnit,
          targetCo2Ppm: targetCo2,
          method: _method);
    }

    setState(() {
      _co2FromKhPh = co2;
      _suggestedPh = suggestPh;
      _bps = bps;
    });
  }

  String _khUnitLabel(KHUnit u) => u == KHUnit.dKH ? 'dKH' : 'meq/L';
  String _volumeUnitLabel(VolumeUnit u) {
    switch (u) {
      case VolumeUnit.liters:
        return 'L';
      case VolumeUnit.gallonsUS:
        return 'gal (US)';
      case VolumeUnit.gallonsImperial:
        return 'gal (Imp)';
    }
  }

  String _methodLabel(DiffusionMethod m) {
    switch (m) {
      case DiffusionMethod.diffuser:
        return 'In-tank diffuser';
      case DiffusionMethod.inline:
        return 'Inline diffuser';
      case DiffusionMethod.reactor:
        return 'Reactor';
      case DiffusionMethod.airstone:
        return 'Airstone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(children: [
      const CustomBackground(),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const RootSliverAppBar(
                title: 'CO2 • KH • pH',
                sliver: true,
                implyLeading: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'KH',
                              child: _NumberField(
                                controller: _khCtrl,
                                onChanged: (_) => _recalculate(),
                                validator: _positiveValidator,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'KH Unit',
                              child: _Dropdown<KHUnit>(
                                value: _khUnit,
                                items: KHUnit.values,
                                itemLabel: _khUnitLabel,
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _khUnit = v);
                                  _recalculate();
                                },
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'pH',
                              child: _NumberField(
                                controller: _phCtrl,
                                onChanged: (_) => _recalculate(),
                                validator: _phValidator,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'Target CO2 (ppm)',
                              child: _NumberField(
                                controller: _targetCo2Ctrl,
                                onChanged: (_) => _recalculate(),
                                validator: _positiveValidator,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Tank Volume',
                              child: _NumberField(
                                controller: _volumeCtrl,
                                onChanged: (_) => _recalculate(),
                                validator: _positiveValidator,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LabeledField(
                              label: 'Volume Unit',
                              child: _Dropdown<VolumeUnit>(
                                value: _volumeUnit,
                                items: VolumeUnit.values,
                                itemLabel: _volumeUnitLabel,
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _volumeUnit = v);
                                  _recalculate();
                                },
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _LabeledField(
                          label: 'Diffusion Method',
                          child: _Dropdown<DiffusionMethod>(
                            value: _method,
                            items: DiffusionMethod.values,
                            itemLabel: _methodLabel,
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _method = v);
                              _recalculate();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ResultCards(
                          co2FromKhPh: _co2FromKhPh,
                          suggestedPh: _suggestedPh,
                          bps: _bps,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Note: Formulas are approximations. Verify with drop checker or CO2 meter.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        NeoBruteBorder(child: child),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  const _NumberField(
      {required this.controller, this.onChanged, this.validator});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  const _Dropdown(
      {required this.value,
      required this.items,
      required this.itemLabel,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        items: items
            .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(itemLabel(e)))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _ResultCards extends StatelessWidget {
  final double? co2FromKhPh;
  final double? suggestedPh;
  final double? bps;
  const _ResultCards({this.co2FromKhPh, this.suggestedPh, this.bps});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cards = <Widget>[];

    Widget card(String title, String value, IconData icon) {
      return NeoBruteBorder(
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium),
                    const SizedBox(height: 2),
                    Text(value, style: theme.textTheme.titleMedium),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    if (co2FromKhPh != null) {
      cards.add(card('CO2 from KH/pH', '${co2FromKhPh!.toStringAsFixed(1)} ppm',
          Icons.bubble_chart));
    }
    if (suggestedPh != null && suggestedPh!.isFinite) {
      cards.add(card('Suggested pH for target', suggestedPh!.toStringAsFixed(2),
          Icons.analytics));
    }
    if (bps != null) {
      cards.add(card('Estimated bubble rate', '${bps!.toStringAsFixed(1)} bps',
          Icons.speed));
    }

    if (cards.isEmpty) {
      cards.add(
          card('Results', 'Enter values to calculate', Icons.info_outline));
    }

    return Column(children: [
      for (var i = 0; i < cards.length; i++) ...[
        if (i > 0) const SizedBox(height: 10),
        cards[i],
      ]
    ]);
  }
}
