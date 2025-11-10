# Englozi

**Englozi** is a Flutter-based mobile application designed to help users learn and understand the **Lozi language** through English translations. The app serves as a comprehensive dictionary and learning tool, featuring words, names, and common phrases with pronunciation support.

---

## 📱 Features

### Core Functionality
- **Three Main Sections:**
  - **Phrases**: Browse common Lozi phrases and expressions
  - **Translator**: Search and translate English words to Lozi
  - **Names**: Explore Lozi names and their meanings

- **Search Functionality**: Quick search across all sections with real-time filtering
- **Word Details**: Comprehensive word information including:
  - Definitions and descriptions
  - Parts of speech (noun, verb, adjective, adverb, etc.)
  - Synonyms and antonyms
  - Related words with clickable navigation

### User Experience
- **Text-to-Speech (TTS)**: Audio pronunciations for words and phrases
- **Favorites System**: Save frequently used words for quick access
- **Search History**: Track your recently searched words
- **Random Word Discovery**: Explore new vocabulary with the random word feature
- **Dark/Light Theme**: Toggle between themes for comfortable viewing
- **Intuitive UI**: Material Design 3 with smooth animations and transitions

### Additional Features
- **Settings Page**: Customize app preferences
- **Help & Support**: Comprehensive help documentation
- **Drawer Navigation**: Easy access to all features
- **Responsive Design**: Optimized for various screen sizes

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design 3** - Modern UI components

### Backend & Storage
- **SQLite** - Local database for words, phrases, and names
- **sqflite** - Flutter SQLite plugin
- **path_provider** - File system path utilities

### State Management & Theming
- **Provider** - State management solution
- **SharedPreferences** - Theme preference storage

### Additional Packages
- **flutter_tts** - Text-to-speech functionality
- **scroll_snap_list** - Smooth scrolling list with snap behavior

### Future Scope
- Django API integration for cloud synchronization
- Multi-language support
- Offline/online sync capabilities

---

## 📸 Screenshots

| Splash Screen | Main Sections | Side Drawer |
|---------------|--------------|-------------|
| ![Splash](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/splash_screen.png?raw=true) | ![Sections](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/the_three_sections.png?raw=true) | ![Drawer](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/side_drawer.png?raw=true) |

| Word Search | Word Details | Lozi Names |
|-------------|--------------|------------|
| ![Search](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/word_search.png?raw=true) | ![Detail](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/word_details.png?raw=true) | ![Names](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/lozi_names.png?raw=true) |

| Phrases Page | Pronunciation | History Page |
|--------------|---------------|--------------|
| ![Phrases](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/phrases.png?raw=true) | ![Pronunciation](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/pronunciation_page.png?raw=true) | ![History](https://github.com/pumulo-mufalali/englozi/blob/master/lib/screenshots/history_page.png?raw=true) |

---

## 📦 Installation

### Prerequisites
- Flutter SDK (>=2.18.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/pumulo-mufalali/englozi.git
   cd englozi
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📁 Project Structure

```
lib/
├── databases/          # SQLite database helpers
│   ├── favourite_db.dart
│   ├── history_db.dart
│   ├── loziname_db.dart
│   ├── phrases_db.dart
│   └── translator_db.dart
├── features/           # Reusable features
│   ├── drawer.dart
│   ├── favourite.dart
│   └── history.dart
├── model/             # Data models
│   ├── fav_model.dart
│   ├── his_model.dart
│   ├── loz_model.dart
│   ├── phr_model.dart
│   └── tra_model.dart
├── pages/             # App screens
│   ├── help_page.dart
│   ├── names_page.dart
│   ├── phrases_page.dart
│   ├── pronounciation_page.dart
│   ├── settings_page.dart
│   ├── splash_page.dart
│   ├── translator_page.dart
│   └── word_details_page.dart
├── theme/             # Theme configuration
│   └── theme_provider.dart
├── main.dart          # App entry point
└── welcome_page.dart  # Home screen
```

---

## 🎯 Usage Guide

### Getting Started
1. Launch the app to see the splash screen
2. Navigate through three main sections by swiping left/right
3. Use the search bar to find specific words or phrases
4. Tap on any word to view detailed information

### Key Features

**Search:**
- Type in the search bar to filter results in real-time
- Search works across all sections (Phrases, Translator, Names)

**Word Details:**
- Tap any word to see comprehensive information
- Click on blue highlighted words to navigate to related words
- Use the speaker icon (🔊) to hear pronunciations
- Save words to favorites using the heart icon

**Navigation:**
- Access the drawer menu from the top-left corner (☰)
- Swipe between sections on the home screen
- Use back button or drawer to navigate between pages

**Settings:**
- Toggle dark/light theme
- Configure app preferences
- Clear history or favorites
- Access help and support

---

## 🗄️ Database Structure

The app uses three SQLite databases:
- **englozi.db**: Main translator database
- **phrasesDB.db**: Lozi phrases database
- **loznameDB.db**: Lozi names database

Each database is stored locally and contains structured data for efficient searching and retrieval.

---

## 🎨 Theme Customization

The app supports both light and dark themes:
- **Light Theme**: Teal primary color (#14B8A6) with light backgrounds
- **Dark Theme**: Teal accents with dark backgrounds (#0F172A)

Theme preference is saved using SharedPreferences and persists across app restarts.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

This project is licensed under the [MIT License](./LICENSE).

---

## 👤 Author

**Pumulo Mufalali**

- GitHub: [@pumulo-mufalali](https://github.com/pumulo-mufalali)

---

## 🙏 Acknowledgments

- Built to preserve and promote the Lozi language
- Special thanks to the Lozi language community
- Flutter team for the amazing framework

---

## 📞 Support

For support, questions, or bug reports:
- Check the Help section in the app
- Visit the About page for contact information
- Open an issue on GitHub

---

## 🔮 Future Enhancements

- [ ] Cloud synchronization
- [ ] Multi-language support
- [ ] User accounts and progress tracking
- [ ] Quiz and learning games
- [ ] Community contributions
- [ ] Offline mode improvements
- [ ] Enhanced search algorithms
- [ ] Audio pronunciation improvements

---

**Made with ❤️ for the Lozi language community**
