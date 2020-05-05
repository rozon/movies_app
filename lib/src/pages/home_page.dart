import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/search/search_delegate.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/horizontal_swiper.dart';

class HomePage extends StatelessWidget {
  final movieProvider = MoviesProvider();
  @override
  Widget build(BuildContext context) {
    movieProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text("Movies in cinema"),
        backgroundColor: Colors.indigoAccent,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MoviesSearch());
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _cardSwiper(),
          _footer(context),
        ],
      ),
    );
  }

  Widget _cardSwiper() {
    return FutureBuilder(
      future: movieProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(movies: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child:
                  Text('Populars', style: Theme.of(context).textTheme.subhead)),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: movieProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return HorizontalSwiper(
                  movies: snapshot.data,
                  nextPage: movieProvider.getPopular,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
