class TemplateField {
  String _name = '';
  String _content = '';

  TemplateField({required String name, required String content}) {
    _name = name;
    _content = content;
  }

  Map<String, dynamic> toJson() => {'name': _name, 'content': _content};

  getName() {
    return _name;
  }

  getContent() {
    return _content;
  }

  setContent(String content) {
    _content = content;
  }
}
