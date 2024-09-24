import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oceans/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControllerRegister {
  static Future<void> register(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final User? user = res.user;
      log('user: $user');
      // fazer um fuction para alterar esse metodo de cadastro
      if (user != null) {
        await supabase.from('users').insert([
          {
            'user_id': user.id,
            'email': email,
            'is_adm': false,
          },
        ]).select();
      }

    } catch (e) {
      const SnackBar(content: Text('Erro ao cadastrar usuario'));
      log('Erro ao registrar: $e');
    }
  }
}
