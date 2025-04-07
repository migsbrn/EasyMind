import 'package:flutter/material.dart';
import 'GamesLandingPage.dart'; // Import the GamesLandingPage

class AssessmentPage extends StatelessWidget {
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
            // Moved the "Assessment" text upwards
            Center(
              child: Transform.translate(
                offset: Offset(0, -20), // Moves text 20 pixels up
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
                      title: 'Games',
                      imagePath: 'assets/games.jpg',
                      cardWidth: 400,
                      cardHeight: 500,
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
                      title: 'Quiz',
                      imagePath: 'assets/quiz.jpg',
                      cardWidth: 400,
                      cardHeight: 500,
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
  }) {
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: InkWell(
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
