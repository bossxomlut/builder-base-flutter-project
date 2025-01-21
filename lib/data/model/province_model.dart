import 'package:isar/isar.dart';

part 'province_model.g.dart';

@collection
class ProvinceModel {
  Id id = Isar.autoIncrement;
  String? name;
}

@collection
class DistrictModel {
  Id id = Isar.autoIncrement;
  int? provinceId;
  String? name;
}

@collection
class WardModel {
  Id id = Isar.autoIncrement;
  int? districtId;
  String? name;
}

// @collection
// class NoteGroupCollection {
//   Id id = Isar.autoIncrement;
//   String? name;
//   DateTime? updatedDateTime;
//   bool? isDeleted;
// }
//
// @collection
// class NoteCollection {
//   Id id = Isar.autoIncrement;
//   int? groupId;
//   String? description;
//   bool? isDone;
//   bool? isDeleted;
//   DateTime? date;
//   DateTime? updatedDateTime;
//   List<AttachmentCollection>? attachments;
// }
//
// @embedded
// class AttachmentCollection {
//   final String? path;
//   final String? name;
//
//   AttachmentCollection({
//     this.path,
//     this.name,
//   });
// }
