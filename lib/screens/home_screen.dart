import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/widgets/genre/genres.dart';
import 'package:flutter_movie_app/widgets/now_playing.dart';
import 'package:flutter_movie_app/widgets/person_list.dart';
import 'package:flutter_movie_app/widgets/top_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleColor.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: StyleColor.Colors.mainColor,
        centerTitle: true,
        leading: Icon(EvaIcons.menu2Outline, color: Colors.white),
        title: Text("MavFilm"),
        actions: [
          IconButton(
            icon: Icon(EvaIcons.searchOutline, color: Colors.white),
            onPressed: null,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom:20),
        children: [
          NowPlaying(),
          GenreScreen(),
          PersonList(),
          TopMovies(),
        ],
      ),
    );
  }
}
