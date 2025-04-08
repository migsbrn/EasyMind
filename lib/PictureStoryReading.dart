import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PictureStoryReading extends StatefulWidget {
  @override
  _PictureStoryReadingState createState() => _PictureStoryReadingState();
}

class _PictureStoryReadingState extends State<PictureStoryReading> {
  final FlutterTts flutterTts = FlutterTts();

  final String storyText =
      "A little puppy named Bella got lost in the park. She barked for help, and a kind girl found her. They searched for Bella’s owner together, and soon they reunited.";

  @override
  void initState() {
    super.initState();
    setupTTS();
    speakStory();
  }

  void setupTTS() async {
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setLanguage("en-US");
  }

  void speakStory() async {
    await flutterTts.stop();
    await Future.delayed(Duration(milliseconds: 300));
    await flutterTts.speak(storyText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Go Back button
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A4E69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Title
              const Center(
                child: Text(
                  "Picture Reading Story",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF648BA2),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Story Card with updated background color and reduced size
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height * 0.55, // Reduce height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFD5D8C4), // Same color as the Learn Alphabet card
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Speaker icon aligned to the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.volumeHigh,
                            size: 40, color: Colors.blueAccent),
                        onPressed: speakStory,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Image
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/puppy.jpg',
                          fit: BoxFit.cover,
                          height:
                              300, // Resize image to fit better in the smaller card
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Story Title
                    const Center(
                      child: Text(
                        "The Adventure of the Lost Puppy",
                        style: TextStyle(
                          fontSize: 35, // Reduce font size for title
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Story Text
                    Center(
                      child: Text(
                        storyText,
                        style: const TextStyle(
                          fontSize: 20, // Reduce font size for story text
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30), // Add some space at the bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
