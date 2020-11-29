import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/bloc/genre_list_bloc.dart';
import 'package:flutter_movie_app/data/model/genre.dart';
import 'package:flutter_movie_app/data/response_model/genre_response.dart';
import 'package:flutter_movie_app/widgets/genre/genre_list.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';

class GenreScreen extends StatefulWidget {
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    genresBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<GenreResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data.error.length > 0) {
            return ErrorWidget(snapshot.data.error);
          }
          return _buildGenreWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget _buildGenreWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        child: Text("Tür Yok"),
      );
    } else
      return GenreList(genres: genres);
  }
}
