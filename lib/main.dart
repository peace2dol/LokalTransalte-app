
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

const Color appPurple = Color(0xFF7652B5);
const Color appDarkPurple = Color(0xFF30204F);
const Color appBackground = Color(0xFFF8F4FF);
const Color appLavender = Color(0xFFEDE3FF);
const Color appLightPurple = Color(0xFFF3ECFF);
const Color appWhite = Color(0xFFFFFFFF);
const Color appGreen = appPurple;

void main() {
  runApp(const LokalTranslateApp());
}

class LokalTranslateApp extends StatelessWidget {
  const LokalTranslateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LokalTranslate',
      theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: appPurple,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: appBackground,
  fontFamily: 'Arial',
),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}


class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const HistoryScreen(),
      const FavouritesScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop)
                Container(
                  width: 260,
                  color: appLightPurple,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.translate,
                            color: appPurple,
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'LokalTranslate',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: appDarkPurple,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      _buildNavigationItem(
                        icon: Icons.home_outlined,
                        label: 'Home',
                        index: 0,
                      ),
                      _buildNavigationItem(
                        icon: Icons.history,
                        label: 'History',
                        index: 1,
                      ),
                      _buildNavigationItem(
                        icon: Icons.favorite_outline,
                        label: 'Favourites',
                        index: 2,
                      ),
                      _buildNavigationItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        index: 3,
                      ),

                      const Spacer(),

                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Made for local lingo 💜',
                          style: TextStyle(color: appPurple),
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: screens,
                ),
              ),
            ],
          ),

          bottomNavigationBar: isDesktop
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history),
                      label: 'History',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favourites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : appDarkPurple,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : appDarkPurple,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tileColor: isSelected ? appPurple : Colors.transparent,
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}


// HOME SCREEN

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String sourceLanguage = 'Malay';
  String targetLanguage = 'English';
  String toneMode = 'Casual';

  final TextEditingController textController = TextEditingController();
String? translationResult;
bool hasTranslated = false;


  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }


void translateText() {
  final input = textController.text.trim();

  if (input.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter some text first.'),
      ),
    );
    return;
  }

 setState(() {
  translationResult = 'Demo translation for: "$input"';
  hasTranslated = true;
});
}

  void changeSourceLanguage(String? value) {
    if (value == null) return;

    setState(() {
      sourceLanguage = value;

      if (sourceLanguage == targetLanguage) {
        targetLanguage = sourceLanguage == 'English' ? 'Malay' : 'English';
      }
    });
  }

  void changeTargetLanguage(String? value) {
    if (value == null) return;

    setState(() {
      targetLanguage = value;
    });
  }

  void swapLanguages() {
    setState(() {
      final previousSource = sourceLanguage;
      sourceLanguage = targetLanguage;
      targetLanguage = previousSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languages = ['Malay', 'English', 'Mandarin'];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speak local.\nTranslate naturally.',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 1.15,
              color: Color(0xFF351653),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Translate Malaysian slang into another language.',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
    const SizedBox(width: 20),
    Expanded(
      flex: 4,
      child: Image.asset(
        'assets/images/lokal_cat.png',
        height: 250,
        fit: BoxFit.contain,
      ),
    ),
  ],
),
const SizedBox(height: 28),

            
// MAIN CONVERSATIONAL TRANSLATION PANEL
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: const Color(0xFFFFFDFF),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: const Color(0xFFE7D9F7),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF68439A).withOpacity(0.06),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // LANGUAGE SELECTION
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: sourceLanguage,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
              items: languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: changeSourceLanguage,
            ),
          ),
          IconButton(
            onPressed: swapLanguages,
            icon: const Icon(Icons.swap_horiz),
            color: const Color(0xFF68439A),
            iconSize: 30,
            tooltip: 'Swap languages',
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: targetLanguage,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
              items: languages
                  .where((language) => language != sourceLanguage)
                  .map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: changeTargetLanguage,
            ),
          ),
        ],
      ),

      const SizedBox(height: 24),

      // TRANSLATION TONE
      Row(
        children: [
          const Text(
            'Tone',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF351653),
            ),
          ),
          const SizedBox(width: 20),
          ChoiceChip(
            label: const Text('Casual'),
            avatar: const Icon(Icons.chat_bubble_outline),
            selected: toneMode == 'Casual',
            onSelected: (selected) {
              setState(() {
                toneMode = 'Casual';
              });
            },
          ),
          const SizedBox(width: 10),
          ChoiceChip(
            label: const Text('Formal'),
            avatar: const Icon(Icons.business_center_outlined),
            selected: toneMode == 'Formal',
            onSelected: (selected) {
              setState(() {
                toneMode = 'Formal';
              });
            },
          ),
        ],
      ),

      const SizedBox(height: 30),

      // CAT GREETING BUBBLE
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              color: Color(0xFFF0E3FF),
              shape: BoxShape.circle,
            ),
           child: Image.asset(
  'assets/images/cat_head.png',
  width: 58,
  height: 58,
  fit: BoxFit.contain,
),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E3FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Hai! What would you like to translate today? 💬',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF351653),
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 28),

      // INPUT BOX
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD8C8EB),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type something... e.g. "Aku dah makan"',
                border: InputBorder.none,
                filled: false,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: translateText,
                icon: const Icon(Icons.translate),
                label: const Text('Translate'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7953A6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 28),

      // TRANSLATION RESPONSE
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Color(0xFFF0E3FF),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
  'assets/images/cat_head.png',
  width: 52,
  height: 52,
  fit: BoxFit.contain,
),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LokalTranslate says...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF68439A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hasTranslated
                        ? translationResult!
                        : 'Your translation will appear here.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF51465E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          if (translationResult == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No translation to copy yet.',
                                ),
                              ),
                            );
                            return;
                          }

                          await Clipboard.setData(
                            ClipboardData(text: translationResult!),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Translation copied successfully!',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          if (translationResult == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No translation to share yet.',
                                ),
                              ),
                            );
                            return;
                          }

                          await SharePlus.instance.share(
                            ShareParams(
                              text: translationResult!,
                              title: 'LokalTranslate Result',
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}

// HISTORY SCREEN

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateScreen(
      icon: Icons.history,
      title: 'Your translation history',
      message: 'Your previous translations will appear here.',
    );
  }
}

// FAVOURITES SCREEN

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateScreen(
      icon: Icons.favorite_outline,
      title: 'Your favourites',
      message: 'Save translations you love and find them here.',
    );
  }
}

// SETTINGS SCREEN

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String preferredLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Preferences',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Customise your LokalTranslate experience.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.language, color: appGreen),
                    SizedBox(width: 10),
                    Text(
                      'Preferred language',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: preferredLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: ['Malay', 'English', 'Mandarin']
                      .map(
                        (language) => DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        preferredLanguage = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.info_outline, color: appGreen),
            title: Text('About LokalTranslate'),
            subtitle: Text('Translate Malaysian slang naturally.'),
          ),
        ),
      ],
    );
  }
}

// REUSABLE EMPTY STATE

class EmptyStateScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyStateScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: appGreen),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
