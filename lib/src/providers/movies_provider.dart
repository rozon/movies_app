import 'package:movies_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesProvider {
  String _apiVersion = '3';
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'en-US';

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, "$_apiVersion/movie/now_playing", {
      "api_key": _apiKey,
      "language": _language,
    });

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
}
