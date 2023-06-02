

import '../models/movies_yol_model.dart';
import '../repository/movies_yol_repository.dart';

class FetchLatestMoviesUseCase {
  final MoviesRepository moviesRepository;

  const FetchLatestMoviesUseCase(this.moviesRepository);

  Future<List<MoviesResultModel>> call() async => moviesRepository.getLatestMovies();
}
