abstract class ImeiInfoState {}

class ImeiInfoInitial extends ImeiInfoState {}

class ImeiInfoLoadingProgress extends ImeiInfoState {}

class ImeiInfoLoadSuccess extends ImeiInfoState {
  // final List<User> user;
  //
  // UserLoadSuccess({required this.user});
}

class ImeiInfoLoadFailure extends ImeiInfoState {
  final String error;

  ImeiInfoLoadFailure({required this.error});
}
