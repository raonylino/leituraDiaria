import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:oceans/main.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/features/List/list_data_controller.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/widgets/loader.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});
  

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
          onPressed: () async {
            Dialogs.bottomMaterialDialog(
                msg:
                    'Tem certeza que deseja sair do sistema?',
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
          },
        ),
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
      body: Container(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () => context.read<ContactListCubit>().findAll(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
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
                              child: ListTile(
                             
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
