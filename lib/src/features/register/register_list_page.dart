import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:oceans/src/features/register/cubit/register_list_cubit.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/widgets/loader.dart';

class RegisterListPage extends StatefulWidget {
  const RegisterListPage({super.key});

  @override
  State<RegisterListPage> createState() => _RegisterListPageState();
}

class _RegisterListPageState extends State<RegisterListPage> {
  final formKey = GlobalKey<FormState>();
  final _livroEC = TextEditingController();
  final _capituloInicioEC = TextEditingController();
  final _capituloFimEC = TextEditingController();
  final _dataEC = TextEditingController();

  @override
  void dispose() {
    _livroEC.dispose();
    _capituloInicioEC.dispose();
    _capituloFimEC.dispose();
    _dataEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOF = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/contact/list/admin');
          },
        ),
        title: const Text(
          'Resgistrar nova leitura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 163, 255, 1),
      ),
      body: Stack(
        children: [
          Lottie.asset(
            'assets/animations/background1.json',
            fit: BoxFit.values[0],
            height: sizeOF.height,
            frameRate: const FrameRate(60),
          ),
          BlocListener<RegisterListCubit, RegisterListState>(
            listenWhen: (previous, current) => current.maybeWhen(
              success: () => true,
              error: (message) => true,
              orElse: () => false,
            ),
            listener: (context, state) {
              state.whenOrNull(
                success: () => Navigator.of(context).pop(),
                error: (message) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: sizeOF.height * .5,
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(21, 39, 65, 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      width: sizeOF.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Nome do Livro:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: sizeOF.width * .8,
                            child: TextFormField(
                              controller: _livroEC,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Digite o nome do livro',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Livro obrigatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Capitulos da Leituras:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sizeOF.width * .8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 60,
                                  width: sizeOF.width * .35,
                                  child: TextFormField(
                                    controller: _capituloInicioEC,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Inicio',
                                      hintStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Capitulo obrigatorio';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: sizeOF.width * .35,
                                  child: TextFormField(
                                    controller: _capituloFimEC,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Fim',
                                      hintStyle: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Capitulo obrigatorio';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Data da Leitura:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: sizeOF.width * .8,
                            child: TextFormField(
                              controller: _dataEC,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Data da leitura',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(51, 80, 241, 1),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              final validate =
                                  formKey.currentState?.validate() ?? false;
                              if (validate) {
                                context.read<RegisterListCubit>().register(
                                      ContactsModel(
                                        livro: _livroEC.text,
                                        capituloInicio:
                                            int.parse(_capituloInicioEC.text),
                                        capituloFim:
                                            int.parse(_capituloFimEC.text),
                                        dataLeitura:
                                            DateTime.parse(_dataEC.text),
                                      ),
                                    );
                              }
                            },
                            child: const Text(
                              'Registrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Loader<RegisterListCubit, RegisterListState>(
                      selector: (state) => state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dataEC.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }
}
