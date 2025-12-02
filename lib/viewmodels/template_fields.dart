import 'package:flutter/material.dart';

class TemplateField {
  final String name;
  final bool isDynamic;
  final List<String> children;

  TemplateField({
    required this.name,
    this.isDynamic = false,
    this.children = const [],
  });

  List<String> getChildren() {
    return children;
  }

  int length() {
    return children.length;
  }
}

class TemplateFields {
  final Map<String, TextEditingController> _simpleControllers = {};
  final Map<String, List<Map<String, TextEditingController>>> _loopControllers =
      {};
  final List<TemplateField> _fields = [];

  TextEditingController? getSimpleController(String name) =>
      _simpleControllers[name];
  List<Map<String, TextEditingController>> getLoopRows(String sectionName) {
    return _loopControllers[sectionName] ?? [];
  }

  TemplateField getField(int index) => _fields[index];

  generateFields(List<String> rawFields) {
    int i = 0;
    while (i < rawFields.length) {
      String field = rawFields[i];

      if (field.startsWith('#')) {
        String sectionName = field.substring(1);
        List<String> children = [];
        i++;

        while (i < rawFields.length &&
            !rawFields[i].startsWith('/$sectionName')) {
          if (!rawFields[i].startsWith('/')) {
            children.add(rawFields[i]);
          }
          i++;
        }
        // Campo dinamico
        _fields.add(
          TemplateField(name: sectionName, isDynamic: true, children: children),
        );
        _loopControllers[sectionName] = [];
        addLoopRow(sectionName, children);
      } else if (!field.startsWith('/')) {
        // Campo simple
        _fields.add(TemplateField(name: field, isDynamic: false));
        _simpleControllers[field] = TextEditingController();
      }
      i++;
    }
  }

  void addLoopRow(String sectionName, List<String> childFields) {
    Map<String, TextEditingController> newRow = {};
    for (var field in childFields) {
      newRow[field] = TextEditingController();
    }
    _loopControllers[sectionName]?.add(newRow);
  }

  void removeLoopRow(String sectionName, int index) {
    if ((_loopControllers[sectionName]?.length ?? 0) > 1) {
      _loopControllers[sectionName]?.removeAt(index);
    }
  }

  Map<String, Object> getFieldsAsMap() {
    Map<String, Object> data = {};

    _simpleControllers.forEach((key, controller) {
      data[key] = controller.text;
    });

    _loopControllers.forEach((sectionName, rows) {
      List<Map<String, String>> serializedRows = [];
      for (var row in rows) {
        Map<String, String> rowData = {};
        row.forEach((key, controller) {
          rowData[key] = controller.text;
        });
        serializedRows.add(rowData);
      }
      data[sectionName] = serializedRows;
    });

    return data;
  }

  clear() {
    _fields.clear();
    _simpleControllers.clear();
    _loopControllers.clear();
  }

  bool isEmpty() {
    return _fields.isEmpty;
  }

  int length() {
    return _fields.length;
  }
}
