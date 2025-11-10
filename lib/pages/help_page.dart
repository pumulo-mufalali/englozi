import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Getting Started Section
          _buildSectionHeader(context, 'Getting Started'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: Icon(Icons.play_circle_outline_rounded, color: theme.primaryColor),
              title: const Text('How to use Englozi'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHelpItem(
                        context,
                        '1. Main Sections',
                        'Swipe through the three main sections on the home screen:\n'
                        '• Phrases: Common Lozi phrases and expressions\n'
                        '• Translator: Search and translate English to Lozi words\n'
                        '• Names: Browse Lozi names and their meanings',
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        context,
                        '2. Search Functionality',
                        'Use the search bar to quickly find words, phrases, or names. '
                        'The app searches across all sections.',
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        context,
                        '3. Word Details',
                        'Tap on any word to view detailed information including:\n'
                        '• Definitions and descriptions\n'
                        '• Parts of speech (noun, verb, adjective, etc.)\n'
                        '• Synonyms and antonyms\n'
                        '• Related words',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Features Section
          _buildSectionHeader(context, 'Features'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildFeatureTile(
                  context,
                  icon: Icons.volume_up_rounded,
                  title: 'Text-to-Speech',
                  description: 'Tap the speaker icon to hear pronunciations. Available on word detail pages.',
                ),
                const Divider(height: 1),
                _buildFeatureTile(
                  context,
                  icon: Icons.favorite_rounded,
                  title: 'Favorites',
                  description: 'Save words you want to remember by tapping the heart icon. Access them from the drawer menu.',
                ),
                const Divider(height: 1),
                _buildFeatureTile(
                  context,
                  icon: Icons.history_rounded,
                  title: 'History',
                  description: 'View your recently searched words. Access from the drawer menu.',
                ),
                const Divider(height: 1),
                _buildFeatureTile(
                  context,
                  icon: Icons.shuffle_rounded,
                  title: 'Random Word',
                  description: 'Discover new words by using the Random Word feature in the drawer menu.',
                ),
                const Divider(height: 1),
                _buildFeatureTile(
                  context,
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  description: 'Toggle between light and dark themes in Settings for comfortable viewing.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Navigation Section
          _buildSectionHeader(context, 'Navigation'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildNavigationItem(
                  context,
                  'Drawer Menu',
                  'Tap the menu icon (☰) in the top-left corner to access:\n'
                  '• Pronunciation\n'
                  '• Random Word\n'
                  '• Favourites\n'
                  '• History\n'
                  '• Settings\n'
                  '• Help\n'
                  '• About',
                ),
                const Divider(height: 1),
                _buildNavigationItem(
                  context,
                  'Swipe Navigation',
                  'On the home screen, swipe left or right to navigate between the three main sections.',
                ),
                const Divider(height: 1),
                _buildNavigationItem(
                  context,
                  'Word Links',
                  'Words in blue are clickable. Tap them to view their definitions and related information.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tips & Tricks Section
          _buildSectionHeader(context, 'Tips & Tricks'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTipItem(context, '💡', 'Use the search function to quickly find words without browsing.'),
                  const SizedBox(height: 12),
                  _buildTipItem(context, '💡', 'Save frequently used words to Favourites for quick access.'),
                  const SizedBox(height: 12),
                  _buildTipItem(context, '💡', 'Explore related words by tapping on synonyms and antonyms.'),
                  const SizedBox(height: 12),
                  _buildTipItem(context, '💡', 'Use the Random Word feature to discover new vocabulary.'),
                  const SizedBox(height: 12),
                  _buildTipItem(context, '💡', 'Enable Dark Mode in Settings for comfortable night-time reading.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // FAQ Section
          _buildSectionHeader(context, 'Frequently Asked Questions'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildFAQItem(
                  context,
                  'How do I search for a word?',
                  'Use the search bar at the top of any page. Type the English word and the app will show matching Lozi translations.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'Can I hear pronunciations?',
                  'Yes! Tap the speaker icon (🔊) on any word detail page to hear the pronunciation using text-to-speech.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'How do I save words to favorites?',
                  'Open any word detail page and tap the heart icon in the top-right corner. Access your favorites from the drawer menu.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'Can I clear my search history?',
                  'Yes, go to Settings > Data > Clear History. This will remove all your search history.',
                ),
                const Divider(height: 1),
                _buildFAQItem(
                  context,
                  'How do I change the theme?',
                  'Go to Settings > Appearance > Dark Mode, or use the theme toggle in the drawer menu.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact Section
          _buildSectionHeader(context, 'Need More Help?'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'If you have questions or need assistance, please:',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: theme.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Check the About section for contact information',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.bug_report_outlined, color: theme.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Report bugs or issues through the app',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
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

  Widget _buildHelpItem(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(description, style: theme.textTheme.bodyMedium),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildNavigationItem(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String emoji, String tip) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    final theme = Theme.of(context);
    return ExpansionTile(
      leading: Icon(Icons.help_outline_rounded, color: theme.primaryColor),
      title: Text(
        question,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

