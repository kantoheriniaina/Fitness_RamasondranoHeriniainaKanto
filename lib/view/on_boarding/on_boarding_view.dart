import 'package:fitness/common_widget/on_boarding_page.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;
      setState(() {});
    });
  }

  List pageArr = [
    {
      "title": "Track Your Goal",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/img/a10.png",
      "bubbleImage": "assets/img/a10.png",
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achieve your goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/img/Home2.png",
      "bubbleImage": "assets/img/Design2.png",
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/img/a12.png",
      "bubbleImage": "assets/img/Design3.png",
    },
    {
      "title": "Improve Sleep\nQuality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/img/Home4.png",
      "bubbleImage": "assets/img/Design1.png",
    },
  ];

  Map<String, double> _getBubblePosition(int index) {
    switch (index % 4) {
      case 0:
        return {
          "top": 20,
          "left": 20,
          "right": double.infinity,
          "bottom": double.infinity,
        };
      case 1:
        return {
          "top": 20,
          "right": 20,
          "left": double.infinity,
          "bottom": double.infinity,
        };
      case 2:
        return {
          "bottom": 20,
          "right": 20,
          "top": double.infinity,
          "left": double.infinity,
        };
      case 3:
        return {
          "bottom": 20,
          "left": 20,
          "top": double.infinity,
          "right": double.infinity,
        };
      default:
        return {
          "top": 20,
          "left": 20,
          "right": double.infinity,
          "bottom": double.infinity,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec Design2.png et effet transparent
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, // Ajustez la transparence (0.0 à 1.0)
              child: Image.asset(
                "assets/img/Design2.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    "Erreur: Design2.png non trouvé",
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),
            ),
          ),
          // PageView pour afficher les différentes pages
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index] as Map? ?? {};
              var bubblePosition = _getBubblePosition(index);
              return Stack(
                children: [
                  // Centrage horizontal avec padding normal, aligné en haut
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centre horizontalement
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          15.0,
                          120.0,
                          15.0,
                          0.0,
                        ), // Left, Top, Right, Bottom
                        child: OnBoardingPage(pObj: pObj), // Image principale
                      ),
                    ],
                  ),
                  // Image en bulle positionnée dynamiquement
                  Positioned(
                    top: bubblePosition["top"],
                    left: bubblePosition["left"],
                    right: bubblePosition["right"],
                    bottom: bubblePosition["bottom"],
                    child: Image.asset(
                      pObj["bubbleImage"] ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          "Erreur: Image non trouvée",
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          // Texte centré (uniquement ici pour éviter les doublons)
          Positioned(
            top: media.height * 0.6,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: media.width * 0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pageArr[selectPage]["title"] ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: TColor.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pageArr[selectPage]["subtitle"] ?? "",
                      style: TextStyle(fontSize: 14, color: TColor.gray),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bouton de navigation
          Positioned(
            bottom: 30,
            right: 30,
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      color: TColor.primaryColor1,
                      value: (selectPage + 1) / 4,
                      strokeWidth: 2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 30,
                    ),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.navigate_next, color: TColor.white),
                      onPressed: () {
                        if (selectPage < 3) {
                          selectPage = selectPage + 1;
                          controller.animateToPage(
                            selectPage,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.bounceInOut,
                          );
                          setState(() {});
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpView(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
