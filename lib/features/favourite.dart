import 'package:flutter/material.dart';
import 'package:englozi/model/fav_model.dart';
import 'package:englozi/pages/word_details_page.dart';
import 'package:englozi/databases/favourite_db.dart';
import 'package:englozi/databases/translator_db.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final DatabaseFavourite _favouriteDB = DatabaseFavourite.instance;
  final DatabaseHelper _dictionaryDB = DatabaseHelper.instance;

  List<Favourite> _favourites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() => _isLoading = true);
    try {
      final result = await _favouriteDB.getAllFavourites();
      setState(() => _favourites = result.reversed.toList()); // Newest first
    } catch (e) {
      _showSnackBar('Error loading favourites');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteFavourite(Favourite favourite) async {
    try {
      await _favouriteDB.deleteFavourite(favourite.id!);
      _loadFavourites(); // Refresh list
      _showSnackBar('Removed from favourites');
    } catch (e) {
      _showSnackBar('Failed to remove');
    }
  }

  Future<void> _clearAllFavourites() async {
    if (_favourites.isEmpty) {
      _showSnackBar('No favourites to clear');
      return;
    }

    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear All Favourites',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'This will permanently remove all items from your favourites. This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final fav in _favourites) {
          await _favouriteDB.deleteFavourite(fav.id!);
        }
        _loadFavourites();
        _showSnackBar('Cleared all favourites');
      } catch (e) {
        _showSnackBar('Failed to clear');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _navigateToWordDetail(String word) async {
    try {
      final results = await _dictionaryDB.searchWords(word);
      if (results.isNotEmpty && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetails(
              word: results.first.word,
              noun: results.first.noun,
              plural: results.first.plural,
              description: results.first.description,
              phrase: results.first.phrase,
              verb: results.first.verb,
              t_verb: results.first.t_verb,
              i_verb: results.first.i_verb,
              adjective: results.first.adjective,
              adverb: results.first.adverb,
              preposition: results.first.preposition,
              synonym: results.first.synonym,
              antonym: results.first.antonym,
              conjunction: results.first.conjunction,
            ),
          ),
        );
      } else {
        _showSnackBar('Word details not found');
      }
    } catch (e) {
      _showSnackBar('Error loading word');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        centerTitle: false,
        actions: [
          if (_favourites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Clear All',
              onPressed: _clearAllFavourites,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favourites.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favourites.length,
                  itemBuilder: (context, index) {
                    final favourite = _favourites[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildFavouriteItem(context, favourite),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favourites yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any word\nto add it to your favourites',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteItem(BuildContext context, Favourite favourite) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(favourite.id.toString()),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Remove from favourites?',
              style: theme.textTheme.titleMedium,
            ),
            content: Text(
              'This will remove "${favourite.word}" from your favourites.',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Remove',
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => _deleteFavourite(favourite),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? theme.dividerColor.withOpacity(0.2)
                : theme.dividerColor.withOpacity(0.15),
            width: 1.0,
          ),
          color: theme.cardColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToWordDetail(favourite.word),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(isDark ? 0.15 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(isDark ? 0.3 : 0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: theme.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favourite.word,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to view details',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    onPressed: () => _navigateToWordDetail(favourite.word),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 20,
                    ),
                    onPressed: () => _deleteFavourite(favourite),
                    tooltip: 'Remove',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
