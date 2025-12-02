import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:dynadoc_front/views/Dashboard/Widgets/fields_widget.dart';
import 'package:dynadoc_front/views/Dashboard/Widgets/pdf_widget.dart';
import 'package:dynadoc_front/views/Dashboard/Widgets/templates_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplateListWidget extends StatelessWidget {
  const TemplateListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TemplateListViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna 1
          Column(
            children: [
              const Text("Plantillas", style: TextStyle(fontSize: 25)),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  width: 350,
                  child: TemplatesCarousel(viewModel: viewModel),
                ),
              ),
            ],
          ),
          SizedBox(width: 400, child: FieldsList(viewModel: viewModel)),
          // COLUMN 3: PDF Preview
          PdfViewer(viewModel: viewModel),
        ],
      ),
    );
  }
}
