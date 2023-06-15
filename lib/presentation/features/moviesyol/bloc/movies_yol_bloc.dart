import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/movies_repository_impl.dart';
import '../../../../domain/models/movies_yol_model.dart';
import '../../../../domain/usecase/fetch_yol_latest_movies_use_case.dart';
import '../../../../domain/usecase/fetch_yol_popular_movies_use_case.dart';
import '../../../../domain/usecase/fetch_yol_top_rated_movies_use_case.dart';
import '../../../../domain/usecase/fetch_yol_upcoming_movies_use_case.dart';
import '../../../../networking/network_movie_config.dart';

part 'movies_yol_event.dart';

part 'movies_yol_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final FetchLatestMoviesUseCase fetchLatestMoviesUseCase;
  final FetchPopularMoviesUseCase fetchPopularMoviesUseCase;
  final FetchTopRatedMoviesUseCase fetchTopRatedMoviesUseCase;
  final FetchUpcomingMoviesUseCase fetchUpcomingMoviesUseCase;
  Timer? _timer;

  MoviesBloc(
    this.fetchLatestMoviesUseCase,
    this.fetchPopularMoviesUseCase,
    this.fetchTopRatedMoviesUseCase,
    this.fetchUpcomingMoviesUseCase,
  ) : super(const MoviesListState()) {
    on<InitEvent>((event, emit) => _init(emit));
    on<TopRatedEvent>((event, emit) => _getTopRatedMovies(emit));
    on<UpcomingEvent>((event, emit) => _getUpcomingMovies(emit));
    on<LatestEvent>((event, emit) => _onLatestMovies(emit));
  }

  Future<void> _init(Emitter<MoviesState> emit) async {
    try {
      //final latest = await _getLatestMovies();
      //final popular = await _getPopularMovies();

      //Future wait will wait for both calls to complete
      //Alternative option can be to use async library for future groups
      var response = await Future.wait([
        _getLatestMovies(),
        _getPopularMovies(),
      ]);
      var imageUrl = "";
      if (response[1].isNotEmpty && response[1].first.posterPath != null) {
        imageUrl =
            NetworkConfig.imageBaseUrl + (response[1].first.posterPath ?? "");
      }
      _initTimer();
      emit(MoviesListState(
        headerImage: imageUrl,
        latestMovies: response[0],
        popularMovies: response[1],
      ));
    } on NetworkErrorException {
      //Catching thrown exception and throwing as movie error state
      //if (state is! MoviesErrorState) {
        emit(MoviesErrorState());
      //}
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (t) => add(LatestEvent()),
    );
  }

  Future<void> _onLatestMovies(Emitter<MoviesState> emit) async {
    try {
      final latest = await _getLatestMovies();
      emit((state as MoviesListState).copyWith(latestMovies: latest));
    } on Exception {
      //Catching thrown exception and throwing as movie error state
      //if (state is! MoviesErrorState) {
        emit(MoviesErrorState());
      //}
    }
  }

  Future<List<MoviesResultModel>> _getLatestMovies() async {
    try {
      return await fetchLatestMoviesUseCase();
    } catch (_) {
      print("Exception : Latest Movies Exception");
      emit(MoviesErrorState());
      return [];
    }
  }

  Future<List<MoviesResultModel>> _getPopularMovies() async {
    try {
      return await fetchPopularMoviesUseCase();
    } catch (_) {
      return [];
    }
  }

  Future<void> _getTopRatedMovies(Emitter<MoviesState> emit) async {
    try {
      final topRated = await fetchTopRatedMoviesUseCase();
      emit((state as MoviesListState).copyWith(topRatedMovies: topRated));
    } on Exception {
      if (state is! MoviesErrorState) {
      //Catching thrown exception and throwing as movie error state
      emit(MoviesErrorState());
      }
    }
  }

  Future<void> _getUpcomingMovies(Emitter<MoviesState> emit) async {
    try {
      final upcoming = await fetchUpcomingMoviesUseCase();
      emit((state as MoviesListState).copyWith(upcomingMovies: upcoming));
    } on Exception {
      if (state is! MoviesErrorState) {
      //Catching thrown exception and throwing as movie error state
      emit(MoviesErrorState());
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
