import 'package:dynadoc_front/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = context.watch<LoginViewModel>();
    return Form(
      key: viewModel.getFormKey(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Nueva cuenta", style: TextStyle(fontSize: 25)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextFormField(
              controller: viewModel.getNameController(),
              validator: (value) {
                return viewModel.validateText(value)
                    ? null
                    : "Este campo es obligatorio";
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nombre completo',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextFormField(
              controller: viewModel.getEmailController(),
              validator: (value) {
                return viewModel.validateEmail(value)
                    ? null
                    : "Introduce un correo válido";
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Correo electrónico',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextFormField(
              controller: viewModel.getPasswordController(),
              validator: (value) {
                return viewModel.validateText(value)
                    ? null
                    : "Este campo es obligatorio";
              },
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextFormField(
              controller: viewModel.getPassConfirmController(),
              validator: (value) {
                return viewModel.confirmPassword(value)
                    ? null
                    : "Las contraseñas deben ser identicas";
              },
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Confirmar contraseña',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: DropdownButtonFormField(
              items: [
                DropdownMenuItem(value: "Usuario", child: Text("Usuario")),
                DropdownMenuItem(value: "Creador", child: Text("Creador")),
              ],
              onChanged: (value) {
                if (value == "Creador") {
                  viewModel.setIsCreatorSelected(true);
                } else {
                  viewModel.setIsCreatorSelected(false);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => {viewModel.setRegistrationState(false)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Regresar", style: TextStyle(fontSize: 16)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          await viewModel.createAccount()
                              ? "¡Cuenta creada exitosamente!"
                              : "Error en la creación, intentelo nuevamente",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Crear cuenta", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
