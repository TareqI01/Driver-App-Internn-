import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShiftPlannerController extends GetxController{


  RxString formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).obs;

}