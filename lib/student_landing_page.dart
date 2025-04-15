import 'package:flutter/material.dart';
import 'package:easymind/ReadingMaterialsPage.dart';
import 'package:easymind/AssessmentPage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class StudentLandingPage extends StatefulWidget {
  final String nickname;

  StudentLandingPage({required this.nickname});

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
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Column(
        children: [
          // Curved Header with Greeting
          Stack(
            children: [
              ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Color(0xFFFBEED9),
                ),
              ),
              Positioned(
                top: 60,
                left: 40,
                child: Text(
                  'Hello, ${widget.nickname}!',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4E69),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isSmallScreen = constraints.maxWidth < 800;

                      return isSmallScreen
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomCardButton(
                                  key: _readingKey,
                                  imagePath: 'assets/lrn.png',
                                  title: '',
                                  width: double.infinity,
                                  height: 300,
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
                                ),
                                SizedBox(height: 20),
                                CustomCardButton(
                                  key: _assessmentKey,
                                  imagePath: 'assets/assesment.png',
                                  title: '',
                                  width: double.infinity,
                                  height: 300,
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
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomCardButton(
                                  key: _readingKey,
                                  imagePath: 'assets/lrn.png',
                                  title: '',
                                  width: 600,
                                  height: 400,
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
                                ),
                                SizedBox(width: 40),
                                CustomCardButton(
                                  key: _assessmentKey,
                                  imagePath: 'assets/assesment.png',
                                  title: '',
                                  width: 600,
                                  height: 400,
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
                                ),
                              ],
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Card Button Widget
class CustomCardButton extends StatelessWidget {
  final Key key;
  final double width;
  final double height;
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const CustomCardButton({
    required this.key,
    required this.width,
    required this.height,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: key,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Color(0xFFFFF9E4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      width: 920,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                if (title.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4E69),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Clipper for the curved header
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
