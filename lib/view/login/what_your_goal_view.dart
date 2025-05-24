import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/model/users.dart';

class WhatYourGoalView extends StatefulWidget {
  final Map<String, String?> profileData;
  const WhatYourGoalView({super.key, required this.profileData});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselSliderController buttonCarouselController = CarouselSliderController();
  String? selectedGoal;

  List goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Improve Shape",
      "subtitle": "I have a low amount of body fat\nand need / want to build more\nmuscle"
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Lean & Tone",
      "subtitle": "I’m “skinny fat”. look thin but have\nno shape. I want to add learn\nmuscle in the right way"
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Lose a Fat",
      "subtitle": "I have over 20 lbs to lose. I want to\ndrop all this fat and gain muscle\nmass"
    },
  ];

  Future<void> _saveProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final userModel = userDoc.exists
            ? UserModel.fromMap(userDoc.data()!)
            : UserModel(
                uid: user.uid,
                email: user.email,
                firstName: user.displayName?.split(' ').first ?? '',
                lastName: user.displayName?.split(' ').last ?? '',
              );

        final updatedUserModel = userModel.copyWith(
          gender: widget.profileData['gender'],
          dateOfBirth: widget.profileData['dateOfBirth'],
          weight: double.tryParse(widget.profileData['weight'] ?? '0') ?? 0.0,
          height: double.tryParse(widget.profileData['height'] ?? '0') ?? 0.0,
          goal: selectedGoal,
          photoUrl: widget.profileData['photoUrl'], // Ajout de l'URL de la photo
        );

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
              updatedUserModel.toMap(),
              SetOptions(merge: true),
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sauvegarde du profil : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: goalArr
                    .map(
                      (gObj) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGoal = gObj["title"].toString();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: TColor.primaryG,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: selectedGoal == gObj["title"]
                                ? Border.all(color: TColor.white, width: 2)
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: media.width * 0.1, horizontal: 25),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Column(
                              children: [
                                Image.asset(
                                  gObj["image"].toString(),
                                  width: media.width * 0.5,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(height: media.width * 0.1),
                                Text(
                                  gObj["title"].toString(),
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  width: media.width * 0.1,
                                  height: 1,
                                  color: TColor.white,
                                ),
                                SizedBox(height: media.width * 0.02),
                                Text(
                                  gObj["subtitle"].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: TColor.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 0.74,
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectedGoal = goalArr[index]["title"].toString();
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: media.width,
              child: Column(
                children: [
                  SizedBox(height: media.width * 0.05),
                  Text(
                    "What is your goal ?",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "It will help us to choose a best\nprogram for you",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),
                  const Spacer(),
                  SizedBox(height: media.width * 0.05),
                  RoundButton(
                    title: "Confirm",
                    onPressed: () async {
                      if (selectedGoal != null) {
                        await _saveProfileData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeView(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Veuillez sélectionner un objectif.")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}