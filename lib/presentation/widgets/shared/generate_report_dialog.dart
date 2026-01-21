import 'package:flutter/material.dart';

import 'package:smart_route_app/domain/enums/package_weight_type.dart';
import 'package:smart_route_app/presentation/widgets/shared/custom_dropdown_button_form_field.dart';

class GenerateReportDialog extends StatefulWidget {
  const GenerateReportDialog({super.key});

  @override
  State<GenerateReportDialog> createState() => _GenerateReportDialogState();
}

class _GenerateReportDialogState extends State<GenerateReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateRangeController = TextEditingController();

  DateTimeRange? _selectedRange;
  PackageWeightType? _selectedPackageType;
  String? _selectedDocumentType;

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initialRange =
        _selectedRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, now.day - 7),
          end: DateTime(now.year, now.month, now.day),
        );
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      initialDateRange: initialRange,
    );
    if (range == null) return;

    setState(() {
      _selectedRange = range;
      _dateRangeController.text =
          '${_formatDate(range.start)} - ${_formatDate(range.end)}';
    });
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generar reporte', textAlign: TextAlign.center),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _dateRangeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Rango de fechas',
                suffixIcon: Icon(Icons.date_range),
              ),
              onTap: _pickDateRange,
            ),
            const SizedBox(height: 12),
            CustomDropdownButtonFormField<PackageWeightType>(
              label: 'Tipo de paquete',
              value: _selectedPackageType,
              items: PackageWeightType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedPackageType = value;
              }),
            ),
            const SizedBox(height: 12),
            CustomDropdownButtonFormField<String>(
              label: 'Tipo de documento',
              value: _selectedDocumentType,
              items: const [
                DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                DropdownMenuItem(value: 'excel', child: Text('Excel')),
              ],
              onChanged: (value) => setState(() {
                _selectedDocumentType = value;
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Aceptar'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
