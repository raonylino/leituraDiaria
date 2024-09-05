import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final _capituloEC = TextEditingController();

  @override
  void dispose() {
    _livroEC.dispose();
    _capituloEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOF = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Resgistrar nova leitura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
      ),
      body: BlocListener<RegisterListCubit, RegisterListState>(
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
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background_register.png'),
                    fit: BoxFit.cover,
                    opacity: 0.3),
              ),
              padding: const EdgeInsets.all(8.0),
              width: sizeOF.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: sizeOF.width * .8,
                    child: TextFormField(
                      controller: _livroEC,
                      decoration: const InputDecoration(
                        label: Text('Livro e dia da leitura'),
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
                  SizedBox(
                    height: 60,
                    width: sizeOF.width * .8,
                    child: TextFormField(
                      controller: _capituloEC,
                      decoration: const InputDecoration(
                        label: Text('Capitulo'),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final validate =
                          formKey.currentState?.validate() ?? false;
                      if (validate) {
                        context.read<RegisterListCubit>().register(
                              ContactsModel(
                                livro: _livroEC.text,
                                capitulo: _capituloEC.text,
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
      ),
    );
  }
}
