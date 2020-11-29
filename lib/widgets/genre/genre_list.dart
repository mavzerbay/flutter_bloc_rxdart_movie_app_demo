import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/data/bloc/movie_list_by_genre_bloc.dart';

import 'package:flutter_movie_app/data/model/genre.dart';
import 'package:flutter_movie_app/widgets/genre/genre_movies.dart';

class GenreList extends StatefulWidget {
  final List<Genre> genres;
  const GenreList({
    Key key,
    this.genres,
  }) : super(key: key);
  @override
  _GenreListState createState() => _GenreListState(genres);
}

class _GenreListState extends State<GenreList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;

  TabController _tabController;

  _GenreListState(this.genres);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging){
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: StyleColor.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              backgroundColor: StyleColor.Colors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: StyleColor.Colors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor: StyleColor.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((genre) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((genre) {
              return GenreMovies(genreId: genre.id);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
