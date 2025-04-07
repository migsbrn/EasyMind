import 'package:easymind/ImprovementPage.dart';
import 'package:easymind/studentslist.dart';
import 'package:easymind/teacher-dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProgressMonitoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Container(
              color: Color(0xFFF5EEDC),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Monitoring',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildSearchAndFilters(),
                  SizedBox(height: 20),
                  Expanded(child: _buildDataTable()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF648BA2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            color: Color(0xFF8BBBD1),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Teacher Name',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('email@example.com',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          _buildSidebarButton('Dashboard', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeacherDashboard()),
            );
          }),
          _buildSidebarButton('Students List', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentsListPage()),
            );
          }),
          _buildSidebarButton('Progress Monitoring', true, () {}),
          _buildSidebarButton('Improvements', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImprovementsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(String title, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF8BBBD1) : Color(0xFF6A9BAF),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search......',
              prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.black54, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        SizedBox(width: 10),
        _buildFilterButton('Filter by'),
        SizedBox(width: 10),
        _buildFilterButton('Filter by'),
      ],
    );
  }

  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        children: [
          Text(text),
          Icon(Icons.arrow_drop_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
    ),
    padding: EdgeInsets.all(10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 700, // Adjust the width as needed
        height: 300, // Adjust the height as needed
        child: DataTable(
          columnSpacing: 40,
          headingRowHeight: 50, // Adjust heading row height
          dataRowHeight: 40, // Adjust data row height
          headingRowColor: MaterialStateProperty.all(Color(0xFF8BBBD1)),
          columns: [
            DataColumn(label: Text('Nickname', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Accuracy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('John')),
              DataCell(Text('John Aquino')),
              DataCell(Text('85%')),
              DataCell(Text('25')),
            ]),
          ],
        ),
      ),
    ),
  );
}
}