import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RhymeAndRead extends StatefulWidget {
  @override
  _RhymeAndReadState createState() => _RhymeAndReadState();
}

class _RhymeAndReadState extends State<RhymeAndRead> {
  int currentIndex = 0;
  FlutterTts flutterTts = FlutterTts(); // Flutter TTS Instance

  final List<Map<String, String>> rhymes = [
    {"image": "assets/cat_mat.jpg", "word": "Cat – Mat", "sentence": "The cat sat on a mat"},
    {"image": "assets/hen_pen.jpg", "word": "Hen – Pen", "sentence": "The hen is in the pen"},
    {"image": "assets/hand_sand.jpg", "word": "Hand – Sand", "sentence": "A hand touches the sand."}
  ];

  @override
  void initState() {
    super.initState();
    _speak(rhymes[currentIndex]["sentence"]!); // Auto-play first sentence
  }

  void nextRhyme() {
    setState(() {
      if (currentIndex < rhymes.length - 1) {
        currentIndex++;
        _speak(rhymes[currentIndex]["sentence"]!); // Auto-play new rhyme
      }
    });
  }

  void previousRhyme() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _speak(rhymes[currentIndex]["sentence"]!); // Auto-play previous rhyme
      }
    });
  }

  Future<void> _speak(String text) async {
  await flutterTts.stop(); // Stop any ongoing speech
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1.0); 
  await flutterTts.setSpeechRate(0.7);
  await flutterTts.speak(text);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A4E69),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5, height: 40),
                      Text(
                        'Go Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // IMAGE & NAVIGATION ICONS
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Arrow
                  Padding(
                    padding: EdgeInsets.only(right: 100),
                    child: IconButton(
                      onPressed: currentIndex > 0 ? previousRhyme : null,
                      icon: FaIcon(
                        FontAwesomeIcons.circleArrowLeft,
                        size: 100,
                        color: currentIndex > 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),

                  Container(
                    width: 430,
                    height: 430,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        rhymes[currentIndex]["image"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Right Arrow
                  Padding(
                    padding: EdgeInsets.only(left: 100),
                    child: IconButton(
                      onPressed: currentIndex < rhymes.length - 1 ? nextRhyme : null,
                      icon: FaIcon(
                        FontAwesomeIcons.circleArrowRight,
                        size: 100,
                        color: currentIndex < rhymes.length - 1 ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // WORD PAIR
            Text(
              rhymes[currentIndex]["word"]!,
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4E69),
              ),
            ),

            SizedBox(height: 10),

            // SENTENCE WITH SPEAKER ICON
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _speak(rhymes[currentIndex]["sentence"]!);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: FaIcon(
                        FontAwesomeIcons.volumeHigh,
                        size: 40,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    rhymes[currentIndex]["sentence"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
