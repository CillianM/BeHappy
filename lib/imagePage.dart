import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

const dogApi = "https://dog.ceo/api/breeds/image/random";
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

class ImagePage extends StatefulWidget {
  ImagePage(this.breed, {Key key, this.title}) : super(key: key);

  final String title;
  final String breed;

  @override
  MainPageState createState() => MainPageState(breed);
}

class MainPageState extends State<ImagePage> {
  MainPageState(this.breed);
  Future<String> response;
  Future<LinkedHashMap<String, List<String>>> returnedBreedList;
  String displayedImage = '';
  String breed = '';

  @override
  initState() {
    super.initState();
    refreshAction();
  }

  refreshAction() {
    setState(() {
      if(breed != "random") {
        response = http.read(
            "https://dog.ceo/api/breed/" + breed + "/images/random",
            headers: httpHeaders);
      } else{
        response = http.read(
            "https://dog.ceo/api/breeds/image/random",
            headers: httpHeaders);
      }
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

  Future<LinkedHashMap<String, List<String>>> getBreeds() async{
    final response = await http.get(allDogs);
    final responseJson = json.decode(response.body); 
    if (responseJson['status'] == 'success') {
      final breedList = responseJson['message'] as List<List<String>>;
      final test = breedList;
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
              final decoded = json.decode(snapshot.data);
              if (decoded['status'] == 'success') {
                displayedImage = decoded['message'];
                return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Dismissible(
                      key: const Key("dog"),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        refreshAction();
                      },
                      child: new Image.network(displayedImage),
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
          ),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share Dog',
            onPressed: shareAction,
          )
        ],
      ),
      body: Center(
        child: imageBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshAction,
        tooltip: 'New Image',
        child: Icon(Icons.refresh),
      ),
    );
  }
}