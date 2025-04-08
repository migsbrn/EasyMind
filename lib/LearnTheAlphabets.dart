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
    'A': 'Ah',
    'B': 'Buh',
    'C': 'Kuh',
    'D': 'Duh',
    'E': 'Eh',
    'F': 'Fff',
    'G': 'Guh',
    'H': 'Hhh',
    'I': 'Ih',
    'J': 'Juh',
    'K': 'Kuh',
    'L': 'Lll',
    'M': 'Mmm',
    'N': 'Nnn',
    'O': 'Oh',
    'P': 'Puh',
    'Q': 'Kwuh',
    'R': 'Rrr',
    'S': 'Sss',
    'T': 'Tuh',
    'U': 'Uh',
    'V': 'Vvv',
    'W': 'Wuh',
    'X': 'Ks',
    'Y': 'Yuh',
    'Z': 'Zzz',
  };

  final List<String> alphabetList =
      List.generate(26, (i) => String.fromCharCode(65 + i));

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
        await flutterTts.setVoice({
          "name": voice["name"],
          "locale": voice["locale"],
        });
        break;
      }
    }

    await Future.delayed(Duration(seconds: 3));
    await flutterTts.speak("Listen carefully...");
    await Future.delayed(Duration(seconds: 2));
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
      backgroundColor: const Color(0xFFEFE9D5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Go Back Button (Larger)
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C4F6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Title
              const Center(
                child: Text(
                  "Learn The Alphabets",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF648BA2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Alphabet Card (Larger)
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5D8C4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12,
                          left: 12,
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.play,
                              size: 40,
                              color: canReplay
                                  ? const Color(0xFF648BA2)
                                  : Colors.grey,
                            ),
                            onPressed: canReplay ? _speakLetter : null,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${alphabetList[currentIndex]}${alphabetList[currentIndex].toLowerCase()}",
                            style: const TextStyle(
                              fontSize: 130,
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
              const SizedBox(height: 30),

              // Navigation Buttons (Larger)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0 ? () => changeCard(-1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF648BA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(160, 60),
                    ),
                    child: const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: currentIndex < alphabetList.length - 1
                        ? () => changeCard(1)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF648BA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(160, 60),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
