import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:string_similarity/string_similarity.dart';

class SayItRight extends StatefulWidget {
  @override
  _SayItRightState createState() => _SayItRightState();
}

class _SayItRightState extends State<SayItRight> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  String targetWord = "dog"; // Target word to be spoken
  String recognizedWord = "";
  int accuracy = 0;
  bool isDialogOpen = false;
  bool isListening = false; // Flag para maiwasan ang double execution

  @override
  void initState() {
    super.initState();
    _setupTTS();
  }

  void _setupTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVoice({"name": "en-us-x-sfg#female", "locale": "en-US"});
    _speakWord();
  }

  void _speakWord() async {
    await flutterTts.speak("Can you say the word Dog?");
  }

  void _startListening() async {
    if (isDialogOpen || isListening) return; // Prevent double execution

    setState(() {
      isListening = true; // Set flag to true
    });

    bool available = await speech.initialize();
    if (available) {
      speech.listen(onResult: (result) {
        setState(() {
          recognizedWord = result.recognizedWords.toLowerCase().trim();
          double confidenceScore = result.confidence * 100;
          double similarityScore = targetWord.similarityTo(recognizedWord) * 100;

          if (confidenceScore.isNaN || confidenceScore == 0) {
            accuracy = similarityScore.clamp(10, 100).round();
          } else {
            accuracy = ((confidenceScore + similarityScore) / 2).round();
          }

          accuracy = accuracy.clamp(1, 100);
        });
      });

      await Future.delayed(Duration(seconds: 2)); // Wait for result
      speech.stop();
      setState(() {
        isListening = false;
      });
      _showAccuracyDialog();
    } else {
      setState(() {
        isListening = false;
      });
    }
  }

  void _showAccuracyDialog() {
    if (isDialogOpen) return;
    isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Accuracy"),
        content: Text(
          "$accuracy%",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      if (isDialogOpen) {
        isDialogOpen = false;
        Navigator.pop(context);
      }
    });
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
                height: 50,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    speech.stop();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A4E69),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Say It Right!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4E69),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/S-Dog.jpg',
                        width: 300,
                        height: 500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _startListening,
                            child: FaIcon(
                              FontAwesomeIcons.microphone,
                              size: 60,
                              color: isListening ? Colors.red : Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "D-OG",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
