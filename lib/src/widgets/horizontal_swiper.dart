import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie_model.dart';

class HorizontalSwiper extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;
  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  HorizontalSwiper({@required this.movies, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return _card(context, movies[index]);
        },
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}_smallCard';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 160.0,
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.getPosterPath()),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            movie.title,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.of(context).pushNamed('detail', arguments: movie);
      },
    );
  }
}
