import 'package:dynadoc_front/viewmodels/dashboard_components/template_field.dart';
import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:flutter/material.dart';

class DynamicFieldWidget extends StatelessWidget {
  final TemplateListViewModel viewModel;
  final TemplateField field;

  const DynamicFieldWidget({
    super.key,
    required this.viewModel,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final rows = viewModel.getLoopRows(field.getName());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                field.getName().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.purple),
                onPressed: () =>
                    viewModel.addLoopRow(field.getName(), field.getChildren()),
                tooltip: "Agregar item",
              ),
            ],
          ),

          ...List.generate(rows.length, (rowIndex) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Boton de borrado solo se muestra si hay mas de 1 campo
                    if (rows.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => viewModel.removeLoopRow(
                            field.getName(),
                            rowIndex,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),

                    ...field.getChildren().map((childName) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: rows[rowIndex][childName],
                          decoration: InputDecoration(
                            labelText: childName,
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
