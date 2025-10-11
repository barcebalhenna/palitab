import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Reimagined Teacher Dashboard
class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Sample/mock metrics — replace with real data source
  final List<int> weeklyVocab = [4, 6, 8, 10, 7]; // this week last 5 weeks
  final int readingMinutesThisWeek = 320;
  final Map<String, double> comprehensionByType = {
    'Literal': 0.88,
    'Inferential': 0.72,
    'Evaluative': 0.55,
  };
  final int retellsPending = 3;
  final double melcAlignmentPercent = 0.78;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isSmallScreen(BoxConstraints constraints) =>
      constraints.maxWidth < 420; // mobile threshold

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final small = isSmallScreen(constraints);
      final horizontalPadding = small ? 12.0 : 20.0;

      return SafeArea(
        child: SingleChildScrollView(
          padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(small),
              SizedBox(height: 16),
              _buildTabs(small),
              SizedBox(height: 12),
              SizedBox(
                // card-like container for TabBarView contents
                height: small ? 760 : 520,
                child: TabBarView(controller: _tabController, children: [
                  _overviewTab(small),
                  _insightsTab(small),
                  _assessmentsTab(small),
                ]),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWelcomeCard(bool small) {
    return Container(
      padding: EdgeInsets.all(small ? 14 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PalitabTheme.accentWarm, PalitabTheme.accentHot],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: PalitabTheme.accentHot.withOpacity(0.16),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Semantics(
            label: 'Welcome avatar',
            child: Container(
              width: small ? 58 : 70,
              height: small ? 58 : 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('👋',
                    style:
                    TextStyle(fontSize: small ? 32 : 36, letterSpacing: 0)),
              ),
            ),
          ),
          SizedBox(width: small ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Mrs. Santos!',
                  style: GoogleFonts.fredoka(
                    fontSize: small ? 16 : 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Class 2B • 28 students • 3 retells pending feedback',
                  style: GoogleFonts.fredoka(
                    fontSize: small ? 12 : 13,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _tinyChip('MELC aligned', Icons.check_circle_outline),
                    _tinyChip('Weekly view', Icons.calendar_today),
                    _tinyChip('Share to parents', Icons.send_outlined),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tinyChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.fredoka(
                fontSize: 12,
                color: Colors.white70,
              )),
        ],
      ),
    );
  }

  Widget _buildTabs(bool small) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: PalitabTheme.accentHot,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: PalitabTheme.accentHot.withOpacity(0.08),
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.dashboard_outlined),
            child: Text('Overview', style: GoogleFonts.fredoka()),
          ),
          Tab(
            icon: Icon(Icons.auto_graph_outlined),
            child: Text('Class Insights', style: GoogleFonts.fredoka()),
          ),
          Tab(
            icon: Icon(Icons.assignment_turned_in_outlined),
            child: Text('Assessments', style: GoogleFonts.fredoka()),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Overview tab: high level cards + small charts
  // -------------------------
  Widget _overviewTab(bool small) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          // Top KPI row (responsive)
          Flex(
            direction: small ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _kpiCard(
                title: 'Vocab This Week',
                value: '${weeklyVocab.last}',
                subtitle: 'words mastered',
                description: 'Target: 8/wk',
                color: PalitabTheme.purple,
                small: small,
                child: _miniSparkline(weeklyVocab),
              )),
              SizedBox(width: small ? 0 : 12, height: small ? 12 : 0),
              Expanded(child: _kpiCard(
                title: 'Reading Time',
                value: '${readingMinutesThisWeek} min',
                subtitle: 'this week',
                description: 'Avg/day: ${(readingMinutesThisWeek/7).round()} min',
                color: PalitabTheme.teal,
                small: small,
                child: _circularProgressWidget(readingMinutesThisWeek / 600), // 600 = optional weekly target minutes
              )),
              SizedBox(width: small ? 0 : 12, height: small ? 12 : 0),
              Expanded(child: _kpiCard(
                title: 'MELC Alignment',
                value: '${(melcAlignmentPercent * 100).round()}%',
                subtitle: 'standards matched',
                description: 'Auto-suggest MELCs',
                color: PalitabTheme.accentHot,
                small: small,
                child: _progressBar(melcAlignmentPercent),
              )),
            ],
          ),
          SizedBox(height: 14),

          // Comprehension breakdown + retell widget
          Flex(
            direction: small ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _cardContainer(
                  title: 'Comprehension by Question Type',
                  small: small,
                  child: Column(
                    children: [
                      // Bars for each type
                      ...comprehensionByType.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _labelledBar(
                              label: e.key, percent: e.value, small: small),
                        );
                      }).toList(),
                      SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tip: Focus lesson on weaker types (evaluative).',
                          style: GoogleFonts.fredoka(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: small ? 0 : 12, height: small ? 12 : 0),
              Expanded(
                flex: 1,
                child: _cardContainer(
                  title: 'Retell Assessments',
                  small: small,
                  child: Column(
                    children: [
                      Text(
                        '$retellsPending pending',
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PalitabTheme.accentHot,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Listen, assess, and leave feedback\n(quick rubric included)',
                        style: GoogleFonts.fredoka(
                            fontSize: 13, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // open retell queue
                        },
                        icon: Icon(Icons.mic_none_outlined),
                        label: Text('Open Retell Queue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalitabTheme.accentHot,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                          onPressed: () {
                            // download quick rubric or open
                          },
                          child: Text('Open quick rubric',
                              style: GoogleFonts.fredoka())),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Class Insights: sortable list, per-student compact cards and filters
  // -------------------------
  Widget _insightsTab(bool small) {
    // mock students
    final students = [
      {'name': 'Eman Santos', 'vocab': 10, 'readMin': 80, 'avgScore': 88},
      {'name': 'Alex Reyes', 'vocab': 6, 'readMin': 50, 'avgScore': 72},
      {'name': 'Maya Villar', 'vocab': 3, 'readMin': 30, 'avgScore': 60},
      {'name': 'Liza Cruz', 'vocab': 12, 'readMin': 95, 'avgScore': 92},
    ];

    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          _cardContainer(
            title: 'Class Performance Snapshot',
            small: small,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _miniInfoTile(
                        title: 'At/Above Target',
                        value: '18 / 28',
                        hint: 'students',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _miniInfoTile(
                          title: 'Avg. Reading (wk)', value: '45 min', hint: ''),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _miniInfoTile(
                          title: 'Avg Quiz Score', value: '78%', hint: ''),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Students',
                        style: GoogleFonts.fredoka(
                            fontSize: 14, fontWeight: FontWeight.w700))),
                SizedBox(height: 10),
                // student list
                Column(
                  children: students.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _studentListTile(
                        name: s['name'] as String,
                        vocab: s['vocab'] as int,
                        readMin: s['readMin'] as int,
                        score: s['avgScore'] as int,
                        small: small,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Assessments: quizzes, MELC mapping, export/share
  // -------------------------
  Widget _assessmentsTab(bool small) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        children: [
          _cardContainer(
            title: 'Recent Quizzes & Breakdown',
            small: small,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Science Short Quiz - Sep 29',
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
                  subtitle: Text('Class average: 83% • Items mapped to MELC 2.1'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Comprehension Check - Oct 3',
                      style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
                  subtitle: Text('Item breakdown by type available'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _cardContainer(
            title: 'Share Progress with Parents',
            small: small,
            child: Column(
              children: [
                Text(
                  'Create a weekly summary to send to parents. Auto-highlight low-performing competencies and recommended activities.',
                  style: GoogleFonts.fredoka(fontSize: 13, color: Colors.grey[700]),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.download_outlined),
                        label: Text('Export PDF'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.send_outlined),
                        label: Text('Send to Parents'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalitabTheme.accentHot,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // -------------------------
  // Reusable widgets
  // -------------------------
  Widget _kpiCard({
    required String title,
    required String value,
    required String subtitle,
    required String description,
    required Color color,
    required bool small,
    required Widget child,
  }) {
    return _cardContainer(
      title: title,
      small: small,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(value,
                      style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                ),
                SizedBox(width: 8),
                SizedBox(width: 64, height: 64, child: child),
              ],
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(subtitle,
                  style:
                  GoogleFonts.fredoka(fontSize: 12, color: Colors.grey[700])),
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(description,
                  style:
                  GoogleFonts.fredoka(fontSize: 12, color: Colors.grey[500])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardContainer({required String title, required Widget child, bool small = false}) {
    return Container(
      padding: EdgeInsets.all(small ? 10 : 14),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.fredoka(
                  fontSize: small ? 14 : 15, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // mini sparkline implemented with simple bars to avoid external libs
  Widget _miniSparkline(List<int> values) {
    final maxVal = (values.isEmpty) ? 1 : values.reduce((a, b) => a > b ? a : b);
    return LayoutBuilder(builder: (context, constraints) {
      final barWidth = (constraints.maxWidth - (values.length - 1) * 4) / values.length;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((v) {
          final heightFactor = (maxVal == 0) ? 0.1 : v / maxVal;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: barWidth.clamp(4.0, 20.0),
              height: (constraints.maxHeight * 0.9) * heightFactor + 4,
              decoration: BoxDecoration(
                color: PalitabTheme.purple.withOpacity(0.16),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _circularProgressWidget(double fraction) {
    final clipped = fraction.clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: clipped,
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation(PalitabTheme.teal),
          backgroundColor: Colors.grey[200],
        ),
        Text('${(clipped * 100).round()}%',
            style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.w700))
      ],
    );
  }

  Widget _progressBar(double fraction) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation(PalitabTheme.accentHot),
      ),
    );
  }

  Widget _labelledBar({required String label, required double percent, required bool small}) {
    return Row(
      children: [
        SizedBox(
          width: small ? 86 : 110,
          child: Text(label, style: GoogleFonts.fredoka(fontSize: 13)),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent.clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: percent >= 0.8
                        ? PalitabTheme.teal
                        : (percent >= 0.6 ? PalitabTheme.purple : PalitabTheme.accentWarm),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 44,
          child: Text('${(percent * 100).round()}%',
              style: GoogleFonts.fredoka(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _miniInfoTile({required String title, required String value, required String hint}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.fredoka(
                  fontSize: 16, fontWeight: FontWeight.bold, color: PalitabTheme.accentHot)),
          SizedBox(height: 4),
          Text(title, style: GoogleFonts.fredoka(fontSize: 12, color: Colors.grey[700])),
          if (hint.isNotEmpty)
            SizedBox(
              height: 6,
            ),
          if (hint.isNotEmpty)
            Text(hint, style: GoogleFonts.fredoka(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _studentListTile({
    required String name,
    required int vocab,
    required int readMin,
    required int score,
    required bool small,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: PalitabTheme.teal.withOpacity(0.12),
            child: Text(name[0], style: GoogleFonts.fredoka(color: PalitabTheme.teal)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Vocab: $vocab • Read: ${readMin}min • Score: $score%',
                    style: GoogleFonts.fredoka(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // quick action: open student detail
            },
            icon: Icon(Icons.chevron_right_rounded),
            color: Colors.grey[500],
            tooltip: 'Open student details',
          )
        ],
      ),
    );
  }
}
