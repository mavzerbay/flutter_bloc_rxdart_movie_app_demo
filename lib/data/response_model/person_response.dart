import 'package:flutter_movie_app/data/model/person.dart';

class PersonResponse {
  final List<Person> persons;
  final String error;

  PersonResponse({
    this.persons,
    this.error,
  });

  PersonResponse.fromJson(Map<String, dynamic> json)
      : persons = (json["results"] as List)
            .map((i) => new Person.fromJson(i))
            .toList(),
        error = "";

  PersonResponse.withError(String errorValue)
      : persons = List(),
        error = errorValue;
}
