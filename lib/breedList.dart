import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'imagePage.dart';


const allDogs = "https://dog.ceo/api/breeds/list/all";
const httpHeaders = const {
  'User-Agent': 'BeHappy (https://github.com/cillianm/be-happy)',
  'Accept': 'application/json',
};

const textStyle = const TextStyle(
    fontFamily: 'Patrick Hand',
    fontSize: 34.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal);

class BreedList extends StatefulWidget {
  BreedList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<BreedList> {
  Future<String> response;
  List<String> returnedBreedList;
  String displayedImage = '';
  String breed = '';
  Map<String,String> breedLinks;

  @override
  initState() {
    super.initState();
    refreshAction();
  }

  refreshAction() {
    setState(() {
      response = http.read(allDogs, headers: httpHeaders);
    });
  }

  aboutAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('About Be Happy'),
              content: Text(
                  'Be Happy is brought to you by Cillian, \n\nDog Images come from '
                  'https://dog.ceo/dog-api with thanks.'));
        });
  }

  shareAction() {
    if (displayedImage.isNotEmpty) {
      share(displayedImage);
    }
  }

  FutureBuilder<String> imageBody() {
    return FutureBuilder<String>(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const ListTile(
              leading: Icon(Icons.sync_problem),
              title: Text('No connection'),
            );
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return const Center(
                child: ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Network error'),
                  subtitle: Text(
                      'Sorry - the dogs have gone missing.\n Check your '
                      'network connection and try again.'),
                ),
              );
            } else {
              Map breedMap = json.decode(snapshot.data);
              var breedList = new JsonList.fromJson(breedMap);
              if (breedList.status == 'success') {
                data = breedList.breeds;
                breedLinks = breedList.links;
                var status = breedList.status;
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Dismissible(
                      key: const Key("dog"),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        refreshAction();
                      },
                      child: new ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                              child: new Card(
                                elevation: 5.0,
                                child: new Container(
                                  alignment: Alignment.center,
                                  child: new EntryItem(data[index]),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(builder: (context) => new ImagePage(breedLinks[data[index].toString()], title: 'Be Happy')),
                                );
                              },
                            );
                          }
                      ),

                    ));
              } else {
                return ListTile(
                  leading: const Icon(Icons.sync_problem),
                  title: Text('Unexpected error: ${snapshot.data}'),
                );
              }
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About Be Happy',
            onPressed: aboutAction,
          )
        ],
      ),
      body: imageBody()
        ,
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.children);

  final String title;
  final List<Entry> children;
  @override
  String toString() {
    // TODO: implement toString
    return title;
  }
}

class JsonList {
  dynamic status;
  List<Entry> breeds;
  Map<String,String> links;

  JsonList(this.status,this.breeds);

  JsonList.fromJson(Map<String, dynamic> json){
    breeds = [];
    status = json["status"];
    Map map = json["message"];
    links = new Map();
    breeds.add(new Entry("Random Breed", []));
    links["Random Breed"] = "random";
    for(String key in map.keys){
      var currentEntry = new Entry(key,[]);
      List currentBreed = map[key];
      if(currentBreed.length > 0) {
        for (String nestedKey in currentBreed) {
          links[nestedKey + " " + key] = key + "/" + nestedKey;
          breeds.add(new Entry(nestedKey + " " + key, []));
        }
      }else {
        breeds.add(currentEntry);
        links[key] = key;
      }
    }
    breeds = breeds;
  }
}

// The entire multilevel list displayed by this app.
List<Entry> data = null;

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return new ListTile(title: new Text(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}