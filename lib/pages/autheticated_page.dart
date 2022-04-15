import 'package:flutter/material.dart';

class AuthenticatedPage extends StatelessWidget {
  final bool loggedWithBiometric;

  const AuthenticatedPage({
    Key? key,
    required this.loggedWithBiometric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenText = loggedWithBiometric
        ? 'Sua biometria foi validada com sucesso!'
        : 'Login realizado com as credenciais';

    return Scaffold(
      appBar: AppBar(title: const Text('Sucesso')),
      body: Center(child: Text(screenText)),
    );
  }
}
