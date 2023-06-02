

import '../domain/models/movies_yol_model.dart';
import '../domain/repository/movies_yol_repository.dart';
import '../networking/dio_movie_client.dart';
import 'config.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final DioClient dioClient;
  final String? key;

  const MoviesRepositoryImpl({required this.dioClient, this.key});

  @override
  Future<List<MoviesResultModel>> getLatestMovies() async => await _getMovies(DataConfig.latestMovies);

  @override
  Future<List<MoviesResultModel>> getPopularMovies() async => await _getMovies(DataConfig.popularMovies);

  @override
  Future<List<MoviesResultModel>> getTopRatedMovies() async => await _getMovies(DataConfig.topRatedMovies);

  @override
  Future<List<MoviesResultModel>> getUpcomingMovies() async => await _getMovies(DataConfig.upComingMovies);

  Future<List<MoviesResultModel>> _getMovies(String path) async {
    try {
      final response = await dioClient.dio.get(path, queryParameters: _getQueryParameters());

      if (response.statusCode != 200) {
        throw Exception();
      }

      final bodyJson = response.data as Map<String, dynamic>;
      final result = MoviesModel.fromJson(bodyJson).results;

      if (result == null) {
        throw Exception();
      }

      return result;
    } catch (e, st) {
      print("Exception : $e, $st");
      throw Exception();
    }
  }

  Map<String, dynamic> _getQueryParameters() {
    return {
      "api_key": key,
      "language": "en-US",
      "page": "1",
    };
  }
}
