import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'models/units.dart';
import 'services/water_volume_service.dart';

class WaterVolumeCalc extends StatefulWidget {
  const WaterVolumeCalc({super.key});

  @override
  State<WaterVolumeCalc> createState() => _WaterVolumeCalcState();
}

class _WaterVolumeCalcState extends State<WaterVolumeCalc> {
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _diameterCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LengthUnit _lengthUnit = LengthUnit.centimeters;
  VolumeUnit _volumeUnit = VolumeUnit.liters;
  TankShape _shape = TankShape.rectangular;

  double? _result;

  @override
  void dispose() {
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _diameterCtrl.dispose();
    super.dispose();
  }

  void _recalculate() {
    parse(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.'));

    double? res;
    if (_shape == TankShape.rectangular) {
      final length = parse(_lengthCtrl);
      final width = parse(_widthCtrl);
      final height = parse(_heightCtrl);
      if (length == null || width == null || height == null) {
        res = null;
      } else {
        res = WaterVolumeService.volumeForShape(
          shape: _shape,
          lengthUnit: _lengthUnit,
          volumeUnit: _volumeUnit,
          length: length,
          width: width,
          height: height,
        );
      }
    } else {
      final diameter = parse(_diameterCtrl);
      final height = parse(_heightCtrl);
      if (diameter == null || height == null) {
        res = null;
      } else {
        res = WaterVolumeService.volumeForShape(
          shape: _shape,
          lengthUnit: _lengthUnit,
          volumeUnit: _volumeUnit,
          diameter: diameter,
          height: height,
        );
      }
    }

    setState(() => _result = res);
  }

  String? _positiveNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final v = double.tryParse(value.replaceAll(',', '.'));
    if (v == null) return 'Enter a valid number';
    if (v <= 0) return 'Must be greater than 0';
    return null;
  }

  String _lengthUnitLabel(LengthUnit u) {
    switch (u) {
      case LengthUnit.centimeters:
        return 'cm';
      case LengthUnit.inches:
        return 'in';
      case LengthUnit.feet:
        return 'ft';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          appBar: RootSliverAppBar(
            title: "Water Volume Calculator",
            implyLeading: true,
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _LabeledField(
                    label: 'Tank Shape',
                    child: _Dropdown<TankShape>(
                      value: _shape,
                      items: TankShape.values,
                      itemLabel: (s) => s == TankShape.rectangular
                          ? 'Rectangular'
                          : 'Cylindrical',
                      onChanged: (s) {
                        if (s == null) return;
                        setState(() => _shape = s);
                        _recalculate();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_shape == TankShape.rectangular) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledNumberField(
                            label: 'Length',
                            controller: _lengthCtrl,
                            suffixText: _lengthUnitLabel(_lengthUnit),
                            onChanged: (_) => _recalculate(),
                            validator: _positiveNumberValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledNumberField(
                            label: 'Width',
                            controller: _widthCtrl,
                            suffixText: _lengthUnitLabel(_lengthUnit),
                            onChanged: (_) => _recalculate(),
                            validator: _positiveNumberValidator,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _LabeledNumberField(
                      label: 'Height',
                      controller: _heightCtrl,
                      suffixText: _lengthUnitLabel(_lengthUnit),
                      onChanged: (_) => _recalculate(),
                      validator: _positiveNumberValidator,
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledNumberField(
                            label: 'Diameter',
                            controller: _diameterCtrl,
                            suffixText: _lengthUnitLabel(_lengthUnit),
                            onChanged: (_) => _recalculate(),
                            validator: _positiveNumberValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledNumberField(
                            label: 'Height',
                            controller: _heightCtrl,
                            suffixText: _lengthUnitLabel(_lengthUnit),
                            onChanged: (_) => _recalculate(),
                            validator: _positiveNumberValidator,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'Length Unit',
                          child: _Dropdown<LengthUnit>(
                            value: _lengthUnit,
                            items: LengthUnit.values,
                            itemLabel: _lengthUnitLabel,
                            onChanged: (u) {
                              if (u == null) return;
                              setState(() => _lengthUnit = u);
                              _recalculate();
                            },
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
                            onChanged: (u) {
                              if (u == null) return;
                              setState(() => _volumeUnit = u);
                              _recalculate();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(
                    result: _result,
                    unitLabel: _volumeUnitLabel(_volumeUnit),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tip: Use internal tank dimensions for accuracy.\n\nNote that actual water volume may vary due to decorations, substrate, and equipment.',
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
    );
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

class _LabeledNumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const _LabeledNumberField({
    required this.label,
    required this.controller,
    this.suffixText,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormField<String>(
      validator: (_) => validator?.call(controller.text),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 6),
              child: Text(label, style: theme.textTheme.labelMedium),
            ),
            NeoBruteBorder(
              child: TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixText: suffixText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) {
                  state.didChange(v);
                  onChanged?.call(v);
                },
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  state.errorText ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

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
                    child: Text(itemLabel(e)),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double? result;
  final String unitLabel;

  const _ResultCard({
    required this.result,
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = result == null
        ? 'Enter dimensions to calculate'
        : '${result!.toStringAsFixed(1)} $unitLabel';

    return NeoBruteBorder(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.water_drop, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Text(
              text,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
