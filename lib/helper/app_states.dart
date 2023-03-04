import 'package:eirs/features/launcher/data/models/device_details_res.dart';

class AppStates {
  static LabelDetails? labelDetails;

   static setLabelDetails(LabelDetails? textDetails) {
    labelDetails = textDetails;
  }

  static LabelDetails? getLabelDetails() {
    return labelDetails;
  }
}
