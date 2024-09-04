import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/models/contacts_model.dart';
import 'package:oceans/src/widgets/loader.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

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
   body: RefreshIndicator(
             onRefresh: () => context.read<ContactListCubit>().findAll(),
             child: CustomScrollView(
               slivers: [
                SliverFillRemaining(
                  child:Column(
                    children: [
                      Loader<ContactListCubit, ContactListState>(
                        selector: (state) {
                         return state.maybeWhen(
                            loading: () => true,
                            orElse: () => false
                          );
                        }
                        ),
                        BlocSelector<ContactListCubit, ContactListState, List<ContactsModel>>(
                          selector: (state) {
                            return state.maybeWhen(
                              data: (contacts) => contacts,
                              orElse: () => <ContactsModel>[]
                            );
                          }, 
                          builder: (context, contacts) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: contacts.length,
                              itemBuilder: (context, index) {
                                final contact = contacts[index];
                                return ListTile(
                                  onLongPress: () {
                                    // context.read<ContactListCubit>().deleteByModel(contact);
                                  },
                                  onTap: () {},
                                  title: Text(contact.livro),
                                  subtitle: Text(contact.capitulo),
                                );
                              }
                            );
                          }
                          ),
                    ]
                  ),
                )
               ],
             ),
           ),
    );
  }
}
