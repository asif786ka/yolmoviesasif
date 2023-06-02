import '../models/movies_yol_model.dart';
import '../repository/movies_yol_repository.dart';

class FetchUpcomingMoviesUseCase {
  final MoviesRepository moviesRepository;

  const FetchUpcomingMoviesUseCase(this.moviesRepository);

  Future<List<MoviesResultModel>> call() async => moviesRepository.getUpcomingMovies();
}
