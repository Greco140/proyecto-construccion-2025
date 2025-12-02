import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:flutter/material.dart';

class TemplatesCarousel extends StatelessWidget {
  const TemplatesCarousel({super.key, required this.viewModel});

  final TemplateListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Template>>(
      future: viewModel.getTemplateList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final templates = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              return Card(
                child: TextButton(
                  onPressed: () {
                    viewModel.selectTemplate(templates[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      templates[index].name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text("No templates found"));
      },
    );
  }
}
