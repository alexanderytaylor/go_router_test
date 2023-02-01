import 'package:equatable/equatable.dart';

import 'details_request.dart';

/// {@template details_request}
/// Base Details Request.
/// {@endtemplate}
abstract class BaseDetailsData extends Equatable {
  /// {@macro details_request}
  const BaseDetailsData();
}

/// {@template movie_details_request}
/// Movie Details request.
///
/// Contains a [movieId].
/// {@endtemplate}
class MovieDetails extends BaseDetailsData {
  /// {@macro movie_details_request}
  const MovieDetails({required this.movieId});

  /// Movie ID
  final String movieId;

  @override
  List<Object?> get props => [movieId];
}

/// {@template tv_show_details_request}
/// TV Show Details request.
///
/// Contains a [tvShowId].
/// {@endtemplate}
class TvShowDetails extends BaseDetailsData {
  /// {@macro tv_show_details_request}
  const TvShowDetails({required this.tvShowId});

  /// TV Show ID
  final String tvShowId;

  @override
  List<Object?> get props => [tvShowId];
}

/// {@template tv_season_details_request}
/// TV Season Details request.
///
/// Contains a [tvShowId] and [seasonNo].
/// {@endtemplate}
class TvSeasonDetails extends BaseDetailsData {
  /// {@macro tv_season_details_request}
  const TvSeasonDetails({
    required this.tvShowId,
    required this.seasonNo,
  });

  /// TV Show ID
  final String tvShowId;

  /// Season Number
  final int seasonNo;

  @override
  List<Object?> get props => [tvShowId, seasonNo];
}

/// {@template tv_episode_details_request}
/// TV Episode Details request.
///
/// Contains a [tvShowId], [seasonNo] and [episodeNo].
/// {@endtemplate}
class TvEpisodeDetails extends BaseDetailsData {
  /// {@macro tv_episode_details_request}
  const TvEpisodeDetails({
    required this.tvShowId,
    required this.seasonNo,
    required this.episodeNo,
  });

  /// TV Show ID
  final String tvShowId;

  /// Season Number
  final int seasonNo;

  /// Episode Number
  final int episodeNo;

  @override
  List<Object?> get props => [tvShowId, seasonNo, episodeNo];
}

/// {@template book_details_request}
/// Book Details request.
///
/// Contains a [bookId] and an [idType].
///
/// [idType] defaults to [BookIdType.googleBooks].
/// {@endtemplate}
class BookDetails extends BaseDetailsData {
  /// {@macro book_details_request}
  const BookDetails({
    required this.bookId,
    this.idType = BookIdType.googleBooks,
  });

  /// Book ID.
  ///
  /// Can be a Google Books ID or an ISBN.
  final String bookId;

  /// {@macro book_id_type}
  ///
  /// Defaults to [BookIdType.googleBooks].
  final BookIdType idType;

  @override
  List<Object?> get props => [bookId, idType];
}

/// {@template game_details_request}
/// Gamae Details request.
///
/// Contains a [gameId].
/// {@endtemplate}
class GameDetails extends BaseDetailsData {
  /// {@macro game_details_request}
  const GameDetails({required this.gameId});

  /// Game ID
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

/// {@template podcast_show_details_request}
/// Podcast Show Details request.
///
/// Contains a [podcastId] and an [idType].
///
/// [idType] defaults to [PodcastIdType.podcastIndex].
/// {@endtemplate}
class PodcastShowDetails extends BaseDetailsData {
  /// {@macro podcast_show_details_request}
  const PodcastShowDetails({
    required this.podcastId,
    this.idType = PodcastIdType.podcastIndex,
  });

  /// Podcast ID
  final String podcastId;

  /// {@macro podcast_id_type}
  ///
  /// Defaults to [PodcastIdType.podcastIndex].
  final PodcastIdType idType;

  @override
  List<Object?> get props => [podcastId];
}

/// {@template podcast_episode_details_request}
/// Podcast Episode Details request.
///
/// Contains a [podcastId] and [episodeId].
///
/// [idType] defaults to [PodcastIdType.podcastIndex].
/// {@endtemplate}
class PodcastEpisodeDetails extends BaseDetailsData {
  /// {@macro podcast_episode_details_request}
  const PodcastEpisodeDetails({
    required this.podcastId,
    required this.episodeId,
    this.idType = PodcastIdType.podcastIndex,
  });

  /// Podcast ID
  final String podcastId;

  /// Episode ID
  final String episodeId;

  /// {@macro podcast_id_type}
  ///
  /// Defaults to [PodcastIdType.podcastIndex].
  final PodcastIdType idType;

  @override
  List<Object?> get props => [podcastId, episodeId];
}
