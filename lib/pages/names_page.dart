import 'package:flutter/material.dart';

class NamesPage extends StatefulWidget {
  const NamesPage({Key? key}) : super(key: key);

  @override
  State<NamesPage> createState() => _NamesPageState();
}

class _NamesPageState extends State<NamesPage> {
  final List<Map<String, dynamic>> names = [
    {
      'id': 1,
      'name': 'Pumulo',
      'mean': '-verb. to diminish in intensity \n -verb. to jump \n -noun. A tree'
    },
    {
      'id': 2,
      'name': 'Mufalali',
      'mean': 'adj. diverging from the standard type'
    },
    {'id': 3, 'name': 'Abjure', 'mean': 'v. to reject or renounce'},
    {
      'id': 4,
      'name': 'Muyunda',
      'mean': 'v. to leave secretly, evading detection'
    },
    {
      'id': 5,
      'name': 'Mubiana',
      'mean': 'v. to voluntarily refrain from doing something'
    },
    {'id': 6, 'name': 'Mukongolwa', 'mean': 'n. keen judgment and perception'},
    {'id': 7, 'name': 'Admonish', 'mean': 'v. scold or to advise firmly'},
    {
      'id': 8,
      'name': 'Nasilele',
      'mean':
      'v. to contaminate or make impure by introducing inferior elements'
    },
    {
      'id': 9,
      'name': 'Namushi',
      'mean': 'v. to recommend, support, or advise'
    },
    {
      'id': 10,
      'name': 'Wakunuma',
      'mean': 'adj. concerned with the nature of beauty and art'
    },
    {
      'id': 11,
      'name': 'Kakula',
      'mean':
      'n. fake or artificial behavior, often meant to impress or conceal the truth'
    },
    {
      'id': 12,
      'name': 'Wamundila',
      'mean': 'v. enlarge or increase, esp. wealth, power, reputation'
    },
    {'id': 13, 'name': 'Muyangana', 'mean': 'n. promptness and eagerness'},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lozi names'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Card(
              color: Colors.teal,
              child: ListTile(
                title: Text(names[index]['name']),
                subtitle: Text(names[index]['mean']),
              ),
            ),
          );
        },
      ),
    );
  }
}