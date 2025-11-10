import 'package:englozi/model/phr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PhrasesDetailsPage extends StatefulWidget {
  final PhraseDictionary phrase;

  const PhrasesDetailsPage({
    Key? key,
    required this.phrase,
  }) : super(key: key);

  @override
  State<PhrasesDetailsPage> createState() => _PhrasesDetailsPageState();
}

class _PhrasesDetailsPageState extends State<PhrasesDetailsPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    flutterTts.awaitSpeakCompletion(true);
  }

  void speakLozi(String text) async {
    await flutterTts.stop();
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("sw");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  void speakEnglish(String text) async {
    await flutterTts.stop();
    await flutterTts.setPitch(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage("en");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phrase Details'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  isSwitched ? Icons.translate_rounded : Icons.language_rounded,
                  size: 18,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeColor: theme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // English Phrase Card
            _buildSectionHeader(context, 'English'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark
                      ? theme.dividerColor.withOpacity(0.2)
                      : theme.dividerColor.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF10B981).withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: const Text(
                            'ENG',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.volume_up_rounded,
                            color: theme.primaryColor,
                          ),
                          onPressed: () => speakEnglish(widget.phrase.phrEnglish),
                          tooltip: 'Play pronunciation',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.phrase.phrEnglish[0].toUpperCase() +
                          widget.phrase.phrEnglish.substring(1),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lozi Phrase Card
            _buildSectionHeader(context, 'Lozi'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark
                      ? theme.dividerColor.withOpacity(0.2)
                      : theme.dividerColor.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: const Text(
                            'LOZI',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6366F1),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.volume_up_rounded,
                            color: theme.primaryColor,
                          ),
                          onPressed: () => speakLozi(widget.phrase.phrSilozi),
                          tooltip: 'Play pronunciation',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.phrase.phrSilozi[0].toUpperCase() +
                          widget.phrase.phrSilozi.substring(1),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark
                      ? theme.dividerColor.withOpacity(0.2)
                      : theme.dividerColor.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.volume_up_rounded,
                      label: isSwitched ? 'Lozi' : 'English',
                      onPressed: () {
                        if (isSwitched) {
                          speakLozi(widget.phrase.phrSilozi);
                        } else {
                          speakEnglish(widget.phrase.phrEnglish);
                        }
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.primaryColor.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

