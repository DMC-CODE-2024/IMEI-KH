import 'dart:typed_data';

abstract class ScannerEvent {
  const ScannerEvent();
}

class ScannerInitEvent extends ScannerEvent {
  Uint8List? imgBytes;
  ScannerInitEvent({this.imgBytes});
}
