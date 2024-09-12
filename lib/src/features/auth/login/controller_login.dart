import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:oceans/main.dart';


class ControllerLogin {
  static Future<void> login(String email, String password, BuildContext context,
      Function(bool) onSuccess) async {
    try {
      await supabase.auth.signUp(password: password, email: email);
      onSuccess(true);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login efetuado')),
      );
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
        }
        if (e == 'email_not_confirmed') {
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

  static Future<bool> isAdm(String email) async {
    // ignore: unused_local_variable
    late bool state = false;
    final response = await supabase
        .from('users')
        .select('is_adm')
        .eq('email', email)
        .single();
    log('response: $response');

    if (response['is_adm'] == true) {
      log('entrou no true');
      return state = true;
    }else{
      log('entrou no false');
      return state = false;
    }

  }
}
