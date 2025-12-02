import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:dynadoc_front/views/Dashboard/templates_carousel.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class TemplateListWidget extends StatelessWidget {
  const TemplateListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the ViewModel
    final viewModel = context.watch<TemplateListViewModel>();
    final structure = viewModel.formStructure;

    // Safety check for selected template
    final fields = viewModel.selectedTemplate?.fields ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 30,
      ), // Reduced padding for better fit
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLUMN 1: Template Selection
          Column(
            children: [
              const Text("Plantillas", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  width: 350,
                  // Pass the VM or let the carousel access it via Provider
                  child: TemplatesCarousel(viewModel: viewModel),
                ),
              ),
            ],
          ),

          // COLUMN 2: Form Input
          // COLUMN 2: Form Input
          SizedBox(
            width: 400,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      viewModel.selectedTemplate?.name ??
                          "Seleccione Plantilla",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: structure.isEmpty
                          ? const Center(
                              child: Text("Sin campos configurables"),
                            )
                          : ListView.builder(
                              itemCount: structure.length,
                              itemBuilder: (context, index) {
                                final item = structure[index];

                                if (item.isLoop) {
                                  // RENDER A DYNAMIC SECTION (Table-like)
                                  return _buildLoopSection(
                                    context,
                                    viewModel,
                                    item,
                                  );
                                } else {
                                  // RENDER A SIMPLE TEXT FIELD
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: TextField(
                                      controller: viewModel.getSimpleController(
                                        item.name,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: item.name,
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: viewModel.isLoading
                              ? null // Disable while loading
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
                            viewModel.isLoading
                                ? "Generando..."
                                : "Generar PDF",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // COLUMN 3: PDF Preview
          Column(
            children: [
              const Text("Vista Previa", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  // Logic to handle Null Controller (Empty State)
                  child: viewModel.pdfController == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                              Text(
                                "Genere un documento para ver la vista previa",
                              ),
                            ],
                          ),
                        )
                      : PdfView(
                          controller: viewModel.pdfController!,
                          scrollDirection: Axis.vertical,
                          pageSnapping:
                              false, // Usually better false for vertical docs
                        ),
                ),
              ),
              // Pagination Controls (Only show if controller exists)
              if (viewModel.pdfController != null)
                PdfPageNumber(
                  controller: viewModel.pdfController!,
                  builder: (_, state, page, pagesCount) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Página $page de ${pagesCount ?? 0}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- HELPER WIDGET FOR DYNAMIC SECTIONS ---
Widget _buildLoopSection(
  BuildContext context,
  TemplateListViewModel vm,
  FormSection section,
) {
  final rows = vm.getLoopRows(section.name);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(8),
      color: Colors.blue.withOpacity(0.05),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Name + Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              section.name.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: () => vm.addLoopRow(section.name, section.children),
              tooltip: "Agregar item",
            ),
          ],
        ),
        // List of Rows
        ...List.generate(rows.length, (rowIndex) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Row Header with Delete button
                  if (rows.length > 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => vm.removeLoopRow(section.name, rowIndex),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),

                  // The Inner Fields (nombre, precio)
                  ...section.children.map((childName) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        // Get the specific controller for this row and field
                        controller: rows[rowIndex][childName],
                        decoration: InputDecoration(
                          labelText: childName,
                          isDense: true, // Make it compact
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
