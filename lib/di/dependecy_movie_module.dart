import 'package:get_it/get_it.dart';

import '../data/movies_repository_impl.dart';
import '../domain/repository/movies_yol_repository.dart';
import '../domain/usecase/fetch_yol_latest_movies_use_case.dart';
import '../domain/usecase/fetch_yol_popular_movies_use_case.dart';
import '../domain/usecase/fetch_yol_top_rated_movies_use_case.dart';
import '../domain/usecase/fetch_yol_upcoming_movies_use_case.dart';
import '../networking/dio_movie_client.dart';
import '../networking/network_movie_config.dart';

final getIt = GetIt.instance;

class DependencyModule {
  void setup() {
    getIt.registerSingleton<DioClient>(
      const DioClient(apiBaseUrl: NetworkConfig.baseUrl),
    );
    getIt.registerSingleton<MoviesRepository>(
      MoviesRepositoryImpl(dioClient: getIt(), key: "9dc4772f29bc8ea6815d08313e064148"),
    );
    getIt.registerSingleton(FetchLatestMoviesUseCase(getIt()));
    getIt.registerSingleton(FetchPopularMoviesUseCase(getIt()));
    getIt.registerSingleton(FetchTopRatedMoviesUseCase(getIt()));
    getIt.registerSingleton(FetchUpcomingMoviesUseCase(getIt()));
  }
}
