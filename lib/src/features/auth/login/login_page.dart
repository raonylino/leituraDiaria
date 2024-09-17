import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oceans/src/features/auth/login/controller_login.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool success = false;
  bool _isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOF = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                height: 250,
                width: sizeOF.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(200),
                  ),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: sizeOF.width * .8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Email:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: emailEC,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Digite seu Email',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required('Email obrigatorio'),
                          Validatorless.email('Email invalido'),
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Senha:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: obscurePassword,
                        controller: passwordEC,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Digite sua Senha',
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: obscurePassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatoria'),
                          Validatorless.min(6,
                              'Sua senha deve conter no minimo 6 caracteres'),
                          Validatorless.max(20,
                              'Sua senha deve conter no maximo 20 caracteres'),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: sizeOF.width * .8,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(21, 39, 65, 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    Timer(const Duration(seconds: 5), () {
                                      if (_isLoading) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Email ou Senha Incorreta'),
                                          ),
                                        );
                                      }
                                    });

                                    final isadm = await ControllerLogin.isAdm(
                                        emailEC.text);
                                    await ControllerLogin.login(
                                      emailEC.text,
                                      passwordEC.text,
                                      // ignore: use_build_context_synchronously
                                      context,
                                      (bool success) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (success) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(isadm
                                                  ? '/contact/list/admin'
                                                  : '/contact/list');
                                        }
                                      },
                                    );
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(21, 39, 65, 1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não possui conta? Clique aqui para',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/auth/email_password/register');
                                },
                                child: const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                      color: Color.fromRGBO(21, 39, 65, 1)),
                                ))
                          ],
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: sizeOF.height * .2,
              ),
              Container(
                width: sizeOF.width,
                height: 80,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(200),
                      topLeft: Radius.circular(200),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
