import 'package:flutter_movie_app/data/model/genre.dart';

class GenreResponse {
  final List<Genre> genres;
  final String error;

  GenreResponse({
    this.genres,
    this.error,
  });

  GenreResponse.fromJson(Map<String, dynamic> json)
      : genres = (json["genres"] as List)
            .map((i) => new Genre.fromJson(i))
            .toList(),
        error = "";

  GenreResponse.withError(String errorValue)
      : genres = List(),
        error = errorValue;
}
