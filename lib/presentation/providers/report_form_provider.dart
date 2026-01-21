import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

enum ReportDocumentType { pdf, excel }

extension ReportDocumentTypeExt on ReportDocumentType {
  String get label {
    switch (this) {
      case ReportDocumentType.pdf:
        return 'PDF';
      case ReportDocumentType.excel:
        return 'Excel';
    }
  }
}

final reportFormProvider =
    StateNotifierProvider.autoDispose<ReportFormNotifier, ReportFormState>((
      ref,
    ) {
      return ReportFormNotifier(reportRepository: ReportRepositoryImpl());
    });

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  final IReportRepository reportRepository;

  ReportFormNotifier({required this.reportRepository})
    : super(
        ReportFormState(
          dateRange: _todayRange(),
          packageType: PackageWeightType.under_25kg,
          documentType: ReportDocumentType.pdf,
          errorMessage: '',
        ),
      );

  void onDateRangeChanged(DateTimeRange range) {
    state = state.copyWith(dateRange: range);
  }

  void onPackageTypeChanged(PackageWeightType? value) {
    state = state.copyWith(packageType: value);
  }

  void onDocumentTypeChanged(ReportDocumentType? value) {
    state = state.copyWith(documentType: value);
  }

  Future<bool> onSubmit() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Formulario incompleto');
      return false;
    }

    try {
      state = state.copyWith(isPosting: true, errorMessage: '');
      final dateRange = state.dateRange!;
      final packageType = state.packageType!;
      final documentType = state.documentType!;
      final dto = GeneratePackagesReportDto(
        from: dateRange.start,
        to: dateRange.end,
        weightFilter: packageType,
        format: documentType.label,
      );

      final bytes = await reportRepository.generatePackagesReport(dto);
      final extension = _reportFileExtension(documentType);
      final filePath = await _writeTempReport(bytes, extension);
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        state = state.copyWith(
          isPosting: false,
          errorMessage: 'No se pudo abrir el archivo',
        );
        return false;
      }
      state = state.copyWith(isPosting: false, errorMessage: '');
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(isPosting: false, errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'No se pudo generar el reporte',
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }
}

String _reportFileExtension(ReportDocumentType documentType) {
  if (documentType == ReportDocumentType.pdf) return 'pdf';
  return 'xlsx';
}

Future<String> _writeTempReport(List<int> bytes, String extension) async {
  final directory = await getTemporaryDirectory();
  final fileName =
      'reporte_paquetes_${DateTime.now().millisecondsSinceEpoch}.$extension';
  final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
  final file = File(filePath);
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

DateTimeRange _todayRange() {
  final now = DateTime.now();
  final day = DateTime(now.year, now.month, now.day);
  return DateTimeRange(start: day, end: day);
}

class ReportFormState {
  final DateTimeRange? dateRange;
  final PackageWeightType? packageType;
  final ReportDocumentType? documentType;
  final String errorMessage;
  final bool isPosting;

  const ReportFormState({
    this.dateRange,
    this.packageType,
    this.documentType,
    this.errorMessage = '',
    this.isPosting = false,
  });

  bool get isValid =>
      dateRange != null && packageType != null && documentType != null;

  ReportFormState copyWith({
    DateTimeRange? dateRange,
    PackageWeightType? packageType,
    ReportDocumentType? documentType,
    String? errorMessage,
    bool? isPosting,
  }) => ReportFormState(
    dateRange: dateRange ?? this.dateRange,
    packageType: packageType ?? this.packageType,
    documentType: documentType ?? this.documentType,
    errorMessage: errorMessage ?? this.errorMessage,
    isPosting: isPosting ?? this.isPosting,
  );
}
