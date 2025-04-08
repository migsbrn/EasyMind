import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'GamesLandingPage.dart';

class AssessmentPage extends StatefulWidget {
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final GlobalKey _goBackKey = GlobalKey();
  final GlobalKey _gamesKey = GlobalKey();
  final GlobalKey _quizKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  bool showTutorialOnReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initTargets();
      showTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (showTutorialOnReturn) {
      Future.delayed(Duration(milliseconds: 300), () {
        showTutorial();
      });
      showTutorialOnReturn = false;
    }
  }

  void initTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "GoBack",
        keyTarget: _goBackKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Click this button if you want to go back to the previous screen.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "GamesCard",
        keyTarget: _gamesKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tap here to play fun learning games! These games help you learn while having fun!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "QuizCard",
        keyTarget: _quizKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tap here to answer a quiz! Show what you’ve learned by choosing the correct answers.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Skip",
      paddingFocus: 10,
      opacityShadow: 0.85,
      skipWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF648BA2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.skip_next, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );

    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 500;

    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 60,
                width: 180,
                child: ElevatedButton(
                  key: _goBackKey,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A4E69),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Transform.translate(
                offset: Offset(0, -20),
                child: Text(
                  "Assessment",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4E69),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAssessmentCard(
                      key: _gamesKey,
                      title: 'Games',
                      imagePath: 'assets/games.jpg',
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      verticalOffset: -50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamesLandingPage(),
                          ),
                        );
                      },
                    ),
                    _buildAssessmentCard(
                      key: _quizKey,
                      title: 'Quiz',
                      imagePath: 'assets/quiz.jpg',
                      cardWidth: cardWidth,
                      cardHeight: cardHeight,
                      verticalOffset: -50,
                      onTap: () {
                        // Add navigation or functionality for Quiz
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard({
    required String title,
    required String imagePath,
    required double cardWidth,
    required double cardHeight,
    required double verticalOffset,
    required VoidCallback onTap,
    Key? key,
  }) {
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: InkWell(
        key: key,
        onTap: onTap,
        child: Card(
          color: Color(0xFF648BA2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: cardWidth * 0.6,
                    height: cardHeight * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
