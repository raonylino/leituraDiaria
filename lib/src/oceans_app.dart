import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';
import 'package:oceans/src/features/List/list_page.dart';
import 'package:oceans/src/features/List/list_user_page.dart';
import 'package:oceans/src/features/auth/email_password/register_page.dart';
import 'package:oceans/src/features/auth/login/login_page.dart';
import 'package:oceans/src/features/register/cubit/register_list_cubit.dart';
import 'package:oceans/src/features/register/register_list_page.dart';
import 'package:oceans/src/features/splash/splash_page.dart';
import 'package:oceans/src/features/updade/update_update_page.dart';
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
              child: const ListUserPage(),
            );
          },
          '/contact/list/admin': (context) {
            return BlocProvider(
              create: (context) => ContactListCubit(
                repository: context.read(),
              )..findAll(),
              child: const ListPage(),
            );
          },
          '/contact/register': (_) => BlocProvider(
                create: (context) => RegisterListCubit(
                  repository: context.read(),
                ),
                child: const RegisterListPage(),
              ),
          '/login': (_) => const LoginPage(),
          
          '/contact/update': (_) => const UpdateUpdatePage(),

          '/auth/email_password/register': (_) => const RegisterPage(),
        },
      ),
    );
  }
}
