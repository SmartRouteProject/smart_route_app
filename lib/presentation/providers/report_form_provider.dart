import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/enums/package_weight_type.dart';

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
      return ReportFormNotifier();
    });

class ReportFormNotifier extends StateNotifier<ReportFormState> {
  ReportFormNotifier()
    : super(
        ReportFormState(
          dateRange: _todayRange(),
          packageType: PackageWeightType.under_25kg,
          documentType: ReportDocumentType.pdf,
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

  void onSubmit() {
    debugPrint('Report dateRange: ${state.dateRange}');
    debugPrint('Report packageType: ${state.packageType}');
    debugPrint('Report documentType: ${state.documentType}');
  }
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

  const ReportFormState({this.dateRange, this.packageType, this.documentType});

  bool get isValid =>
      dateRange != null && packageType != null && documentType != null;

  ReportFormState copyWith({
    DateTimeRange? dateRange,
    PackageWeightType? packageType,
    ReportDocumentType? documentType,
  }) => ReportFormState(
    dateRange: dateRange ?? this.dateRange,
    packageType: packageType ?? this.packageType,
    documentType: documentType ?? this.documentType,
  );
}
