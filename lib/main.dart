import 'package:examples_dialog/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SingleNotifier>(
        create: (_) => SingleNotifier(),
      ),
      ChangeNotifierProvider<MultipleNotifier>(
        create: (_) => MultipleNotifier([]),
      )
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dialog',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        body: Center(
            child: ListView(
                children: ListTile.divideTiles(context: context,tiles: [
          ListTile(
            title: Text('alert dialogue'),
            onTap: () =>_showMessageDialog(context),
          ),ListTile(
            title: Text('Single choice Dialog'),
            onTap: () =>_showSingleChoiceDialog(context),
          ),ListTile(
                    title: Text('Multiple choice Dialog'),
                    onTap: () => _showMultipleChoiceDialog(context),
                  ),ListTile(
                    title: Text('Textfield Dialog'),
                    onTap: () => _showAddNoteDialog(context),
                  )
        ]).toList())));
  }
}

_showMessageDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text("Well Done!"),
    content: Text("Your answer is correct!!!"),
    actions: <Widget>[
      FlatButton(
        child: Text("Yes"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  ),
);
_showSingleChoiceDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) {
    final _singleNotifier = Provider.of<SingleNotifier>(context);
    return AlertDialog(
      title: Text('Select one country'),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: countries
                .map((e) => RadioListTile(
              title: Text(e),
              value: e,
              groupValue: _singleNotifier.currentCountry,
              selected: _singleNotifier.currentCountry == e,
              onChanged: (value) {
                _singleNotifier.updateCountry(value);
                Navigator.of(context).pop();
              },
            ))
                .toList(),
          ),
        ),
      ),
    );
  },
);

_showMultipleChoiceDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      final _multipleNotifier = Provider.of<MultipleNotifier>(context);
      return AlertDialog(
        title: Text('Select one country or many countries'),
        content: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: countries
                    .map((e) => CheckboxListTile(
                  title: Text(e),
                  onChanged: (value) {
                    value
                        ? _multipleNotifier.addItem(e)
                        : _multipleNotifier.removeItem(e);
                  },
                  value: _multipleNotifier.isHaveItem(e),
                ))
                    .toList(),
              )),
        ),
        actions: [
          FlatButton(
            child: Text('Okay'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    });

_showAddNoteDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text("Add your note"),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Enter your note',
                    icon: Icon(Icons.note_add)),
              )
            ],
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Okay"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);

