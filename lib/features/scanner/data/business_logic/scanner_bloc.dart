import 'dart:io';

import 'package:eirs/features/scanner/data/business_logic/scanner_state.dart';
import 'package:eirs/repoistory/eirs_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'scanner_event.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  EirsRepository eirsRepository = EirsRepository();

  ScannerBloc() : super(ScannerInitialState()) {
    on<ScannerInitEvent>(mapEventToState);
  }

  void mapEventToState(ScannerEvent event, Emitter<ScannerState> emit) async {
    //emit(ScannerLoadingState());
    if (event is ScannerInitEvent) {
      var imgBytes = event.imgBytes;
      if (imgBytes != null) {
        try {
          final tempDir = await getTemporaryDirectory();
          File fileToBeUploaded =
              await File('${tempDir.path}/image.png').create();
          fileToBeUploaded.writeAsBytesSync(imgBytes);
          emit(ScannerLoadedState());
        } catch (e) {
          emit(ScannerErrorState(e.toString()));
        }
      }
    }
  }
}
