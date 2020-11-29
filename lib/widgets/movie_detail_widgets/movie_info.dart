import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/bloc/movie_detail_bloc.dart';
import 'package:flutter_movie_app/data/model/movie_detail.dart';
import 'package:flutter_movie_app/data/response_model/movie_detail_response.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;

class MovieInfo extends StatefulWidget {
  final int id;
  const MovieInfo({
    Key key,
    this.id,
  }) : super(key: key);
  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);

  @override
  void initState() {
    super.initState();
    movieDetailBloc..getMovieDetail(id);
  }

  @override
  void dispose() {
    super.dispose();
    movieDetailBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder:
          (BuildContext context, AsyncSnapshot<MovieDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorWidget(snapshot.data.error);
          }
          return _buildInfoWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget _buildInfoWidget(MovieDetailResponse data) {
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BÜTÇE",
                    style: TextStyle(
                        color: StyleColor.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Text(
                    detail.budget.toString() + "\$",
                    style: TextStyle(
                      color: StyleColor.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FİLM SÜRESİ",
                    style: TextStyle(
                        color: StyleColor.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Text(
                    detail.runtime.toString() + "dk",
                    style: TextStyle(
                      color: StyleColor.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YAYIN TARİHİ",
                    style: TextStyle(
                        color: StyleColor.Colors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Text(
                    detail.releaseDate.toString(),
                    style: TextStyle(
                      color: StyleColor.Colors.secondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left:10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "KATEGORİLER",
                style: TextStyle(
                  color: StyleColor.Colors.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                padding: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.genres.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Text(
                          detail.genres[i].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
