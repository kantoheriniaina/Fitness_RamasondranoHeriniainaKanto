import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:fitness/model/users.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  UserModel? userModel;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Récupérer les données de l'utilisateur depuis Firestore
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userModel = UserModel.fromMap(userDoc.data()!);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Aucun profil utilisateur trouvé.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Aucun utilisateur connecté.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors de la récupération des données : $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: media.width * 0.1),
              // Afficher la photo de profil
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TColor.lightGray,
                  border: Border.all(color: TColor.gray, width: 2),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : userModel?.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              userModel!.photoUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 50,
                                color: TColor.gray,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: TColor.gray,
                          ),
              ),
              SizedBox(height: media.width * 0.05),
              if (isLoading)
                const CircularProgressIndicator()
              else if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                )
              else if (userModel != null) ...[
                Text(
                  "Welcome, ${userModel!.firstName ?? 'Utilisateur'}",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: media.width * 0.02),
                Text(
                  "You are all set now, let’s reach your goals together with us",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Email: ${userModel!.email ?? 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
                Text(
                  "Genre: ${userModel!.gender ?? 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
                Text(
                  "Date de naissance: ${userModel!.dateOfBirth ?? 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
                Text(
                  "Poids: ${userModel!.weight != null ? '${userModel!.weight} kg' : 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
                Text(
                  "Taille: ${userModel!.height != null ? '${userModel!.height} cm' : 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
                Text(
                  "Objectif: ${userModel!.goal ?? 'Non défini'}",
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
              ],
              const Spacer(),
              RoundButton(
                title: "Go To Home",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainTabView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}