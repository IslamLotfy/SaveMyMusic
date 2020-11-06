import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_animation_app/TextFab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong :(");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                buttonColor: Colors.purple,
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _addSong() {
    var artistController = TextEditingController();
    var songNameController = TextEditingController();
    var linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: artistController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'artist',
                            hintText: 'Amr Diab'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: songNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Song Name',
                            hintText: 'Zay Manty'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: linkController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'link',
                            hintText: 'https://youtube.com.....'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () {
                          var ref = FirebaseFirestore.instance
                              .collection("MyMusicList");
                          ref.add({
                            "artist": artistController.text,
                            "songName": songNameController.text,
                            "link": linkController.text
                          }).then((DocumentReference doc) {
                            String docId = doc.id;
                            Navigator.pop(this.context);
                          });
                        },
                        child: const Text("Add"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    print(snapshot['artist']);
    return GestureDetector(
      onTap: () => _launchYoutubeVideo(snapshot['link']),
      child: Card(
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  snapshot['artist'],
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(snapshot['songName'],
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(snapshot['link'])),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection("MyMusicList").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length);
        },
      ),
      floatingActionButton: TextFab(
          'Add Song',
          _addSong,
          Icons
              .add), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _launchYoutubeVideo(String _youtubeUrl) async {
    if (_youtubeUrl != null && _youtubeUrl.isNotEmpty) {
      if (await canLaunch(_youtubeUrl)) {
        final bool _nativeAppLaunchSucceeded = await launch(
          _youtubeUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        if (!_nativeAppLaunchSucceeded) {
          await launch(_youtubeUrl, forceSafariVC: true);
        }
      }
    }
  }
}
