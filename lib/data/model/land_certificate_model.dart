import 'package:isar/isar.dart';

part 'land_certificate_model.g.dart';

@collection
class LandCertificateModel {
  Id id = Isar.autoIncrement;
  String? name;
  List<String>? files;
  String? combineAddressId;
  String? combineAddressName;
  DateTime? purchaseDate;
  double? purchasePrice;
  DateTime? saleDate;
  double? salePrice;

  //Thửa đất số
  int? number;

  //Bản đồ số
  int? mapNumber;

  //Diện tích
  double? area;

  //Hình thức sử dụng
  String? useType;

  //Mục đích sử dụng
  String? purpose;

  //Thời gian sử dụng
  DateTime? useTime;

  //Đất ở
  String? residentialArea;

  //Cây lâu năm
  String? perennialTreeArea;

  //Thời điểm đóng thuế
  DateTime? taxTime;

  //Thời điểm gia hạn thuế
  DateTime? taxRenewalTime;

  String? note;
}
