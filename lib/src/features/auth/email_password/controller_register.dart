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
      final Session? session = res.session;
      final User? user = res.user;
      log('user: $user');

    } catch (e) {
      const SnackBar(content: Text('Erro ao cadastrar usuario'));
      log('Erro ao registrar: $e');
    }
  }
}
