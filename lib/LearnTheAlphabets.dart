  import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:flutter_tts/flutter_tts.dart';

  class LearnTheAlphabets extends StatefulWidget {
    @override
    _LearnTheAlphabetsState createState() => _LearnTheAlphabetsState();
  }

  class _LearnTheAlphabetsState extends State<LearnTheAlphabets> {
    final FlutterTts flutterTts = FlutterTts();

    final Map<String, String> letterSounds = {
      'A': 'Ah', 'B': 'Buh', 'C': 'Kuh', 'D': 'Duh', 'E': 'Eh',
      'F': 'Fff', 'G': 'Guh', 'H': 'Hhh', 'I': 'Ih', 'J': 'Juh',
      'K': 'Kuh', 'L': 'Lll', 'M': 'Mmm', 'N': 'Nnn', 'O': 'Oh',
      'P': 'Puh', 'Q': 'Kwuh', 'R': 'Rrr', 'S': 'Sss', 'T': 'Tuh',
      'U': 'Uh', 'V': 'Vvv', 'W': 'Wuh', 'X': 'Ks', 'Y': 'Yuh', 'Z': 'Zzz',
    };

    final List<String> alphabetList = [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
      'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
      'U', 'V', 'W', 'X', 'Y', 'Z'
    ];

    int currentIndex = 0;
    bool canReplay = false;

    @override
    void initState() {
      super.initState();
      _setupTTS();
    }

    Future<void> _setupTTS() async {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.setPitch(1.2);
      await flutterTts.setVolume(1.0);

      List<dynamic> voices = await flutterTts.getVoices;
      for (var voice in voices) {
        if (voice["name"].toString().toLowerCase().contains("female") &&
            voice["locale"].toString().startsWith("en-")) {
          await flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
          break;
        }
      }

      await Future.delayed(Duration(seconds: 3)); // 3-seconds delay bago ang "Listen Carefully"
      await flutterTts.speak("Listen carefully...");

      await Future.delayed(Duration(seconds: 2)); // Hintay bago lumabas ang unang letra
      _speakLetter();
    }

    Future<void> _speakLetter() async {
      String letter = alphabetList[currentIndex];
      String sound = letterSounds[letter] ?? letter;

      setState(() {
        canReplay = false;
      });

      String speechText = "$letter. $sound.";

      await flutterTts.speak(speechText);

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        canReplay = true;
      });
    }

    void changeCard(int step) {
      setState(() {
        int newIndex = currentIndex + step;
        if (newIndex >= 0 && newIndex < alphabetList.length) {
          currentIndex = newIndex;
          _speakLetter();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A4E69),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size(120, 60),
                        ),
                        child: Text(
                          'Go Back',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 198),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            icon: FaIcon(FontAwesomeIcons.play, color: canReplay ? Color(0xFF648BA2) : Colors.grey, size: 30),
                            onPressed: canReplay ? _speakLetter : null,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${alphabetList[currentIndex]}${alphabetList[currentIndex].toLowerCase()}",
                            style: TextStyle(
                              fontSize: 200,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF648BA2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentIndex > 0 ? () => changeCard(-1) : null,
                    icon: FaIcon(FontAwesomeIcons.circleArrowLeft, size: 100,
                        color: currentIndex > 0 ? const Color.fromARGB(255, 133, 165, 190) : Colors.grey),
                  ),
                  IconButton(
                    onPressed: currentIndex < alphabetList.length - 1 ? () => changeCard(1) : null,
                    icon: FaIcon(FontAwesomeIcons.circleArrowRight, size: 100,
                        color: currentIndex < alphabetList.length - 1 ? const Color.fromARGB(255, 133, 165, 190) : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
