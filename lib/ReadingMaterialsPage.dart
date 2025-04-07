import 'package:flutter/material.dart';
import 'package:easymind/LearnTheAlphabets.dart';
import 'package:easymind/PictureStoryReading.dart';
import 'package:easymind/RhymeAndRead.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ReadingMaterialsPage extends StatefulWidget {
  @override
  _ReadingMaterialsPageState createState() => _ReadingMaterialsPageState();
}

class _ReadingMaterialsPageState extends State<ReadingMaterialsPage> {
  final GlobalKey _alphabetKey = GlobalKey();
  final GlobalKey _pictureStoryKey = GlobalKey();
  final GlobalKey _rhymeKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initTargets();
      showTutorial();
    });
  }

  void initTargets() {
    targets.clear();

    targets.add(
      TargetFocus(
        identify: "Alphabet",
        keyTarget: _alphabetKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Start here to learn the alphabet with fun visuals!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "PictureStory",
        keyTarget: _pictureStoryKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Read engaging picture stories to enhance your reading skills!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Rhyme",
        keyTarget: _rhymeKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Explore rhymes and practice reading with rhythm and fun!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
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
      paddingFocus: 10,
      opacityShadow: 0.8,
      textSkip: "",
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
              child: Text(
                "Reading Materials",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4E69),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.7,
                children: [
                  _buildReadingMaterialCard(
                    key: _alphabetKey,
                    title: 'Learn the Alphabets',
                    imagePath: 'assets/learn_alphabet.jpg',
                    fontSize: 40,
                    imageWidth: 230,
                    imageHeight: 230,
                    imageRadius: 15,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LearnTheAlphabets()),
                      );
                    },
                  ),
                  _buildReadingMaterialCard(
                    key: _pictureStoryKey,
                    title: 'Picture Story Reading',
                    imagePath: 'assets/picture_story.jpg',
                    fontSize: 40,
                    imageWidth: 230,
                    imageHeight: 230,
                    imageRadius: 15,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PictureStoryReading()),
                      );
                    },
                  ),
                  _buildReadingMaterialCard(
                    key: _rhymeKey,
                    title: 'Rhyme and Read',
                    imagePath: 'assets/Rhyme_Read.jpg',
                    fontSize: 40,
                    imageWidth: 223,
                    imageHeight: 228,
                    imageRadius: 15,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RhymeAndRead()),
                      );
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

  Widget _buildReadingMaterialCard({
    required Key key,
    required String title,
    String? imagePath,
    double fontSize = 20,
    double imageWidth = 120,
    double imageHeight = 120,
    double imageRadius = 10,
    double imageOffset = 0,
    double textOffset = 0,
    VoidCallback? onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: Container(
        width: 220,
        height: 400,
        decoration: BoxDecoration(
          color: Color(0xFF648BA2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (imagePath != null)
              Positioned(
                top: 50 + imageOffset,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageRadius),
                  child: Image.asset(
                    imagePath,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Positioned(
              bottom: 20 + textOffset,
              left: 10,
              right: 10,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
