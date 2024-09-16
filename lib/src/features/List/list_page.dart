import 'dart:developer';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:oceans/main.dart';

import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/features/List/fetchVersiculo.dart';
import 'package:oceans/src/features/List/list_data_controller.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/models/versiculo_model.dart';
import 'package:oceans/src/widgets/loader.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
        title: const Text(
          'Leitura Biblica Diária',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: CircularMenu(
        alignment: Alignment.bottomRight,
        toggleButtonColor: Colors.blue,
        items: [
          CircularMenuItem(
              icon: Icons.logout_outlined,
              color: Colors.red,
              onTap: () {
                Dialogs.materialDialog(
                    msg: 'Tem certeza que deseja sair do sistema?',
                    title: 'Logout',
                    context: context,
                    // ignore: deprecated_member_use
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Não',
                        iconData: Icons.close_rounded,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                        color: Colors.red,
                      ),
                      IconsButton(
                        onPressed: () async {
                          await supabase.auth.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        text: 'Sim',
                        iconData: Icons.check_rounded,
                        color: Colors.green,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              }),
          CircularMenuItem(
              icon: Icons.add,
              color: Colors.green,
              onTap: () async {
                await Navigator.pushNamed(context, '/contact/register');
                // ignore: use_build_context_synchronously
                context.read<ContactListCubit>().findAll();
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () => context.read<ContactListCubit>().findAll(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 150,
                          child: Lottie.asset(
                            'assets/animations/reading.json',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text('Palavra do dia:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: FutureBuilder<Versiculo>(
                              future: fetchVersiculo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  log(snapshot.error.toString());
                                  return Text('Erro: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    const SizedBox(height: 10),
                                      Text(
                                        snapshot.data!.traduzirTexto().toString(),	
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        '${snapshot.data!.livroNome}: ${snapshot.data!.chapter}- ${snapshot.data!.verse}',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.right,
                                      ),
                                  
                                    ],
                                  );
                                } else {
                                  return const Text('Nenhum dado encontrado');
                                }
                              },
                            ),
                          ),
                        )
                      ]),
                    ),
                    Loader<ContactListCubit, ContactListState>(
                        selector: (state) {
                      return state.maybeWhen(
                          loading: () => true, orElse: () => false);
                    }),
                    BlocSelector<ContactListCubit, ContactListState,
                        List<ContactsModel>>(
                      selector: (state) {
                        return state.maybeWhen(
                            data: (contacts) => contacts,
                            orElse: () => <ContactsModel>[]);
                      },
                      builder: (context, contacts) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            bool leituraCompleta = contact.leituraCompleta;
                            return Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                onLongPress: () {
                                  Dialogs.bottomMaterialDialog(
                                      msg:
                                          'Tem certeza que deseja excluir o livro de ${contact.livro}?',
                                      title: 'Excluir Leitura',
                                      context: context,
                                      // ignore: deprecated_member_use
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.popAndPushNamed(
                                                context, '/contact/updade',
                                                arguments: contact);
                                          },
                                          text: 'Editar',
                                          iconData: Icons.edit,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                          color: Colors.orange,
                                        ),
                                        IconsButton(
                                          onPressed: () async {
                                            await context
                                                .read<ContactListCubit>()
                                                .deleteByModel(contact);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          },
                                          text: 'Apagar',
                                          iconData: Icons.delete,
                                          color: Colors.red,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                },
                                onTap: () async {
                                  setState(() {
                                    leituraCompleta = !leituraCompleta;
                                    contact.leituraCompleta =
                                        leituraCompleta; // Atualiza o estado do contato
                                  });

                                  await context.read<ContactListCubit>().save(
                                      ContactsModel(
                                          usuarioId:
                                              await SessionManager().get("id"),
                                          id: contact.id,
                                          livro: contact.livro,
                                          capituloInicio:
                                              contact.capituloInicio,
                                          capituloFim: contact.capituloFim,
                                          dataLeitura: contact.dataLeitura,
                                          leituraCompleta:
                                              contact.leituraCompleta));
                                  log(contact.leituraCompleta.toString());
                                },
                                leading: Icon(
                                  leituraCompleta
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_sharp,
                                  color: leituraCompleta ? Colors.orange : null,
                                ),
                                title: Text(
                                  '${contact.dataLeitura.day.toString().padLeft(2, '0')}/${contact.dataLeitura.month.toString().padLeft(2, '0')} : ${ListDataController.diaDaSemana(contact.dataLeitura.weekday)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color:
                                        leituraCompleta ? Colors.orange : null,
                                  ),
                                ),
                                subtitle: Text(
                                  'Ler ${contact.livro}  do capiluto ${contact.capituloInicio} ao ${contact.capituloFim}',
                                  style: TextStyle(
                                    fontWeight: leituraCompleta
                                        ? FontWeight.w300
                                        : FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
