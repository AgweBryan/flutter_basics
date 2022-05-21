import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter App",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions =
      <WordPair>[]; // same as: final List<WordPair> _suggestions = [];

  final _saved = <WordPair>{}; // same as: final Set<WordPair> _saved = {};

  final _biggerFont = TextStyle(fontSize: 18);

  void _savedWordPairs() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: _saved.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No saved words",
                    style: _biggerFont,
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: _saved
                      .map(
                        (word) => ListTile(
                          title: Text(
                            word.asPascalCase,
                            style: _biggerFont,
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final word = WordPair.random().asPascalCase;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Random Words Generator',
          ),
          actions: [
            IconButton(
              onPressed: _savedWordPairs,
              icon: Icon(Icons.list),
            ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2; // return an interger result
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }

            final alreadySaved = _saved.contains(_suggestions[index]);

            return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'save',
              ),
              onTap: () => setState(() {
                alreadySaved
                    ? _saved.remove(_suggestions[index])
                    : _saved.add(_suggestions[index]);
              }),
            );
          },
        ));
  }
}
