import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/details/bloc/details_bloc.dart';
import 'package:go_router_test/details/models/models.dart';

enum MediaType {
  movie,
  tvShow,
  tvSeason,
  tvEpisode,
  book,
  game,
  podcastShow,
  podcastEpisode,
}

// TODO? add redirect directly in constructors if parameters are non existent or empty.

class DetailsPage extends StatelessWidget {
  const DetailsPage._({
    super.key,
    required this.mediaType,
    required this.request,
  });

  factory DetailsPage.movieFromGoRouter({
    String? movieId,
  }) {
    return DetailsPage._(
      mediaType: MediaType.movie,
      request: MovieDetailsRequest(
        movieId: movieId ?? '',
        // TODO: add idType and add an option for imdbId (do this for tv as well).
      ),
    );
  }

  factory DetailsPage.tvShowFromGoRouter({
    String? tvShowId,
  }) {
    return DetailsPage._(
      mediaType: MediaType.tvShow,
      request: TvShowDetailsRequest(tvShowId: tvShowId ?? ''),
    );
  }

  factory DetailsPage.tvSeasonFromGoRouter({
    String? tvShowId,
    String? seasonNo,
  }) {
    return DetailsPage._(
      mediaType: MediaType.tvSeason,
      request: TvSeasonDetailsRequest(
        tvShowId: tvShowId ?? '',
        // TODO! potential error passing in null value and replacing with 0.
        seasonNo: int.tryParse(seasonNo!) ?? 0,
      ),
    );
  }

  factory DetailsPage.tvEpisodeFromGoRouter({
    String? tvShowId,
    String? seasonNo,
    String? episodeNo,
  }) {
    return DetailsPage._(
      mediaType: MediaType.tvEpisode,
      request: TvEpisodeDetailsRequest(
        tvShowId: tvShowId ?? '',
        // TODO! potential error passing in null value and replacing with 0.
        seasonNo: int.tryParse(seasonNo!) ?? 0,
        // TODO! potential error passing in null value and replacing with 0.
        episodeNo: int.tryParse(episodeNo!) ?? 0,
      ),
    );
  }

  factory DetailsPage.bookFromGoRouter({
    String? bookId,
    String? idType,
  }) {
    final bookIdType = BookIdType.values.firstWhere(
      (element) => element.queryParam == idType?.toLowerCase(),
      orElse: () => BookIdType.googleBooks,
    );
    return DetailsPage._(
      mediaType: MediaType.book,
      request: BookDetailsRequest(
        bookId: bookId ?? '',
        idType: bookIdType,
      ),
    );
  }

  factory DetailsPage.gameFromGoRouter({
    String? gameId,
  }) {
    return DetailsPage._(
      mediaType: MediaType.game,
      request: GameDetailsRequest(gameId: gameId ?? ''),
    );
  }

  factory DetailsPage.podcastShowFromGoRouter({
    String? podcastShowId,
    String? idType,
  }) {
    final podcastIdType = PodcastIdType.values.firstWhere(
      (element) => element.queryParam == idType?.toLowerCase(),
      orElse: () => PodcastIdType.podcastIndex,
    );
    return DetailsPage._(
      mediaType: MediaType.podcastShow,
      request: PodcastShowDetailsRequest(
        podcastId: podcastShowId ?? '',
        idType: podcastIdType,
      ),
    );
  }

  factory DetailsPage.podcastEpisodeFromGoRouter({
    String? podcastShowId,
    String? episodeId,
    String? idType,
  }) {
    final podcastIdType = PodcastIdType.values.firstWhere(
      (element) => element.queryParam == idType?.toLowerCase(),
      orElse: () => PodcastIdType.podcastIndex,
    );
    return DetailsPage._(
      mediaType: MediaType.podcastEpisode,
      request: PodcastEpisodeDetailsRequest(
        podcastId: podcastShowId ?? '',
        episodeId: episodeId ?? '',
        idType: podcastIdType,
      ),
    );
  }

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(DetailsPage.name);

  static const path = '/details';
  static const name = 'details';

  final MediaType mediaType;
  final BaseDetailsRequest request;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsBloc()
        ..add(DetailsRequested(mediaType: mediaType, request: request)),
      child: const DetailsView(),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey[300]!,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Details Page'),
            BlocBuilder<DetailsBloc, DetailsState>(
              builder: (context, state) => DetailsItem(
                mediaType: state.mediaType,
                item: state.details,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    super.key,
    required this.mediaType,
    required this.item,
  });

  final MediaType mediaType;
  final BaseDetailsData item;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[Text(mediaType.toString())];

    switch (mediaType) {
      case MediaType.movie:
        final details = item as MovieDetails;
        children.add(Text('movieId: ${details.movieId}'));
        break;
      case MediaType.tvShow:
        final details = item as TvShowDetails;
        children.add(Text('tvShowId: ${details.tvShowId}'));
        break;
      case MediaType.tvSeason:
        final details = item as TvSeasonDetails;
        children
          ..add(Text('tvShowId: ${details.tvShowId}'))
          ..add(Text('season no: ${details.seasonNo}'));
        break;
      case MediaType.tvEpisode:
        final details = item as TvEpisodeDetails;
        children
          ..add(Text('tvShowId: ${details.tvShowId}'))
          ..add(Text('season no: ${details.seasonNo}'))
          ..add(Text('episode no:${details.episodeNo}'));
        break;
      case MediaType.book:
        final details = item as BookDetails;
        children
          ..add(Text('bookId: ${details.bookId}'))
          ..add(Text('bookIdType: ${details.idType.name}'));
        break;
      case MediaType.game:
        final details = item as GameDetails;
        children.add(Text('gameId: ${details.gameId}'));
        break;
      case MediaType.podcastShow:
        final details = item as PodcastShowDetails;
        children
          ..add(Text('podcastShowId: ${details.podcastId}'))
          ..add(Text('podcastIdType: ${details.idType.name}'));
        break;
      case MediaType.podcastEpisode:
        final details = item as PodcastEpisodeDetails;
        children
          ..add(Text('podcastShowId: ${details.podcastId}'))
          ..add(Text('podcastEpisodeId:${details.episodeId}'))
          ..add(Text('podcastIdType: ${details.idType.name}'));
        break;
    }

    return Column(
      children: children
        ..add(
          OutlinedButton(
            onPressed: () => context.go('/details/podcast/1234'),
            child: const Text('Go to next detals apge'),
          ),
        ),
    );
  }
}
