import 'package:flutter/material.dart';

import '../../../../domain/models/movies_yol_model.dart';
import '../../../../networking/network_movie_config.dart';
import '../../../../utils/dimes.dart';
import 'movie_item_card.dart';


class MainExpansionSection extends StatelessWidget {
  final String title;
  final bool initiallyExpanded;
  final List<MoviesResultModel> movies;
  final VoidCallback? callback;

  const MainExpansionSection({
    Key? key,
    required this.title,
    this.initiallyExpanded = false,
    required this.movies,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacing8),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radius8),
          child: ExpansionTile(
            title: Text(title),
            maintainState: true,
            backgroundColor: Colors.white,
            initiallyExpanded: initiallyExpanded,
            collapsedBackgroundColor: Colors.white,
            onExpansionChanged: (expanding) => {
              if (callback != null) {callback!()}
            },
            children: [
              SizedBox(
                height: 178.0,
                child: movies.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => MainCard(
                          key: ValueKey(movies[index].id!),
                          id: movies[index].id!,
                          url: "${NetworkConfig.imageBaseUrl}${movies[index].posterPath}",
                          title: movies[index].title!,
                          isFirst: index == 0,
                          isLast: index == movies.length - 1,
                        ),
                        itemCount: movies.length,
                      ),
              ),
              // To have the horizontal scrollbar overscroll glow on Android properly aligned
              const SizedBox(height: Dimens.spacing16)
            ],
          ),
        ),
      ),
    );
  }
}
