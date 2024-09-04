import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/features/List/list_page.dart';
import 'package:oceans/src/features/splash/splash_page.dart';
import 'package:oceans/src/repositories/contacts_repository.dart';

class OceansApp extends StatelessWidget {
  const OceansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ContactsRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routes: {
          '/': (_) => const SplashPage(),
          '/contact/list': (context) {
            return BlocProvider(
              create: (context) => ContactListCubit(
                repository: context.read(),
              )..findAll(),
              child: const ListPage(),
            );
          },
        },
      ),
    );
  }
}
