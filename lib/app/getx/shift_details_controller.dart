import 'package:get/get.dart';

class ShiftDetailsController extends GetxController {

  RxString  plannedTime = "23h".obs;
  RxString usedTime = "20h".obs;
  RxString breakTime = "1h 45m".obs;
  RxString workedTime = "18h 15m".obs;

  RxString shiftId = "SH386015".obs;
  RxString status = "Completed".obs;
  RxString time = "03 Mar. 2023, 08:00 - 17:00".obs;
  RxString address = "Algade 56, 2. sal, 4000 Roskilde | 17th".obs;
  RxString coDrivers = "Emon Chakladar, Shohag Siraji".obs;
  RxString carNumber = "Toyota, AA 99 999".obs;
  RxString instruction =
      "Lorem Ipsum Dolor Sit Amet, Consetetur Sadipscing Elitr, Sed Diam Nonumy Eirmod Tempor Invidunt. Dolor Sit Amet, Consetetur Sadipscing Elitr, Sed Diam".obs;

  RxInt requestsDone = 7.obs;
  RxInt requestsTotal = 7.obs;
  RxInt stopsDone = 45.obs;
  RxInt stopsTotal = 45.obs;
  RxInt packagesDone = 87.obs;
  RxInt packagesTotal = 87.obs;
}
