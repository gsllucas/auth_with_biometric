import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/helper/encrypted_shared_preferences.dart';
import 'package:flutter_app/pages/helper/shared_preferences.dart';
import 'package:flutter_app/pages/shared/components/button/button.dart';
import 'package:flutter_app/pages/shared/components/text_field/text_field.dart';
import 'package:local_auth/local_auth.dart';

import 'autheticated_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  LocalAuthentication localAuth = LocalAuthentication();

  final Map<String, String> userPreferences = {'name': 'lucas', 'age': '22'};

  @override
  void initState() {
    super.initState();
    authenticateWithBiometric();
  }

  checkHasRegisteredPreferences() async {
    final preference = await getEncryptedPreferences('userPreferences');
    return preference != null && preference.isNotEmpty;
  }

  authenticateWithBiometric() async {
    final canCheckBiometric = await checkCanUserBiometric();
    final isDeviceSuported = await checkIsDeviceSupportedBiometric();
    final hasRegisteredPreferences = await checkHasRegisteredPreferences();

    if (canCheckBiometric && isDeviceSuported && hasRegisteredPreferences) {
      await availableBiometrics();
      await authenticateUserWithBiometric();
    }
  }

  Future<bool> checkCanUserBiometric() async {
    try {
      return await localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkIsDeviceSupportedBiometric() async {
    try {
      return await localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    final availableBiometrics = await localAuth.getAvailableBiometrics();
    return availableBiometrics;
  }

  authenticateUserWithBiometric() async {
    try {
      final isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Autenticação com biometria',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (isAuthenticated) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const AuthenticatedPage(loggedWithBiometric: true)));

        setPreferences();
        await SharedPreferencesHelper.setSharedPrefences();
      }
    } catch (e) {}
  }

  setPreferences() async {
    final userPreferences = json.encode(this.userPreferences);
    EncryptedSharedPreferencesHelper.savePreferences(
        key: 'userPreferences', value: userPreferences);
  }

  Future<String?> getEncryptedPreferences(String key) async {
    return await EncryptedSharedPreferencesHelper.getPreferences(key: key);
  }

  get() async {
    await SharedPreferencesHelper.getSharedPreferences();
  }

  clearAll() async {
    try {
      await EncryptedSharedPreferencesHelper.clearEncrpt();
      await SharedPreferencesHelper.clear();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    auth() async {
      final isNotAuthenticated =
          _emailController.text != 'email.teste@gmail.com' ||
              _passwordController.text != '1234';

      if (isNotAuthenticated) {
        const snackBar = SnackBar(
          content: Text('Login inválido'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      setPreferences();
      await SharedPreferencesHelper.setSharedPrefences();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AuthenticatedPage(
            loggedWithBiometric: false,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Autenticação',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Para autenticar-se, entre utilizando a biometria ou entre inserindo as credenciais abaixo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        TextFieldAuth(
                          label: 'E-mail',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          isPasswordField: false,
                        ),
                        const SizedBox(height: 20),
                        TextFieldAuth(
                          label: 'Senha',
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          isPasswordField: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          child: Button(name: 'Entrar', onPressed: auth),
                          height: 50,
                          width: double.maxFinite,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Button(
                        name: 'Ver preferências',
                        onPressed: () =>
                            getEncryptedPreferences('userPreferences')),
                    height: 50,
                  ),
                  SizedBox(
                    child: Button(
                        name: 'Limpar preferências', onPressed: clearAll),
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
