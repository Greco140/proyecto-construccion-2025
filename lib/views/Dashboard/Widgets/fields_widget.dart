import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:dynadoc_front/views/Dashboard/Widgets/dynamic_field_widget.dart';
import 'package:flutter/material.dart';

class FieldsList extends StatelessWidget {
  const FieldsList({super.key, required this.viewModel});

  final TemplateListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final fieldList = viewModel.templateFields;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //TITULO PLANTILLA
            Text(
              viewModel.selectedTemplate?.name ?? "Seleccione Plantilla",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            //CAMPOS
            Expanded(
              child: fieldList.isEmpty()
                  ? const Center(child: Text("Sin campos configurables"))
                  : ListView.builder(
                      itemCount: fieldList.length(),
                      itemBuilder: (context, index) {
                        final item = fieldList.getField(index);

                        if (item.isDynamic) {
                          return DynamicFieldWidget(
                            viewModel: viewModel,
                            field: item,
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              controller: fieldList.getSimpleController(
                                item.getName(),
                              ),
                              decoration: InputDecoration(
                                labelText: item.getName(),
                                border: const OutlineInputBorder(),
                                filled: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),
            //BOTON DE GENERAR
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: viewModel.isLoading
                      ? null
                      : () => viewModel.generateDocument(),
                  icon: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(
                    viewModel.isLoading ? "Generando..." : "Generar PDF",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
