
import '../models/movies_yol_model.dart';

abstract class MoviesRepository {
  Future<List<MoviesResultModel>> getLatestMovies();

  Future<List<MoviesResultModel>> getPopularMovies();

  Future<List<MoviesResultModel>> getTopRatedMovies();

  Future<List<MoviesResultModel>> getUpcomingMovies();
}
