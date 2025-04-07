import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PictureStoryReading extends StatefulWidget {
  @override
  _PictureStoryReadingState createState() => _PictureStoryReadingState();
}

class _PictureStoryReadingState extends State<PictureStoryReading> {
  int currentIndex = 0;
  final FlutterTts flutterTts = FlutterTts();

  final List<Map<String, String>> stories = [
    {"image": "assets/jump.jpg", "text": "The boy is jumping"},
    {"image": "assets/girl_reading.jpg", "text": "The girl is reading"},
    {"image": "assets/dog_running.jpg", "text": "The dog is running"},
    {"image": "assets/kids_playing.jpg", "text": "The kids are playing"},
    {"image": "assets/cat_sleeping.jpg", "text": "The cat is sleeping"},
    {"image": "assets/boy_eating.jpg", "text": "The boy is eating"},
    {"image": "assets/family_picnic.jpg", "text": "The family is having a picnic"},
    {"image": "assets/mom_cooking.jpg", "text": "Mom is cooking"},
    {"image": "assets/man_driving.jpg", "text": "The man is driving"},
    {"image": "assets/farmer_planting.jpg", "text": "The farmer is planting"},
    {"image": "assets/kid_writing.jpg", "text": "The kid is writing"},
    {"image": "assets/teacher_teaching.jpg", "text": "The teacher is teaching"},
  ];

  @override
  void initState() {
    super.initState();
    setupTTS();
    speakText();
  }

  void setupTTS() async {
    await flutterTts.setSpeechRate(0.4); // Bagalan ang bilis ng pagsasalita
    await flutterTts.setPitch(1.0); // Normal pitch para hindi masyadong mataas o mababa
    await flutterTts.setLanguage("en-US"); // Siguraduhin na English ang wika
  }

  void speakText() async {
    await flutterTts.stop();
    await Future.delayed(Duration(milliseconds: 300)); // Maghintay bago magsalita (para hindi putol)
    await flutterTts.speak(stories[currentIndex]["text"]!);
  }

  void nextStory() {
    if (currentIndex < stories.length - 1) {
      setState(() {
        currentIndex++;
      });
      speakText();
    }
  }

  void previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      speakText();
    }
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
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A4E69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: currentIndex > 0 ? previousStory : null,
                  icon: FaIcon(FontAwesomeIcons.circleArrowLeft, size: 100, color: currentIndex > 0 ? Colors.blue : Colors.grey),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        stories[currentIndex]["image"]!,
                        width: 400,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: currentIndex < stories.length - 1 ? nextStory : null,
                  icon: FaIcon(FontAwesomeIcons.circleArrowRight, size: 100, color: currentIndex < stories.length - 1 ? Colors.blue : Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: speakText,
                  icon: FaIcon(FontAwesomeIcons.volumeHigh, size: 50, color: Colors.black87),
                ),
                SizedBox(width: 10),
                Text(
                  stories[currentIndex]["text"]!,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
