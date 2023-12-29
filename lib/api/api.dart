import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:moviesdb/model/movies.dart';

class API {
  String baseUrl = 'https://api.themoviedb.org/3/movie/';
  String apiKey = '050c28541f900007285c3020069bfd62';

  Future<List<Result>> getMovies(type) async {
    var apiUrl = '$baseUrl$type?language=en-US&page=1&api_key=$apiKey';

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // var result = convert.jsonDecode(response.body);
      var movResp = Movie.fromRawJson(response.body);

      print(movResp.results);
      return movResp.results!;
    } else {
      throw Exception("Something went wrong.");
    }
  }
}
