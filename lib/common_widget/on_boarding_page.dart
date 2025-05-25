import 'package:flutter/material.dart';

import '../common/colo_extension.dart';

class OnBoardingPage extends StatelessWidget {
  final Map pObj;

  const OnBoardingPage({super.key, required this.pObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Image.asset(
      pObj["image"].toString(),
      width: media.width * 0.8, // Largeur ajustée
      height: media.height * 0.5, // Hauteur ajustée
      fit: BoxFit.contain, // Garde les proportions
    );
  }
}