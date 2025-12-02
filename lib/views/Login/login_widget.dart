import 'package:dynadoc_front/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 320,
              child: Image(image: AssetImage('assets/images/logo.png')),
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
                    : 'Este campo es obligatorio';
              },
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => {viewModel.setRegistrationState(true)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Nueva Cuenta", style: TextStyle(fontSize: 16)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = await viewModel.login();
                    if (success) {
                      Navigator.popAndPushNamed(context, '/dashboard');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error en inicio de sesión, intentelo nuevamente",
                          ),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Iniciar Sesión",
                      style: TextStyle(fontSize: 16),
                    ),
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
