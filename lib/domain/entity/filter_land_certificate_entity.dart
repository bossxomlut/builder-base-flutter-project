import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_land_certificate_entity.freezed.dart';

@freezed
class FilterLandCertificateEntity with _$FilterLandCertificateEntity {
  factory FilterLandCertificateEntity({
    // Purchase date
    DateTime? purchaseDateFrom,
    DateTime? purchaseDateTo,

    // Sale date
    DateTime? saleDateFrom,
    DateTime? saleDateTo,

    // Tax deadline time
    DateTime? taxDeadlineTimeFrom,
    DateTime? taxDeadlineTimeTo,

    // Tax renewal time
    DateTime? taxRenewalTimeFrom,
    DateTime? taxRenewalTimeTo,

    // Price
    double? purchasePriceFrom,
    double? purchasePriceTo,
    double? salePriceFrom,
    double? salePriceTo,

    // Area
    double? areaFrom,
    double? areaTo,
  }) = _FilterLandCertificateEntity;

  const FilterLandCertificateEntity._();
}

extension FilterLandCertificateEntityX on FilterLandCertificateEntity {
  bool get isValid {
    return purchaseDateFrom != null ||
        purchaseDateTo != null ||
        saleDateFrom != null ||
        saleDateTo != null ||
        taxDeadlineTimeFrom != null ||
        taxDeadlineTimeTo != null ||
        taxRenewalTimeFrom != null ||
        taxRenewalTimeTo != null ||
        purchasePriceFrom != null ||
        purchasePriceTo != null ||
        salePriceFrom != null ||
        salePriceTo != null ||
        areaFrom != null ||
        areaTo != null;
  }
}
