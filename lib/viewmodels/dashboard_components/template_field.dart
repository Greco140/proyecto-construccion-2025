class TemplateField {
  final String _name;
  final bool isDynamic;
  final List<String> _children;

  TemplateField({
    required String name,
    this.isDynamic = false,
    List<String> children = const [],
  }) : _children = children,
       _name = name;

  List<String> getChildren() {
    return _children;
  }

  int length() {
    return _children.length;
  }

  String getName() {
    return _name;
  }
}
