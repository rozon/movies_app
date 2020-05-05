import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';
import 'package:movies_app/src/providers/movies_provider.dart';

class MoviesSearch extends SearchDelegate {
  final moviesProvider = MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        final results = snapshot.data;
        if (snapshot.hasData) {
          return ListView(
            children: results.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(movie.getPosterPath()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.releaseDate),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
