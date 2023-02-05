import 'package:equatable/equatable.dart';

/// {@template details_request}
/// Base Details Request.
/// {@endtemplate}
abstract class DetailsRequestBase extends Equatable {
  /// {@macro details_request}
  const DetailsRequestBase();
}

/// {@template movie_details_request}
/// Movie Details request.
///
/// Contains a [movieId].
/// {@endtemplate}
class MovieDetailsRequest extends DetailsRequestBase {
  /// {@macro movie_details_request}
  const MovieDetailsRequest({required this.movieId});

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
class TvShowDetailsRequest extends DetailsRequestBase {
  /// {@macro tv_show_details_request}
  const TvShowDetailsRequest({required this.tvShowId});

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
class TvSeasonDetailsRequest extends DetailsRequestBase {
  /// {@macro tv_season_details_request}
  const TvSeasonDetailsRequest({
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
class TvEpisodeDetailsRequest extends DetailsRequestBase {
  /// {@macro tv_episode_details_request}
  const TvEpisodeDetailsRequest({
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

/// {@template book_id_type}
/// Book ID Type.
///
/// Can be a [googleBooks] or an [isbn] ID type.
/// {@endtemplate}
enum BookIdType {
  /// Google Books ID
  googleBooks('google_books'),

  /// ISBN
  isbn('isbn');

  /// {@macro book_id_type}
  const BookIdType(this.queryParam);

  /// String representation of this query parameter.
  final String queryParam;
}

/// {@template book_details_request}
/// Book Details request.
///
/// Contains a [bookId] and an [idType].
///
/// [idType] defaults to [BookIdType.googleBooks].
/// {@endtemplate}
class BookDetailsRequest extends DetailsRequestBase {
  /// {@macro book_details_request}
  const BookDetailsRequest({
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
class GameDetailsRequest extends DetailsRequestBase {
  /// {@macro game_details_request}
  const GameDetailsRequest({required this.gameId});

  /// Game ID
  final String gameId;

  @override
  List<Object?> get props => [gameId];
}

/// {@template podcast_id_type}
/// Podcast ID Type.
///
/// Can be a [podcastIndex] or an [iTunes] ID type.
/// {@endtemplate}
enum PodcastIdType {
  /// Podcast Index ID.
  podcastIndex('podcast_index'),

  /// iTunes ID.
  iTunes('itunes');

  /// {@macro podcast_id_type}
  const PodcastIdType(this.queryParam);

  /// String representation of this query parameter.
  final String queryParam;
}

/// {@template podcast_show_details_request}
/// Podcast Show Details request.
///
/// Contains a [podcastId] and an [idType].
///
/// [idType] defaults to [PodcastIdType.podcastIndex].
/// {@endtemplate}
class PodcastShowDetailsRequest extends DetailsRequestBase {
  /// {@macro podcast_show_details_request}
  const PodcastShowDetailsRequest({
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
  List<Object?> get props => [podcastId, idType];
}

/// {@template podcast_episode_details_request}
/// Podcast Episode Details request.
///
/// Contains a [podcastId] and [episodeId].
///
/// [idType] defaults to [PodcastIdType.podcastIndex].
/// {@endtemplate}
class PodcastEpisodeDetailsRequest extends DetailsRequestBase {
  /// {@macro podcast_episode_details_request}
  const PodcastEpisodeDetailsRequest({
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
