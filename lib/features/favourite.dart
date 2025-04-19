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

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Favourites"),
        content: const Text("This cannot be undone"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
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
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Favourites'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear All',
            onPressed: _clearAllFavourites,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favourites.isEmpty
              ? const Center(child: Text('No favourites yet'))
              : ListView.builder(
                  itemCount: _favourites.length,
                  itemBuilder: (context, index) {
                    final favourite = _favourites[index];
                    return Dismissible(
                      key: Key(favourite.id.toString()),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteFavourite(favourite),
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm",
                                style: TextStyle(color: Colors.red)),
                            content: const Text("Remove from favourites?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Remove",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(favourite.word),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _deleteFavourite(favourite),
                        ),
                        onTap: () => _navigateToWordDetail(favourite.word),
                      ),
                    );
                  },
                ),
    );
  }
}
