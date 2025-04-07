import 'package:flutter/material.dart';
import 'SayItRight.dart'; // Make sure this import is correct

class GamesLandingPage extends StatelessWidget {
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
            SizedBox(height: 10),
            Center(
              child: Text(
                "Games",
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
                  _buildGameCard(
                    title: 'Say It Right!',
                    imagePath: 'assets/games.jpg',
                    fontSize: 40,
                    imageWidth: 230,
                    imageHeight: 230,
                    imageRadius: 15,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SayItRight(), // Navigate to SayItRight page
                        ),
                      );
                    },
                  ),
                  _buildGameCard(
                    title: 'Match The Sound',
                    imagePath: 'assets/games.jpg',
                    fontSize: 40,
                    imageWidth: 230,
                    imageHeight: 230,
                    imageRadius: 15,
                    onTap: () {
                      // Add navigation or functionality here
                    },
                  ),
                  _buildGameCard(
                    title: 'Drag and Drop',
                    imagePath: 'assets/games.jpg',
                    fontSize: 40,
                    imageWidth: 230,
                    imageHeight: 230,
                    imageRadius: 15,
                    onTap: () {
                      // Add navigation or functionality here
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

  Widget _buildGameCard({
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
