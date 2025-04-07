import 'package:flutter/material.dart';
import 'package:easymind/ReadingMaterialsPage.dart';
import 'package:easymind/AssessmentPage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class StudentLandingPage extends StatefulWidget {
  @override
  _StudentLandingPageState createState() => _StudentLandingPageState();
}

class _StudentLandingPageState extends State<StudentLandingPage> {
  final GlobalKey _readingKey = GlobalKey();
  final GlobalKey _assessmentKey = GlobalKey();

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
        identify: "Reading",
        keyTarget: _readingKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Click here to access fun reading materials designed for you!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
        identify: "Assessment",
        keyTarget: _assessmentKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Click here to try assessments and test your knowledge!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
      textSkip: "",
      paddingFocus: 10,
      opacityShadow: 0.8,
      skipWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          'SKIP',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );

    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = 400;
    double cardHeight = 500;
    double titleFontSize = 32;
    double subtitleFontSize = 18;

    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Student!',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4E69),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Start Learning!',
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: Color(0xFF4A4E69),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFeatureCard(
                  key: _readingKey,
                  title: 'Reading Materials',
                  imagePath: 'assets/reading_materials.png',
                  imageWidth: 250,
                  imageHeight: 250,
                  imageTopPadding: 10,
                  imageBorderRadius: 20,
                  titleFontSize: 50,
                  onTap: () async {
                    tutorialCoachMark.finish();
                    await Future.delayed(Duration(milliseconds: 300));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingMaterialsPage(),
                      ),
                    );
                    showTutorialOnReturn = true;
                  },
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                ),
                SizedBox(width: 40),
                _buildFeatureCard(
                  key: _assessmentKey,
                  title: 'Assessment',
                  imagePath: 'assets/assessment.jpg',
                  imageWidth: 250,
                  imageHeight: 250,
                  imageTopPadding: 10,
                  imageBorderRadius: 20,
                  titleFontSize: 50,
                  titleTopPadding: 20,
                  onTap: () async {
                    tutorialCoachMark.finish();
                    await Future.delayed(Duration(milliseconds: 300));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentPage(),
                      ),
                    );
                    showTutorialOnReturn = true;
                  },
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required Key key,
    required String title,
    required VoidCallback onTap,
    required double cardWidth,
    required double cardHeight,
    required double titleFontSize,
    String? imagePath,
    double imageWidth = 100,
    double imageHeight = 100,
    double imageTopPadding = 0,
    double imageBorderRadius = 0,
    double titleTopPadding = 0,
  }) {
    return SizedBox(
      key: key,
      width: cardWidth,
      height: cardHeight,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Color(0xFF648BA2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (imagePath != null)
                  Padding(
                    padding: EdgeInsets.only(top: imageTopPadding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(imageBorderRadius),
                      child: Image.asset(
                        imagePath,
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: titleTopPadding),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
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
