import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router_test/details/detials.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(const DetailsState()) {
    on<DetailsRequested>(_onDetailsRequested);
  }

  void _onDetailsRequested(DetailsRequested event, Emitter<DetailsState> emit) {
    final mediaType = event.mediaType;

    BaseDetailsData details;

    // TODO: currently dummy requests. this would be replaced with specific requests from the backend
    switch (mediaType) {
      case MediaType.movie:
        final request = event.request as MovieDetailsRequest;
        details = MovieDetails(
          movieId: request.movieId,
        );
        break;
      case MediaType.tvShow:
        final request = event.request as TvShowDetailsRequest;
        details = TvShowDetails(
          tvShowId: request.tvShowId,
        );
        break;
      case MediaType.tvSeason:
        final request = event.request as TvSeasonDetailsRequest;
        details = TvSeasonDetails(
          tvShowId: request.tvShowId,
          seasonNo: request.seasonNo,
        );
        break;
      case MediaType.tvEpisode:
        final request = event.request as TvEpisodeDetailsRequest;
        details = TvEpisodeDetails(
          tvShowId: request.tvShowId,
          seasonNo: request.seasonNo,
          episodeNo: request.episodeNo,
        );
        break;
      case MediaType.book:
        final request = event.request as BookDetailsRequest;
        details = BookDetails(
          bookId: request.bookId,
          idType: request.idType,
        );
        break;
      case MediaType.game:
        final request = event.request as GameDetailsRequest;
        details = GameDetails(
          gameId: request.gameId,
        );
        break;
      case MediaType.podcastShow:
        final request = event.request as PodcastShowDetailsRequest;
        details = PodcastShowDetails(
          podcastId: request.podcastId,
          idType: request.idType,
        );
        break;
      case MediaType.podcastEpisode:
        final request = event.request as PodcastEpisodeDetailsRequest;
        details = PodcastEpisodeDetails(
          podcastId: request.podcastId,
          episodeId: request.episodeId,
          idType: request.idType,
        );
        break;
    }

    emit(state.copyWith(mediaType: mediaType, details: details));
  }
}
