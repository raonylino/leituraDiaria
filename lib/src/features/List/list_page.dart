import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/features/List/list_data_controller.dart';
import 'package:oceans/src/models/contacts_model.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/contact/register');
          // ignore: use_build_context_synchronously
          context.read<ContactListCubit>().findAll();
        },
        backgroundColor: const Color.fromRGBO(51, 80, 241, 1),
        label: const Row(
          children: [
            Text(
              'Cadastrar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ],
        ),
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
                            return ListTile(
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
                                          Navigator.popAndPushNamed(context, '/contact/updade', arguments: contact);
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
                                        capituloInicio: contact.capituloInicio,
                                        capituloFim: contact.capituloFim,
                                        dataLeitura: contact.dataLeitura,
                                        leituraCompleta: contact.leituraCompleta));
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
                                  color: leituraCompleta ? Colors.orange : null,
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
