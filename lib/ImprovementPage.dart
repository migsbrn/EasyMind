import 'package:easymind/ProgressMonitoringPage.dart';
import 'package:easymind/studentslist.dart';
import 'package:easymind/teacher-dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImprovementsPage extends StatefulWidget {
  @override
  _ImprovementsPageState createState() => _ImprovementsPageState();
}

class _ImprovementsPageState extends State<ImprovementsPage> {
  final List<Map<String, dynamic>> improvements = [
    {"nickname": "John", "name": "John Aquino", "prevAcc": "85%", "currAcc": "90%", "prevScore": "10", "currScore": "15", "improve": "5%"},
  ];

  String searchQuery = "";
  String? selectedFilter;

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
                  Text('Improvements', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildSearchAndFilter(),
                  SizedBox(height: 10),
                  Expanded(child: _buildImprovementsTable()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementsTable() {
    final filteredImprovements = improvements.where((data) {
      return data['name']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) => Color(0xFF8BBBD1)),
          columns: [
            DataColumn(label: Text('Nickname', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Previous Accuracy', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Current Accuracy', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Previous Score', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Current Score', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Improvements', style: TextStyle(color: Colors.white))),
          ],
          rows: filteredImprovements.map((data) => DataRow(
            color: MaterialStateProperty.all(Colors.transparent),
            cells: [
              DataCell(Text(data['nickname']!)),
              DataCell(Text(data['name']!)),
              DataCell(Text(data['prevAcc']!)),
              DataCell(Text(data['currAcc']!)),
              DataCell(Text(data['prevScore']!)),
              DataCell(Text(data['currScore']!)),
              DataCell(Text(data['improve']!)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search......',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.black54, size: 18),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 10),
        _buildFilterButton(),
        SizedBox(width: 10),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      child: Row(
        children: [
          Text('Filter by '),
          Icon(Icons.arrow_drop_down),
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
          _buildProfileSection(),
          SizedBox(height: 40),
          _buildSidebarButton('Dashboard', false, () => _navigateTo(context, TeacherDashboard())),
          _buildSidebarButton('Students List', false, () => _navigateTo(context, StudentsListPage())),
          _buildSidebarButton('Progress Monitoring', false, () => _navigateTo(context, ProgressMonitoringPage())),
          _buildSidebarButton('Improvements', true, () {}),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      color: Color(0xFF8BBBD1),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/profile.png')),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Teacher Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('email@example.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF8BBBD1) : Color(0xFF6A9BAF),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
