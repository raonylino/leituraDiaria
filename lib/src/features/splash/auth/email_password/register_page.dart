import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:oceans/src/features/splash/auth/email_password/controller_register.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
      backgroundColor: Colors.blue,
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
                          Validatorless.email('Email inválido'),
                          Validatorless.required('Email obrigatório'),
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
                        obscureText: true,
                        controller: passwordEC,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Digite sua Senha',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(6, 'conter no minimo 6 caracteres'),
                          Validatorless.max(
                              20, 'conter no maximo 20 caracteres'),
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Confirme sua senha:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Digite sua Senha novamente',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(6, 'conter no minimo 6 caracteres'),
                          Validatorless.max(
                              20, 'conter no maximo 20 caracteres'),
                          Validatorless.compare(
                              passwordEC, 'As senhas não conferem'),
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
                            backgroundColor: Colors.grey.shade300,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          },
                          child: const Text(
                            'Voltar',
                            style: TextStyle(
                              color: Color.fromRGBO(21, 39, 65, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await ControllerRegister.register(
                                  emailEC.text, passwordEC.text);
                              Dialogs.materialDialog(
                                  customView: SizedBox(
                                    height: 200,
                                    child: Lottie.asset(
                                      'assets/animations/success1.json',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  msg:
                                      'Olá Oceaners, seu cadastro foi realizado com sucesso!',
                                  msgAlign: TextAlign.center,
                                  msgStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                  title: 'Bem vindo',
                                  titleStyle: const TextStyle(
                                    color: Color.fromRGBO(21, 39, 65, 1),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  ),
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  // ignore: deprecated_member_use
                                  actions: [
                                    IconsButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/login');
                                      },
                                      text: 'Ir para Login',
                                      iconData: Icons.check,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                      color: Colors.green,
                                    ),
                                  ]);
                            }
                          },
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: sizeOF.height * .075,
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
