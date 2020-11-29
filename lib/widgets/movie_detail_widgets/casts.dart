import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/bloc/casts_bloc.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/data/model/cast.dart';
import 'package:flutter_movie_app/data/response_model/cast_response.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Casts extends StatefulWidget {
  final int id;
  const Casts({
    Key key,
    this.id,
  }) : super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);

  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    castsBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "OYUNCULAR",
            style: TextStyle(
              color: StyleColor.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder:
              (BuildContext context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorWidget(snapshot.data.error);
              }
              return _buildCastsWidget(snapshot.data);
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

  Widget _buildCastsWidget(CastResponse data) {
    List<Cast> casts = data.casts;
    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder: (context, i) {
          return Container(
            padding: EdgeInsets.only(top: 10, right: 8),
            width: 100,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  casts[i].img != null
                      ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w300${casts[i].img}"),
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: StyleColor.Colors.mainColor,
                          ),
                          child: Icon(FontAwesomeIcons.userAlt,
                              color: Colors.white),
                        ),
                  SizedBox(height: 10),
                  Text(
                    casts[i].name,
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.4,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    casts[i].character,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: StyleColor.Colors.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 7,
                    ),
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
