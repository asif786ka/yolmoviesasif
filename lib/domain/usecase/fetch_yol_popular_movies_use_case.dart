import '../models/movies_yol_model.dart';
import '../repository/movies_yol_repository.dart';

class FetchPopularMoviesUseCase {
  final MoviesRepository moviesRepository;

  const FetchPopularMoviesUseCase(this.moviesRepository);

  Future<List<MoviesResultModel>> call() async => moviesRepository.getPopularMovies();
}
