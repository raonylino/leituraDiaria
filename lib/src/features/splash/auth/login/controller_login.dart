import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControllerLogin {
  static Future<void> login(String email, String password, BuildContext context,
      Function(bool) onSuccess) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      var message = '';

      if (credential.user != null && !credential.user!.emailVerified) {
        message = 'Email não verificado, verifique seu email';
        onSuccess(false);
      } else {
        onSuccess(true);
        message = 'Login efetuado com sucesso';
      }

      // Use o contexto de forma segura após a operação assíncrona
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não encontrado')),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta')),
          );
        }
      }
      onSuccess(false);
      log('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer login')),
        );
      }
      onSuccess(false);
      log('Exception: ${e.toString()}');
    }
  }
}
