import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:oceans/main.dart';

class ControllerLogin {
  static Future<void> login(String email, String password, BuildContext context,
      Function(bool) onSuccess) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      if (response.user != null) {
        final userId = await supabase
            .from('users')
            .select('user_id')
            .eq('email', email)
            .single();
        log('user: $userId');

        onSuccess(true);

        var sessionManager = SessionManager();
        await sessionManager.set("id", userId['id']);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login efetuado')),
        );
      } else {
        throw Exception("Invalid login credentials");
      }
    } catch (e) {
      log('Erro ao fazer login: $e');
      if (context.mounted) {
        if (e.toString().contains("Invalid login credentials")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta')),
          );
        } else if (e.toString().contains("email_not_confirmed")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email não verificado')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao fazer login: $e')),
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
    if (response['is_adm'] == true) {
      return state = true;
    } else {
      return state = false;
    }
  }
}
