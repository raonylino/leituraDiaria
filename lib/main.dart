import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oceans/src/core/env.dart';
import 'package:oceans/src/oceans_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: ".config/env.json",
  );
  await Supabase.initialize(
    url:  Env.apiUrl,
    anonKey: Env.apiKey,
  );
  runApp(const OceansApp());
}

final supabase = Supabase.instance.client;

