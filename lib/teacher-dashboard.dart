import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'studentslist.dart';
import 'ProgressMonitoringPage.dart';
import 'ImprovementPage.dart';

class TeacherDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(context),
          // Main Dashboard Content
          Expanded(
            child: Container(
              color: Color(0xFFF5EEDC),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildStudentOverview()),
                      SizedBox(width: 20),
                      Expanded(child: _buildStudentProgress()),
                    ],
                  ),
                  SizedBox(height: 50),
                  _buildRecentActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Widget
  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF648BA2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teacher Name',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'email@example.com',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.chevronDown,
                      color: Colors.white, size: 16),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(100, 80, 10, 0),
                      items: [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Sidebar Buttons with navigation
          _buildSidebarButton('Dashboard', true),
          _buildSidebarButton('Students List', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentsListPage()),
            );
          }),
          _buildSidebarButton('Progress Monitoring', false, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProgressMonitoringPage()), // ✅ Fixed navigation
            );
          }),
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

  // Sidebar Button with navigation support
  Widget _buildSidebarButton(String title, [bool isActive = false, VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: GestureDetector(
        onTap: onTap, // Navigation functionality
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

  // Student Overview Pie Chart
  Widget _buildStudentOverview() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text('Student Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                      value: 40, title: '', color: Colors.red, radius: 50),
                  PieChartSectionData(
                      value: 60, title: '', color: Colors.green, radius: 50),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendIndicator(Colors.red, 'Girls'),
              SizedBox(width: 10),
              _buildLegendIndicator(Colors.green, 'Boys'),
            ],
          ),
        ],
      ),
    );
  }

  // Student Progress Bar Chart
  Widget _buildStudentProgress() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text('Student Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: 80, color: Colors.green)]),
                  BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(toY: 70, color: Colors.blue)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Legend Indicator
  Widget _buildLegendIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  // Recent Activities Table
  Widget _buildRecentActivities() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text('Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Colors.black54),
            children: [
              _buildTableRow(['Date', 'Action'], isHeader: true),
              _buildTableRow(['2025-02-24', 'Added new student']),
              _buildTableRow(['2025-03-23', 'Updated progress report']),
            ],
          ),
        ],
      ),
    );
  }

  // Table Row Builder
  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            cell,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
