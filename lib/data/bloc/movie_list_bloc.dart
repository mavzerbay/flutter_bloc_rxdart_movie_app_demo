import 'package:flutter_movie_app/data/repository/movie_repository.dart';
import 'package:flutter_movie_app/data/response_model/movie_response.dart';
import 'package:rxdart/rxdart.dart';

class MovieListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getMovies() async {
    MovieResponse response = await _repository.getMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesBloc = MovieListBloc();
