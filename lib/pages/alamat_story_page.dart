import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:audioplayers/audioplayers.dart'; // commented until audio is ready
import '../theme.dart';

class AlamatStoryPage extends StatefulWidget {
  @override
  _AlamatStoryPageState createState() => _AlamatStoryPageState();
}

class _AlamatStoryPageState extends State<AlamatStoryPage> {
  bool isEnglish = true;
  // final AudioPlayer _audio = AudioPlayer(); // commented
  bool playing = false;
  int highlightedIndex = -1;
  Timer? _timer;

  int _currentPage = 0; // <-- track progress
  late PageController _pageController;

  final List<Map<String, dynamic>> storyScenes = [
    {
      'img': 'assets/images/stories/alamat-ng-pinya/scene1-alamat.png',
      'en': "A long time ago, in a quiet village, there lived a kind woman named Aling Rosa "
          "and her only daughter, Pinang. Aling Rosa loved Pinang very much, but because of her love, she spoiled her daughter. "
          "Aling Rosa wanted Pinang to learn how to cook, clean, and help around the house. "
          "But Pinang always said, “I already know how to do that!” So she never really learned, and her mother "
          "eventually gave up teaching her.",
      'fil': "Noong unang panahon may nakatirang mag-ina sa isang malayong pook. "
          "Ang ina ay si Aling Rosa at ang anak ay si Pinang. Mahal na mahal ni Aling Rosa ang kanyang bugtong na anak. "
          "Kaya lumaki si Pinang sa layaw. Gusto ng ina na matuto si Pinang ng mga gawaing bahay, ngunit laging ikinakatwiran "
          "ni Pinang na alam na niyang gawin ang mga itinuturo ng ina. Kaya't pinabayaan na lang niya ang kanyang anak."
    },
    {
      'img': 'assets/images/stories/alamat-ng-pinya/scene2-alamat.png',
      'en': "But the daughter was lazy. Whenever her mother asked her "
          "to find something, she would say, 'I cannot find it!'",
      'fil': "Ngunit tamad ang anak. Kapag pinapahanap siya ng nanay "
          "niya, lagi niyang sinasabi, 'Hindi ko makita!'"
    },
    {
      'img': 'assets/images/stories/alamat-ng-pinya/scene3-alamat.png',
      'en': "One day, her mother wished that her daughter would grow many eyes to see "
          "better. And soon, the girl turned into a pineapple!",
      'fil': "Isang araw, nag-wish ang kanyang nanay na magkaroon siya ng maraming mata para makakita. "
          "At agad, naging pinya ang anak!"
    },
    {
      'img': 'assets/images/stories/alamat-ng-pinya/scene4-alamat.png',
      'en': "From then on, people remembered the story whenever they saw a pineapple, "
          "with its many eyes covering the fruit.",
      'fil': "Mula noon, naaalala ng mga tao ang kuwento tuwing makakakita sila ng pinya, "
          "na may maraming mata sa balat ng prutas."
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    // _audio.dispose(); // commented
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentPage + 1) / storyScenes.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alamat ng Pinya',
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
        backgroundColor: PalitabTheme.accentWarm,
      ),
      body: Column(
        children: [
          // ✅ Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  PalitabTheme.accentHot,
                ),
              ),
            ),
          ),

          // ✅ Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: storyScenes.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final scene = storyScenes[index];
                final text = isEnglish ? scene['en'] : scene['fil'];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(scene['img'], fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              text,
                              style: GoogleFonts.patrickHand(
                                fontSize: 20,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ✅ Cute dots for kids
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(storyScenes.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 16 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? PalitabTheme.accentHot
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleButtons(
              borderRadius: BorderRadius.circular(12),
              fillColor: PalitabTheme.accentWarm,
              selectedColor: Colors.white,
              isSelected: [isEnglish, !isEnglish],
              onPressed: (i) {
                setState(() => isEnglish = i == 0);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('English',
                      style: GoogleFonts.patrickHand(fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Filipino',
                      style: GoogleFonts.patrickHand(fontSize: 18)),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                playing ? Icons.stop : Icons.play_arrow,
                color: PalitabTheme.accentHot,
                size: 32,
              ),
              onPressed: () {
                // Audio playback commented
              },
            ),
            IconButton(
              icon: const Icon(Icons.record_voice_over,
                  color: Colors.teal, size: 32),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Record Retell (placeholder)')),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
