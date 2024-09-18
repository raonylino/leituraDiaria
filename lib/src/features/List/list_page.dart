import 'dart:developer';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Stack(
          children: [
            // Animação Lottie de fundo
            Lottie.asset(
              'assets/animations/borderAnimation.json', // Substitua pelo caminho do seu arquivo Lottie
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            AppBar(
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Leitura Biblica Diária',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              centerTitle: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
          items: const [
            TabItem(icon: Icons.logout_outlined, title: 'Sair'),
            TabItem(icon: Icons.auto_stories_rounded, title: 'Leituras'),
            TabItem(icon: Icons.post_add, title: 'Adicionar'),
          ],
          initialActiveIndex: 1,
          onTap: (int i) async {
            if (i == 0) {
              Dialogs.materialDialog(
                  msg: 'Tem certeza que deseja sair do sistema?',
                  title: 'Logout',
                  context: context,
                  // ignore: deprecated_member_use
                  actions: [
                    IconsButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/contact/list/admin');	
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
            } else if (i == 1) {
               Navigator.of(context).popAndPushNamed('/contact/list/admin');	
      
            } else if (i == 2) {
              await Navigator.pushNamed(context, '/contact/register');
              // ignore: use_build_context_synchronously
              context.read<ContactListCubit>().findAll();
            }
          }),

      body: Container(
        padding: const EdgeInsets.only(
          top: 50,
          left: 10,
          right: 10,
          bottom: 10,
        ),
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
                        color: const Color.fromRGBO(21, 39, 65, 1),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 100,
                              child: Lottie.asset(
                                'assets/animations/reading.json',
                                fit: BoxFit.cover,
                                frameRate: FrameRate.composition,
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              width: 200,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Palavra do dia:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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
                                              return Text(
                                                  'Erro: ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${snapshot.data!.text.toString().substring(0, 60)}...',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white54,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    '${snapshot.data!.livroNome}: ${snapshot.data!.chapter}- ${snapshot.data!.verse}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Poppins-italic',
                                                      color: Colors.white54,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const Text(
                                                  'Nenhum dado encontrado');
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ]),
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
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(51, 80, 241, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(198, 202, 208, 1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
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
                                  color: leituraCompleta
                                      ? Colors.orange
                                      : Colors.white,
                                ),
                                title: Text(
                                  '${contact.dataLeitura.day.toString().padLeft(2, '0')}/${contact.dataLeitura.month.toString().padLeft(2, '0')} : ${ListDataController.diaDaSemana(contact.dataLeitura.weekday)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: leituraCompleta
                                        ? Colors.orange
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'Ler ${contact.livro}  do capiluto ${contact.capituloInicio} ao ${contact.capituloFim}',
                                  style: TextStyle(
                                      fontWeight: leituraCompleta
                                          ? FontWeight.w300
                                          : FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.white),
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
