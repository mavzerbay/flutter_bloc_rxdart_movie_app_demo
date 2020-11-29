import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constants/style/colors.dart' as StyleColor;
import 'package:flutter_movie_app/data/bloc/person_list_bloc.dart';
import 'package:flutter_movie_app/data/model/person.dart';
import 'package:flutter_movie_app/data/response_model/person_response.dart';
import 'package:flutter_movie_app/widgets/general_widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonList extends StatefulWidget {
  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  @override
  void initState() {
    super.initState();
    personListBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "Bu Hafta Trend Olan Kişiler",
            style: TextStyle(
              color: StyleColor.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<PersonResponse>(
          stream: personListBloc.subject.stream,
          builder:
              (BuildContext context, AsyncSnapshot<PersonResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data.error.length > 0) {
                return ErrorWidget(snapshot.data.error);
              }
              return _buildPersonsWidget(snapshot.data);
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

  Widget _buildPersonsWidget(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 130,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        itemCount: persons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Container(
            width: 100,
            padding: EdgeInsets.only(top: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                persons[i].profileImg == null
                    ? Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: StyleColor.Colors.secondColor,
                        ),
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w200${persons[i].profileImg}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                Text(
                  persons[i].name,
                  maxLines: 2,
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "${persons[i].known} için trend",
                  style: TextStyle(
                    height: 1.4,
                    color: StyleColor.Colors.titleColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
