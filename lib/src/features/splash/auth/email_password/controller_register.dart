import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:oceans/src/features/List/cubit/contact_list_cubit.dart';

class ControllerRegister {
  
 static Future<void> register(String email, String password) async {
    try {
      const ContactListState.loading();
      await Future.delayed(const Duration(seconds: 2));
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      credential.user?.sendEmailVerification();
    } catch (e) {
       const ContactListState.error('Falha ao cadastrar usuario');
      log(e.toString());
    }
  }
  

}
