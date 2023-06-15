import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movies_yol_bloc.dart';
import 'header_movie_image.dart';
import 'movies_expansion_section.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoviesBloc>(context);
    return BlocBuilder(
        bloc: bloc,
        builder: (context, state) => state is MoviesListState ?
        Scaffold(
          backgroundColor: const Color(0x4949B356),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 500.0,
                backgroundColor: const Color(0x4949B356),
                flexibleSpace: FlexibleSpaceBar(
                  background: RepaintBoundary(
                    child: Center(
                      child: state.headerImage.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : HeaderImageView(imageUrl: state.headerImage),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    MainExpansionSection(
                      key: const ValueKey("latest"),
                      title: "Latest movies",
                      initiallyExpanded: true,
                      movies: state.latestMovies,
                      // callback: () => togglePeriodicFetch(),
                    ),
                    MainExpansionSection(
                      key: const ValueKey("popular"),
                      title: "Popular movies",
                      initiallyExpanded: true,
                      movies: state.popularMovies,
                    ),
                    MainExpansionSection(
                      key: const ValueKey("top"),
                      title: "Top Rated movies",
                      movies: state.topRatedMovies,
                      callback: () => bloc.add(TopRatedEvent()),
                    ),
                    MainExpansionSection(
                      key: const ValueKey("upcoming"),
                      title: "Upcoming movies",
                      movies: state.upcomingMovies,
                      callback: () => bloc.add(UpcomingEvent()),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom))
            ],
          ),
        ) : state is MoviesErrorState ? const Text("Movie Exception Error Handled", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),) : const Center(child: CircularProgressIndicator())
    );
  }
}