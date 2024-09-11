import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:oceans/main.dart';

class ControllerLogin {
  static Future<void> login(String email, String password, BuildContext context,
      Function(bool) onSuccess) async {
    try {
          await supabase.auth.signUp(password: password, email: email);

    } catch (e) {
      if (context.mounted) {
        if (e == 'user_not_found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não encontrado')),
          );
        } else if (e == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta')),
          );
        }if( e == 'email_not_confirmed') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email não verificado')),	
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao fazer login')),
          );
        }
      }
      onSuccess(false);
      log('Exception: ${e.toString()}');
    }
  }
}
