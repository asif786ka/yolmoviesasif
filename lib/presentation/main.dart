import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/dependecy_movie_module.dart';
import '../domain/usecase/fetch_yol_latest_movies_use_case.dart';
import '../domain/usecase/fetch_yol_popular_movies_use_case.dart';
import '../domain/usecase/fetch_yol_top_rated_movies_use_case.dart';
import '../domain/usecase/fetch_yol_upcoming_movies_use_case.dart';
import 'features/moviesyol/bloc/movies_yol_bloc.dart';
import 'features/moviesyol/view/movies_yol_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load(fileName: ".env");
  DependencyModule().setup();
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(
        primaryColor: const Color(0xFF41A721),
        primaryColorDark: const Color(0xFF1A422A),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: const MoviesView(),
    );
  }
}

class MoviesView extends StatelessWidget {
  const MoviesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesBloc(
        getIt<FetchLatestMoviesUseCase>(),
        getIt<FetchPopularMoviesUseCase>(),
        getIt<FetchTopRatedMoviesUseCase>(),
        getIt<FetchUpcomingMoviesUseCase>(),
      )..add(InitEvent()),
      child: const MoviesPage(),
    );
  }
}
