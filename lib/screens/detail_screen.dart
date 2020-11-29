import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/data/bloc/movie_videos_bloc.dart';

import 'package:flutter_movie_app/data/model/movie.dart';
import 'package:flutter_movie_app/data/model/video.dart';
import 'package:flutter_movie_app/data/response_model/video_response.dart';
import 'package:flutter_movie_app/screens/video_player_screen.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';
import 'package:flutter_movie_app/widgets/movie_detail_widgets/casts.dart';
import 'package:flutter_movie_app/widgets/movie_detail_widgets/movie_info.dart';
import 'package:flutter_movie_app/widgets/movie_detail_widgets/similar_movies.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({
    Key key,
    this.movie,
  }) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideosBloc..getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleColor.Colors.mainColor,
      body: Builder(
        builder: (context) {
          return SliverFab(
            floatingPosition: FloatingPosition(right: 20),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideosBloc.subject.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<VideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return ErrorWidget(snapshot.data.error);
                  }
                  return _buildVideoVidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error);
                } else {
                  return LoadingWidget();
                }
              },
            ),
            expandedHeight: 200,
            slivers: [
              SliverAppBar(
                backgroundColor: StyleColor.Colors.mainColor,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title.length > 40
                        ? movie.title.substring(0, 37) + "..."
                        : movie.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/${movie.backPoster}"),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0),
                              ])),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              movie.rating.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            RatingBar.builder(
                              itemSize: 10,
                              initialRating: movie.rating / 2,
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          "GENEL BAKIŞ",
                          style: TextStyle(
                            color: StyleColor.Colors.titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          movie.overview,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12, height: 1.5),
                        ),
                      ),
                      SizedBox(height: 10),
                      MovieInfo(id: movie.id),
                      Casts(id: movie.id),
                      SimilarMovies(id: movie.id),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideoVidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return videos.length > 0
        ? FloatingActionButton(
            backgroundColor: StyleColor.Colors.secondColor,
            child: Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    controller: YoutubePlayerController(
                      initialVideoId: videos[0].key,
                      flags: YoutubePlayerFlags(autoPlay: true, forceHD: true),
                    ),
                  ),
                ),
              );
            },
          )
        : FloatingActionButton(
            backgroundColor: StyleColor.Colors.secondColor,
            child: Icon(Icons.play_disabled),
            onPressed: () {},
          );
  }
}
