import 'package:flutter/material.dart';

import '../databases/dictionary_db.dart';
import '../databases/history_db.dart';
import '../model/dic_model.dart';
import '../model/his_model.dart';
import '../pages/word_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DatabaseHistory dbHistory;
  late DatabaseHelper dbHelper;
  List<History> words = [];
  bool _isDeletingAll = false;

  @override
  void initState() {
    super.initState();
    dbHistory = DatabaseHistory.instance;
    dbHelper = DatabaseHelper.instance;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final result = await dbHistory.queryAll();
    setState(() => words = result.reversed.toList()); // Newest first
  }

  Future<void> _deleteItem(int id) async {
    await dbHistory.delete(id);
    _loadHistory();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted from history'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteAllItems() async {
    setState(() => _isDeletingAll = true);
    for (final item in words) {
      await dbHistory.delete(item.id!);
    }
    setState(() {
      words = [];
      _isDeletingAll = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History cleared'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        actions: [
          if (words.isNotEmpty)
            IconButton(
              icon: _isDeletingAll
                  ? const CircularProgressIndicator(color: Colors.redAccent)
                  : const Icon(Icons.delete),
              onPressed: _isDeletingAll ? null : _confirmClearAll,
              tooltip: 'Clear all history',
            ),
        ],
      ),
      body: words.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: words.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _buildHistoryItem(words[index]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search words to see them here',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(History item) {
    return Dismissible(
      key: Key(item.id.toString()),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              "Confirm Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
            content: const Text("Remove this word from history?"),
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
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => _deleteItem(item.id!),
      child: InkWell(
        borderRadius: BorderRadius.circular(2),
        onTap: () => _navigateToWordDetails(item.word),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.word,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.grey,
                onPressed: () => _navigateToWordDetails(item.word),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToWordDetails(String word) async {
    final results = await dbHelper.searchWords(word);
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
    }
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Clear All History",
          style: TextStyle(color: Colors.redAccent),
        ),
        content: const Text(
            "This will permanently remove all items from your history."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteAllItems();
    }
  }
}
