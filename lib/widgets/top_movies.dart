import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/data/bloc/movie_list_bloc.dart';
import 'package:flutter_movie_app/data/model/movie.dart';
import 'package:flutter_movie_app/data/response_model/movie_response.dart';
import 'package:flutter_movie_app/screens/detail_screen.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "EN YÜKSEK PUANLI FİLMLER",
            style: TextStyle(
              color: StyleColor.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<MovieResponse>(
          stream: moviesBloc.subject.stream,
          builder:
              (BuildContext context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data.error.length > 0) {
                return ErrorWidget(snapshot.data.error);
              }
              return _buildMoviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            } else {
              return LoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    if (movies.length == 0) {
      return Container(
        child: Text("Film Yok"),
      );
    } else
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movies[i]),
                    ));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    movies[i].poster == null
                        ? Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              color: StyleColor.Colors.secondColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  EvaIcons.filmOutline,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/${movies[i].poster}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(width: 10),
                    Container(
                        width: 100,
                        child: Text(
                          movies[i].title,
                          maxLines: 2,
                          style: TextStyle(
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          movies[i].rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        RatingBar.builder(
                          itemSize: 8,
                          initialRating: movies[i].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: StyleColor.Colors.secondColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
