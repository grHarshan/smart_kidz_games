import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Sample data - replace with actual data from your backend
  final String childName = "javindi";
  final String childAvatar = "👧";
  final int childAge = 7;
  final int totalGamesPlayed = 127;
  final int puzzlesSolved = 89;
  final int currentStreak = 15;
  final int smartPoints = 1250;
  final int currentLevel = 5;
  final double levelProgress = 0.68;
  final double dailyGoalProgress = 0.85;
  final int weeklyPlayTime = 245; // minutes
  final int averageSessionTime = 12; // minutes
  final int todayPlayTime = 35; // minutes today
  final int totalAppUsageTime = 1680; // total minutes since start
  
  List<Map<String, dynamic>> get mostPlayedGames => [
    {'name': 'Alphabet Drawing Game', 'playTime': 85, 'icon': '✏️'},
    {'name': 'Arrange the Number', 'playTime': 67, 'icon': '🔢'},
    {'name': 'Animal Challenge', 'playTime': 54, 'icon': '🦁'},
    {'name': 'Colour Matching', 'playTime': 45, 'icon': '🎨'},
    {'name': 'Pepper Jump', 'playTime': 38, 'icon': '🌶️'},
    {'name': 'Letter Challenge', 'playTime': 32, 'icon': '🔠'},
    {'name': 'Drag Letters to Box', 'playTime': 28, 'icon': '📦'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF87CEEB),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFF98FB98),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        _buildHeader(),
                        SizedBox(height: 20),
                        _buildChildProfileCard(),
                        SizedBox(height: 20),
                        _buildStatsGrid(),
                        SizedBox(height: 20),
                        _buildProgressSection(),
                        SizedBox(height: 20),
                        _buildMostPlayedSection(),
                        SizedBox(height: 20),
                        _buildLearningInsights(),
                        SizedBox(height: 20),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () {
                  // Since this is the main page, we'll show a snackbar instead
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('This is the main page!')),
                  );
                },
              ),
              Text(
                'ThinkiTots',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E8B57),
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white, size: 28),
                onPressed: () => _showSettingsDialog(),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Parent Dashboard',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildProfileCard() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    childAvatar,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E8B57),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Age: $childAge years old',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF6B8A), Color(0xFFFFD700)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Level $currentLevel Thinker',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // App Usage Time Section
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(0xFFE9ECEF)),
            ),
            child: Column(
              children: [
                Text(
                  '⏰ App Usage Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E8B57),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeInfo('Today', '${todayPlayTime}m', Color(0xFFFF6B8A)),
                    _buildTimeInfo('This Week', '${weeklyPlayTime ~/ 60}h ${weeklyPlayTime % 60}m', Color(0xFF87CEEB)),
                    _buildTimeInfo('Total', '${totalAppUsageTime ~/ 60}h', Color(0xFF98FB98)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, Color color) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Learning Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildStatCard('🎮', totalGamesPlayed.toString(), 'Games Played'),
              _buildStatCard('🧩', puzzlesSolved.toString(), 'Puzzles Solved'),
              _buildStatCard('🔥', '$currentStreak days', 'Current Streak'),
              _buildStatCard('⭐', smartPoints.toString(), 'Smart Points'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F8FF), Color(0xFFE6F3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF87CEEB), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 Progress Tracking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          SizedBox(height: 20),
          _buildProgressItem('Next Level Progress', levelProgress),
          SizedBox(height: 15),
          _buildProgressItem('Today\'s Learning Goal', dailyGoalProgress),
          SizedBox(height: 15),
          _buildProgressItem('Weekly Activity', weeklyPlayTime / 300.0),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2E8B57),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B8A), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMostPlayedSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎮 Most Played Games',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          SizedBox(height: 15),
          // Show top 4 games
          ...mostPlayedGames.take(4).toList().asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> game = entry.value;
            return _buildGameItem(
              game['icon'],
              game['name'],
              '${game['playTime']} min',
              index + 1,
            );
          }).toList(),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF87CEEB), width: 1),
            ),
            child: Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$childName loves drawing letters! Consider more writing practice games.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2E8B57),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameItem(String icon, String name, String playTime, int rank) {
    Color rankColor;
    switch (rank) {
      case 1:
        rankColor = Color(0xFFFFD700);
        break;
      case 2:
        rankColor = Color(0xFFC0C0C0);
        break;
      case 3:
        rankColor = Color(0xFFCD7F32);
        break;
      default:
        rankColor = Color(0xFF87CEEB);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rankColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(icon, style: TextStyle(fontSize: 24)),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E8B57),
                  ),
                ),
                Text(
                  'Play time: $playTime',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              playTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningInsights() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧠 Learning Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
          SizedBox(height: 20),
          _buildInsightRow('⏱️', 'Avg. Session Time', '$averageSessionTime min'),
          _buildInsightRow('📅', 'Weekly Play Time', '${weeklyPlayTime ~/ 60}h ${weeklyPlayTime % 60}m'),
          _buildInsightRow('🎯', 'Favorite Category', 'Alphabet Drawing'),
          _buildInsightRow('🏆', 'Best Performance', 'Letter Recognition'),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String emoji, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildGradientButton(
            onPressed: () => _showDetailedReport(),
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B8A), Color(0xFFFFD700)],
            ),
            text: '📊 Detailed Report',
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildGradientButton(
            onPressed: () => _showParentalControls(),
            gradient: LinearGradient(
              colors: [Color(0xFF87CEEB), Color(0xFF98FB98)],
            ),
            text: '⚙️ Controls',
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required LinearGradient gradient,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('⚙️ Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: Switch(value: true, onChanged: (val) {}),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Screen Time Limits'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Privacy Settings'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailedReport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('📊 Detailed Report'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Summary for $childName (Age $childAge):'),
                SizedBox(height: 10),
                Text('• Total play time: ${weeklyPlayTime ~/ 60}h ${weeklyPlayTime % 60}m'),
                Text('• Games completed: 23'),
                Text('• Learning goals met: 6/7'),
                Text('• New skills unlocked: 3'),
                Text('• Favorite game: ${mostPlayedGames[0]['name']}'),
                Text('• Most active day: Tuesday'),
                SizedBox(height: 10),
                Text('Recommendations for $childName:'),
                Text('• Continue with ${mostPlayedGames[0]['name']} - great progress!'),
                Text('• Try more ${mostPlayedGames[1]['name']} activities'),
                Text('• Perfect age for letter recognition games'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showParentalControls() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('⚙️ Parental Controls'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Daily Time Limit'),
                subtitle: Text('30 minutes'),
                trailing: Icon(Icons.edit),
              ),
              ListTile(
                title: Text('Difficulty Level'),
                subtitle: Text('Age appropriate'),
                trailing: Icon(Icons.edit),
              ),
              ListTile(
                title: Text('Content Filter'),
                subtitle: Text('Enabled'),
                trailing: Switch(value: true, onChanged: (val) {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
