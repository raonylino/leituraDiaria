import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            await supabase.auth.signOut();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacementNamed('/login');
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
                            return ListTile(
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
