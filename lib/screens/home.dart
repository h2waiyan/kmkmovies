import 'package:flutter/material.dart';
import 'package:moviesdb/api/api.dart';
import 'package:moviesdb/model/movies.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMovies();
  }

  List<Result> popularMovies = [];
  List<Result> upcomingMovies = [];

  getMovies() {
    API myapi = API();
    // popularMovies = await myapi.getMovies('popular');
    myapi.getMovies('popular').then((value) {
      setState(() {
        popularMovies = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(popularMovies[index].title!),
          );
        },
      )),
    );
  }
}
