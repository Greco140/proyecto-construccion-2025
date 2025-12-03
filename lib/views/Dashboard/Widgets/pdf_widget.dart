import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends StatelessWidget {
  const PdfViewer({super.key, required this.viewModel});

  final TemplateListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        Text("Genere un documento para ver la vista previa"),
                      ],
                    ),
                  )
                : PdfView(
                    controller: viewModel.pdfController!,
                    scrollDirection: Axis.vertical,
                    pageSnapping: false,
                  ),
          ),
        ),
        if (viewModel.pdfController != null)
          Row(
            children: [
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green for download
                  foregroundColor: Colors.white,
                ),
                onPressed: () => viewModel.downloadPdf(),
                icon: const Icon(Icons.download),
                label: const Text("Descargar"),
              ),
            ],
          ),
      ],
    );
  }
}
