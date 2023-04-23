
class ScannerState {}

class ScannerInitialState extends ScannerState {}

class ScannerLoadingState extends ScannerState {}

class ScannerLoadedState extends ScannerState {}

class ScannerErrorState extends ScannerState {
  String e;

  ScannerErrorState(this.e);
}
