import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/models/actor_model.dart';

class MoviesProvider {
  String _apiVersion = '3';
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'en-US';

  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _populars = List();

  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> processResponse(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      final Movies movies = Movies.fromJsonList(parsedResponse['results']);
      return movies.items;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, "$_apiVersion/movie/now_playing", {
      "api_key": _apiKey,
      "language": _language,
    });
    return await processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];
    _loading = true;

    _popularsPage++;
    final url = Uri.https(_url, "$_apiVersion/movie/popular", {
      "api_key": _apiKey,
      "language": _language,
      "page": _popularsPage.toString()
    });

    final response = await processResponse(url);

    _populars.addAll(response);
    popularsSink(_populars);

    _loading = false;
    return response;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, "$_apiVersion/movie/$movieId/credits", {
      "api_key": _apiKey,
      "language": _language,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      final Cast cast = Cast.fromJsonList(parsedResponse['cast']);
      return cast.items;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_url, "$_apiVersion/search/movie", {
      "api_key": _apiKey,
      "language": _language,
      "query": query,
    });
    return await processResponse(url);
  }
}
