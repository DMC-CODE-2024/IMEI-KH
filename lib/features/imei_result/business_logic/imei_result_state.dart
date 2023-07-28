abstract class ImeiResultState {}

class ImeiResultInitial extends ImeiResultState {}

class ImeiResultLoadingProgress extends ImeiResultState {}

class ImeiResultLoadSuccess extends ImeiResultState {
}

class ImeiResultLoadFailure extends ImeiResultState {
  final String error;

  ImeiResultLoadFailure({required this.error});
}
