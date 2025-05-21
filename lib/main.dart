import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'common/colo_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Obligatoire pour async/await
  await Firebase.initializeApp(); // Initialise Firebase

  // Appel du test Firestore juste après l'initialisation
  await testFirestore();

  runApp(const MyApp());
}

// Fonction de test Firestore appelée au lancement
Future<void> testFirestore() async {
  try {
    await FirebaseFirestore.instance.collection('test').add({
      'timestamp': DateTime.now().toIso8601String(),
      'message': 'Firebase fonctionne depuis main() ! 🎉',
    });
    print(" Firestore : Donnée envoyée !");
  } catch (e) {
    print(" Erreur Firestore : $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: const MainTabView(),
    );
  }
}
