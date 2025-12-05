import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynadoc_front/viewmodels/my_templates_view_model.dart';

class MyTemplatesView extends StatefulWidget {
  const MyTemplatesView({super.key});

  @override
  State<MyTemplatesView> createState() => _MyTemplatesViewState();
}

class _MyTemplatesViewState extends State<MyTemplatesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyTemplatesViewModel>().loadPrivateTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyTemplatesViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Mis plantillas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),

                // Error message
                if (viewModel.errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            viewModel.errorMessage,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (viewModel.errorMessage.isNotEmpty)
                  const SizedBox(height: 16),

                // Loading indicator
                if (viewModel.isLoading && viewModel.selectedTemplate == null)
                  const Center(child: CircularProgressIndicator())
                else if (viewModel.privateTemplates.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aun no tiene plantillas privadas.\nCree una nueva desde la sección de crear plantilla.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      // Templates list
                      if (viewModel.selectedTemplate == null) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.privateTemplates.length,
                          itemBuilder: (context, index) {
                            final template = viewModel.privateTemplates[index];
                            return Card(
                              child: ListTile(
                                title: Text(template.name),
                                subtitle: Text(
                                  template.content.length > 100
                                      ? '${template.content.substring(0, 100)}...'
                                      : template.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.edit),
                                onTap: () => viewModel.selectTemplate(template),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        // Edit form
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Editando: ${viewModel.selectedTemplate!.name}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                // Title field
                                TextField(
                                  controller: viewModel.titleController,
                                  decoration: InputDecoration(
                                    labelText: 'Título',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Content field
                                TextField(
                                  controller: viewModel.contentController,
                                  decoration: InputDecoration(
                                    labelText: 'Contenido',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  maxLines: 8,
                                ),
                                const SizedBox(height: 16),
                                // Action buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => viewModel.clearSelection(),
                                      icon: const Icon(Icons.close),
                                      label: const Text('Cancelar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => _showDeleteConfirmation(
                                              context,
                                              viewModel,
                                            ),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Eliminar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => viewModel
                                                .updateSelectedTemplate(),
                                      icon: const Icon(Icons.save),
                                      label: const Text('Actualizar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    MyTemplatesViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Plantilla'),
        content: Text(
          'Estas seguro de eliminar "${viewModel.selectedTemplate!.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteTemplate(viewModel.selectedTemplate!).then((_) {
                Navigator.pop(context);
              });
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
