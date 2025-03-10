import '../../resource/index.dart';
import '../index.dart';

// ==========================
// BASE CLASS - Specification Pattern
// ==========================
abstract class Specification<T> {
  bool isSatisfiedBy(T item);

  Specification<T> and(Specification<T> other) {
    return _AndSpecification(this, other);
  }

  Specification<T> or(Specification<T> other) {
    return _OrSpecification(this, other);
  }
}

class _AndSpecification<T> extends Specification<T> {
  final Specification<T> one;
  final Specification<T> other;

  _AndSpecification(this.one, this.other);

  @override
  bool isSatisfiedBy(T item) {
    return one.isSatisfiedBy(item) && other.isSatisfiedBy(item);
  }
}

class _OrSpecification<T> extends Specification<T> {
  final Specification<T> one;
  final Specification<T> other;

  _OrSpecification(this.one, this.other);

  @override
  bool isSatisfiedBy(T item) {
    return one.isSatisfiedBy(item) || other.isSatisfiedBy(item);
  }
}

// ==========================
// SPECIFICATIONS
// ==========================
class KeywordSpecification extends Specification<LandCertificateEntity> {
  final String keyword;

  KeywordSpecification(this.keyword);

  @override
  bool isSatisfiedBy(LandCertificateEntity item) {
    final lowerKeyword = keyword.toLowerCase();
    final other = LKey.other.tr().toLowerCase();
    return [
      item.name,
      item.province?.name ?? other,
      item.district?.name ?? other,
      item.ward?.name,
      item.detailAddress,
      item.note,
      item.useType,
      item.purpose,
    ].any((value) => value?.toLowerCase().contains(lowerKeyword) ?? false);
  }
}

class ProvinceSpecification extends Specification<LandCertificateEntity> {
  final int provinceId;

  ProvinceSpecification(this.provinceId);

  @override
  bool isSatisfiedBy(LandCertificateEntity item) {
    if (provinceId == -1) {
      return item.province == null;
    }

    return item.province?.id == provinceId;
  }
}

class DistrictSpecification extends Specification<LandCertificateEntity> {
  final int districtId;

  DistrictSpecification(this.districtId);

  @override
  bool isSatisfiedBy(LandCertificateEntity item) {
    if (districtId == -1) {
      return item.district == null;
    }

    return item.district?.id == districtId;
  }
}

class WardSpecification extends Specification<LandCertificateEntity> {
  final int wardId;

  WardSpecification(this.wardId);

  @override
  bool isSatisfiedBy(LandCertificateEntity item) {
    if (wardId == -1) {
      return item.ward == null;
    }

    return item.ward?.id == wardId;
  }
}

class FilterSpecification extends Specification<LandCertificateEntity> {
  final FilterLandCertificateEntity filter;

  FilterSpecification(this.filter);

  @override
  bool isSatisfiedBy(LandCertificateEntity item) {
    // 🗓️ Tìm kiếm theo ngày mua
    if (filter.purchaseDateFrom != null &&
        (item.purchaseDate == null || item.purchaseDate!.isBefore(filter.purchaseDateFrom!))) {
      return false;
    }
    if (filter.purchaseDateTo != null &&
        (item.purchaseDate == null || item.purchaseDate!.isAfter(filter.purchaseDateTo!))) {
      return false;
    }

    // 🗓️ Tìm kiếm theo ngày bán
    if (filter.saleDateFrom != null && (item.saleDate == null || item.saleDate!.isBefore(filter.saleDateFrom!))) {
      return false;
    }
    if (filter.saleDateTo != null && (item.saleDate == null || item.saleDate!.isAfter(filter.saleDateTo!))) {
      return false;
    }

    // 💰 Tìm kiếm theo giá mua
    if (filter.purchasePriceFrom != null &&
        (item.purchasePrice == null || item.purchasePrice! < filter.purchasePriceFrom!)) {
      return false;
    }
    if (filter.purchasePriceTo != null &&
        (item.purchasePrice == null || item.purchasePrice! > filter.purchasePriceTo!)) {
      return false;
    }

    // 💰 Tìm kiếm theo giá bán
    if (filter.salePriceFrom != null && (item.salePrice == null || item.salePrice! < filter.salePriceFrom!)) {
      return false;
    }
    if (filter.salePriceTo != null && (item.salePrice == null || item.salePrice! > filter.salePriceTo!)) {
      return false;
    }

    // 📏 Tìm kiếm theo diện tích (tính theo tổng diện tích)
    if (filter.areaFrom != null && (item.totalAllArea < filter.areaFrom!)) {
      return false;
    }
    if (filter.areaTo != null && (item.totalAllArea > filter.areaTo!)) {
      return false;
    }

    // 🗓️ Tìm kiếm theo ngày đóng thuế
    if (filter.taxDeadlineTimeFrom != null &&
        (item.taxDeadlineTime == null || item.taxDeadlineTime!.isBefore(filter.taxDeadlineTimeFrom!))) {
      return false;
    }
    if (filter.taxDeadlineTimeTo != null &&
        (item.taxDeadlineTime == null || item.taxDeadlineTime!.isAfter(filter.taxDeadlineTimeTo!))) {
      return false;
    }

    // 🗓️ Tìm kiếm theo ngày gia hạn thuế
    if (filter.taxRenewalTimeFrom != null &&
        (item.taxRenewalTime == null || item.taxRenewalTime!.isBefore(filter.taxRenewalTimeFrom!))) {
      return false;
    }
    if (filter.taxRenewalTimeTo != null &&
        (item.taxRenewalTime == null || item.taxRenewalTime!.isAfter(filter.taxRenewalTimeTo!))) {
      return false;
    }

    return true;
  }
}

// ==========================
// BUILDER CLASS
// ==========================
class LandCertificateSearchBuilder {
  final List<Specification<LandCertificateEntity>> _specifications = [];

  LandCertificateSearchBuilder keyword(String keyword) {
    _specifications.add(KeywordSpecification(keyword));
    return this;
  }

  LandCertificateSearchBuilder filter(FilterLandCertificateEntity filter) {
    _specifications.add(FilterSpecification(filter));
    return this;
  }

  LandCertificateSearchBuilder province(int provinceId) {
    _specifications.add(ProvinceSpecification(provinceId));
    return this;
  }

  LandCertificateSearchBuilder district(int districtId) {
    _specifications.add(DistrictSpecification(districtId));
    return this;
  }

  LandCertificateSearchBuilder ward(int wardId) {
    _specifications.add(WardSpecification(wardId));
    return this;
  }

  LandCertificateSearchBuilder and() {
    if (_specifications.length >= 2) {
      var last = _specifications.removeLast();
      var secondLast = _specifications.removeLast();
      _specifications.add(secondLast.and(last));
    }
    return this;
  }

  LandCertificateSearchBuilder or() {
    if (_specifications.length >= 2) {
      var last = _specifications.removeLast();
      var secondLast = _specifications.removeLast();
      _specifications.add(secondLast.or(last));
    }
    return this;
  }

  List<LandCertificateEntity> search(List<LandCertificateEntity> data) {
    if (_specifications.isEmpty) return data;
    var combinedSpec = _specifications.reduce((a, b) => a.and(b));
    return data.where((item) => combinedSpec.isSatisfiedBy(item)).toList();
  }
}
