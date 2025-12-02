import 'package:dynadoc_front/models/template_field.dart';
import 'package:dynadoc_front/models/user.dart';

class Template {
  final int? _id;
  final String _name;
  final String _content;
  final bool _isPublic;
  final User? _owner;
  final List<TemplateField> _fields;

  Template({
    int? id,
    required String name,
    required String content,
    bool isPublic = false,
    User? owner,
    List<TemplateField> fields = const [],
  }) : _fields = fields,
       _owner = owner,
       _isPublic = isPublic,
       _content = content,
       _name = name,
       _id = id;

  factory Template.fromJson(Map<String, dynamic> json) {
    bool publicValue = false;
    if (json.containsKey('isPublic')) {
      publicValue = json['isPublic'];
    } else if (json.containsKey('public')) {
      publicValue = json['public'];
    }

    List<TemplateField> parsedFields = [];
    if (json['placeholders'] != null) {
      parsedFields = (json['placeholders'] as List).map((placeholderName) {
        return TemplateField(name: placeholderName.toString(), content: '');
      }).toList();
    }

    return Template(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      isPublic: publicValue,
      owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      fields: parsedFields,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': _name,
      'content': _content,
      'isPublic': _isPublic,
    };
    if (_id != null) data['id'] = _id;
    if (_owner != null) data['owner'] = _owner.toJson();
    return data;
  }

  int? get id => _id;
  String get name => _name;
  String get content => _content;
  bool get isPublic => _isPublic;
  User? get owner => _owner;
  List<TemplateField> get fields => _fields;
}
