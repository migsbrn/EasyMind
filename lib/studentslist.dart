import 'package:easymind/ImprovementPage.dart';
import 'package:easymind/ProgressMonitoringPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'teacher-dashboard.dart';

class StudentsListPage extends StatefulWidget {
  @override
  _StudentsListPageState createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  String selectedAge = 'All';
  String selectedCondition = 'All';

  final List<String> ageOptions = ['All', '6', '7', '8', '9', '10'];
  final List<String> conditionOptions = ['All', 'Autism', 'Dyslexia', 'ADHD', 'Down Syndrome'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context, 'Students List'),
          Expanded(
            child: Container(
              color: Color(0xFFF5EEDC),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Students List',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                        label: Text('Add Student', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF648BA2),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              hintText: 'Search...',
                              border: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.black54, size: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      // Filter buttons similar to the image
                      _buildFilterDropdown('Filter by', selectedAge, ageOptions, (newValue) {
                        setState(() {
                          selectedAge = newValue!;
                        });
                      }),
                      SizedBox(width: 10),
                      _buildFilterDropdown('Filter by', selectedCondition, conditionOptions, (newValue) {
                        setState(() {
                          selectedCondition = newValue!;
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 290),
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(3),
                            4: FlexColumnWidth(2),
                          },
                          border: TableBorder(
                            horizontalInside: BorderSide(width: 1, color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Color(0xFF8BBBD1)),
                              children: [
                                _buildTableHeader('Nickname'),
                                _buildTableHeader('Name'),
                                _buildTableHeader('Age'),
                                _buildTableHeader('Condition'),
                                _buildTableHeader('Actions'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildTableCell('John'),
                                _buildTableCell('John Aquino'),
                                _buildTableCell('9'),
                                _buildTableCell('Autism'),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.pen, color: Colors.black54),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, String activePage) {
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teacher Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('email@example.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.chevronDown, color: Colors.white, size: 16),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          _buildSidebarButton(context, 'Dashboard', activePage == 'Dashboard', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherDashboard()));
          }),
          _buildSidebarButton(context, 'Students List', activePage == 'Students List', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentsListPage()));
          }),
          _buildSidebarButton(context, 'Progress Monitoring', activePage == 'Progress Monitoring', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressMonitoringPage()));
          }),
          _buildSidebarButton(context, 'Improvements', activePage == 'Improvements', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImprovementsPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(BuildContext context, String title, bool isActive, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: GestureDetector(
        onTap: onPressed,
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.black87)),
          Icon(Icons.arrow_drop_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) => Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change text color to white
          ),
        ),
      ),
    );

  Widget _buildTableCell(String text, {bool bold = false}) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text(text, style: TextStyle(fontSize: 16, fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      );
}
