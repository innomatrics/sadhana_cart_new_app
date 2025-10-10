import 'package:hive_flutter/hive_flutter.dart';

part 'search_field_model.g.dart';

@HiveType(typeId: 2)
class SearchFieldModel extends HiveObject {
  @HiveField(0)
  String? searchField;

  SearchFieldModel({this.searchField});
}
