import 'package:flutter/material.dart';
import 'package:oceans/src/core/env.dart';
import 'package:oceans/src/oceans_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  
  await Supabase.initialize(
    url:  Env.apiUrl,
    anonKey: Env.apiKey,
  );

  runApp(const OceansApp());
}

final supabase = Supabase.instance.client;

