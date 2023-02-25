abstract class ImeiResultState {}

class ImeiResultInitial extends ImeiResultState {}

class ImeiResultLoadingProgress extends ImeiResultState {}

class ImeiResultLoadSuccess extends ImeiResultState {
  // final List<User> user;
  //
  // UserLoadSuccess({required this.user});
}

class ImeiResultLoadFailure extends ImeiResultState {
  final String error;

  ImeiResultLoadFailure({required this.error});
}
