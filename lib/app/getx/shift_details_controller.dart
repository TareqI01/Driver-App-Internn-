import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/shift_model.dart';
import '../models/shift_details_model.dart';
import '../api/controller/network_caller.dart';
import '../api/controller/network_response.dart';
import '../api/controller/urls/urls.dart';
import '../widgets/snack_message.dart';
import 'package:flutter/material.dart';
import '../api/controller/auth_utility.dart'; // Added import for AuthUtility

class ShiftDetailsController extends GetxController {
  RxString plannedTime = "23h".obs;
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
      "Lorem Ipsum Dolor Sit Amet, Consetetur Sadipscing Elitr, Sed Diam Nonumy Eirmod Tempor Invidunt. Dolor Sit Amet, Consetetur Sadipscing Elitr, Sed Diam"
          .obs;

  RxInt requestsDone = 7.obs;
  RxInt requestsTotal = 7.obs;
  RxInt stopsDone = 45.obs;
  RxInt stopsTotal = 45.obs;
  RxInt packagesDone = 87.obs;
  RxInt packagesTotal = 87.obs;


  Rx<ShiftModel?> shiftData = Rx<ShiftModel?>(null);


  Rx<ShiftDetailsModel?> shiftDetailsData = Rx<ShiftDetailsModel?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments['shiftData'] != null) {
      final shift = arguments['shiftData'] as ShiftModel;
      shiftData.value = shift;
      updateShiftDetails(shift);

      getShiftDetails(shift.id!);
    } else if (arguments != null && arguments['shiftId'] != null) {

      final shiftIdValue = arguments['shiftId'];
      shiftId.value = "SH$shiftIdValue";

      getShiftDetails(shiftIdValue);
    }
  }


  void refreshShiftDetails() {
    final currentShiftId = shiftData.value?.id;
    if (currentShiftId != null) {
      getShiftDetails(currentShiftId);
    }
  }


  void initializeWithShiftId(int shiftIdValue) {
    shiftId.value = "SH$shiftIdValue";

    isLoading.value = true;

    getShiftDetails(shiftIdValue);
  }

  void updateShiftDetails(ShiftModel shift) {
    shiftId.value = "SH${shift.id}";
    status.value = shift.status!;

    // Format the time range
    try {
      final startTime = DateTime.parse(shift.scheduledStart!);
      final endTime = DateTime.parse(shift.scheduledEnd!);
      final formatter = DateFormat('dd MMM. yyyy, HH:mm');
      time.value =
          "${formatter.format(startTime)} - ${formatter.format(endTime)}";
    } catch (e) {
      time.value = "${shift.scheduledStart} - ${shift.scheduledEnd}";
    }


    coDrivers.value = shift.coDriverCount! > 0
        ? "${shift.coDriverCount} co-driver(s)"
        : "No co-drivers";
    carNumber.value = shift.car ?? "No car assigned";

    // Update counts
    requestsTotal.value = shift.request!;
    requestsDone.value =
        shift.request!;
    stopsTotal.value = shift.stops!;
    stopsDone.value = shift.stops!;
    packagesTotal.value = shift.packages!;
    packagesDone.value =
        shift.packages!;


    try {
      final startTime = DateTime.parse(shift.scheduledStart!);
      final endTime = DateTime.parse(shift.scheduledEnd!);
      final duration = endTime.difference(startTime);

      plannedTime.value = "${duration.inHours}h ${duration.inMinutes % 60}m";
      usedTime.value =
          plannedTime.value;
      breakTime.value = "0h 0m";
      workedTime.value = plannedTime
          .value;
    } catch (e) {

    }
  }

  Future<void> getShiftDetails(int shiftIdValue) async {
    isLoading.value = true;
    print("Starting API call for shift ID: $shiftIdValue"); // Debug log

    try {
      final url = "${Urls.shiftDetailsUrl}?shiftId=$shiftIdValue";
      print("Calling API: $url"); // Debug log


      final authHeader = await AuthUtility.getAuthorizationHeader();
      print(
        "Authorization header: ${authHeader != null ? "Bearer [TOKEN]" : "No token"}",
      );

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        authorizationHeader: authHeader,
      );

      if (response.isSuccess) {
        print("API call successful for shift ID: $shiftIdValue");
        print("Response data: ${response.jsonResponse}");

        final shiftDetails = ShiftDetailsModel.fromJson(response.jsonResponse);
        shiftDetailsData.value = shiftDetails;


        updateUIWithShiftDetails(shiftDetails);
        print(
          "Successfully loaded shift details for ID: $shiftIdValue",
        ); // Debug log
      } else {

      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void updateUIWithShiftDetails(ShiftDetailsModel shiftDetails) {
    final summary = shiftDetails.data.summary;
    final capacity = shiftDetails.data.capacitySummary;


    requestsTotal.value = summary.numberOfRequest;
    requestsDone.value = summary.numberOfCompletedRequest;
    stopsTotal.value = summary.numberOfStop;
    stopsDone.value = summary.numberOfCompletedStop;
    packagesTotal.value = summary.numberOfProduct;
    packagesDone.value = summary.numberOfCompletedProduct;


    if (summary.numberOfRequest > 0 &&
        summary.numberOfCompletedRequest == summary.numberOfRequest) {
      status.value = "Completed";
    } else if (summary.numberOfCompletedRequest > 0) {
      status.value = "In Progress";
    } else {
      status.value = "Pending";
    }
  }
}
