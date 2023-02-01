part of 'details_bloc.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsRequested extends DetailsEvent {
  const DetailsRequested({required this.mediaType, required this.request});

  final MediaType mediaType;
  final BaseDetailsRequest request;

  @override
  List<Object> get props => [mediaType, request];
}
