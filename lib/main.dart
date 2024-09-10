import 'package:flutter/material.dart';
import 'package:oceans/src/oceans_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://xbpnozurgredxakyhonb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhicG5venVyZ3JlZHhha3lob25iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU5Njk4MjAsImV4cCI6MjA0MTU0NTgyMH0.XEZBYSZj-ygh2DCz5ya-iIDWLqZxDrqiVnx6CMG4vOw',
  );

  runApp(const OceansApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

