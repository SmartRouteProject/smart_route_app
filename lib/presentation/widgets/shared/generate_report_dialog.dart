import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/enums/package_weight_type.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/shared/custom_dropdown_button_form_field.dart';

class GenerateReportDialog extends ConsumerWidget {
  const GenerateReportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportFormProvider);
    final notifier = ref.read(reportFormProvider.notifier);
    final dateRangeText = state.dateRange == null
        ? ''
        : '${_formatDate(state.dateRange!.start)} - ${_formatDate(state.dateRange!.end)}';

    return AlertDialog(
      title: const Text('Generar reporte', textAlign: TextAlign.center),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _pickDateRange(notifier, state.dateRange, context),
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Rango de fechas',
                  suffixIcon: Icon(Icons.date_range),
                ),
                child: Text(
                  dateRangeText.isEmpty ? 'Seleccionar' : dateRangeText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomDropdownButtonFormField<PackageWeightType>(
              label: 'Tipo de paquete',
              value: state.packageType,
              items: PackageWeightType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(),
              onChanged: notifier.onPackageTypeChanged,
            ),
            const SizedBox(height: 12),
            CustomDropdownButtonFormField<ReportDocumentType>(
              label: 'Tipo de documento',
              value: state.documentType,
              items: ReportDocumentType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(),
              onChanged: notifier.onDocumentTypeChanged,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.isPosting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: state.isPosting
              ? null
              : () async {
                  final success = await notifier.onSubmit();
                  if (success && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
          child: state.isPosting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Aceptar'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Future<void> _pickDateRange(
    ReportFormNotifier notifier,
    DateTimeRange? currentRange,
    BuildContext context,
  ) async {
    final now = DateTime.now();
    final initialRange =
        currentRange ??
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

    notifier.onDateRangeChanged(range);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
