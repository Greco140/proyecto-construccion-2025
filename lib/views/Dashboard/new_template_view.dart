import 'package:dynadoc_front/network/jwt_key.dart';
import 'package:dynadoc_front/viewmodels/new_template_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTemplateWidget extends StatelessWidget {
  const NewTemplateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NewTemplateViewModel>();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 8,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Crear Nueva Plantilla",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: viewModel.nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre de la Plantilla",
                    labelStyle: const TextStyle(color: Colors.purple),
                    prefixIcon: const Icon(Icons.label, color: Colors.purple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.purple,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Contenido (HTML / Texto)",
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 400,
                  child: TextField(
                    controller: viewModel.contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "<html><body>\n  <h1>Hola {{nombre}}</h1>\n</body></html>",
                      filled: true,
                      fillColor: Colors.purple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.purple,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // SAVE BUTTON
                SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            // Call ViewModel
                            bool success = await viewModel.createTemplate();

                            if (context.mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Plantilla creada exitosamente",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                viewModel.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Error: El nombre y el contenido son obligatorios",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.save_as, size: 28),
                          label: const Text(
                            "GUARDAR PLANTILLA",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: JwtKey().getUserRole(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.data == 'ADMIN' ||
                              snapshot.data == 'CREADOR') {
                            return Row(
                              children: [
                                Checkbox(
                                  value: viewModel.isPublic,
                                  onChanged: (bool? newValue) => viewModel
                                      .setCreateAsPublic(newValue ?? false),
                                  semanticLabel: 'Crear como pública',
                                ),
                                const Text('Crear como pública'),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
