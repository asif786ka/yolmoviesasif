import '../models/movies_yol_model.dart';
import '../repository/movies_yol_repository.dart';

class FetchTopRatedMoviesUseCase {
  final MoviesRepository moviesRepository;

  const FetchTopRatedMoviesUseCase(this.moviesRepository);

  Future<List<MoviesResultModel>> call() async => moviesRepository.getTopRatedMovies();
}
