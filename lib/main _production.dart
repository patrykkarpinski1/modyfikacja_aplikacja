// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/app/app.dart';
import '/app/core/config.dart';
import '/app/injection_container.dart';
import 'firebase_options.dart';

void main() async {
  Config.appFlavor = Flavor.production;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureDependencies();
  runApp(const MyApp());
}
