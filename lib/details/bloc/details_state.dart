part of 'details_bloc.dart';

class DetailsState extends Equatable {
  const DetailsState({
    this.mediaType = MediaType.movie,
    this.details = const MovieDetails(movieId: 'intiialId'),
  });

  final MediaType mediaType;
  final BaseDetailsData details;

  @override
  List<Object> get props => [
        mediaType,
        details,
      ];

  DetailsState copyWith({
    MediaType? mediaType,
    BaseDetailsData? details,
  }) {
    return DetailsState(
      mediaType: mediaType ?? this.mediaType,
      details: details ?? this.details,
    );
  }
}
