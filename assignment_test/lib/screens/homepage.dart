import 'dart:async';

import 'package:assignment_test/data/album.dart';
import 'package:assignment_test/screens/detail.dart';
import 'package:assignment_test/services/http.dart';
import 'package:assignment_test/widgets/gridcell.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  final String title = "Home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamController<int> streamController = new StreamController<int>();

gridview(AsyncSnapshot<List<Album>> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data.map(
          (album) {
            return GestureDetector(
              child: GridTile(
                child: AlbumCell(album),
              ),
              onTap: () {
                goToDetailsPage(context, album);
              },
            );
          },
        ).toList(),
      ),
    );
  }


   goToDetailsPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => GridDetails(
              curAlbum: album,
            ),
      ),
    );
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
          title: StreamBuilder(
        initialData: 0,
        stream: streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text('${widget.title} ${snapshot.data}');
        },
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<Album>>(
              future: HttpApi.getPortraitPhotos(),
              builder: (context, snapshot) {
                // not setstate here
                //
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                //
                if (snapshot.hasData) {
                  streamController.sink.add(snapshot.data.length);
                  // gridview
                  return gridview(snapshot);
                }

                return circularProgress();
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose(){
    streamController.close();
    super.dispose();
  }
}