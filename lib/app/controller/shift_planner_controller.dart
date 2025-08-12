import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../api/controller/network_caller.dart';
import '../api/controller/auth_utility.dart';
import '../api/controller/urls/urls.dart';
import '../models/shift_model.dart';
import '../screens/login_screen.dart';

class ShiftPlannerController extends GetxController {
  RxString formattedDate = DateFormat(
    'yyyy-MM-dd – kk:mm',
  ).format(DateTime.now()).obs;

  // Observable variables for shifts
  RxList<ShiftModel> shifts = <ShiftModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNextPage = false.obs;
  RxBool hasPreviousPage = false.obs;

  // Network caller instance
  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onInit() {
    super.onInit();
    getShifts();
  }

  Future<void> getShifts({int page = 1}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('Fetching shifts from: ${Urls.shiftFilterUrl}');

      // Get authorization header
      final authHeader = await AuthUtility.getAuthorizationHeader();
      print(
        'Authorization header: ${authHeader != null ? "Bearer [TOKEN]" : "No token"}',
      );

      final response = await _networkCaller.getRequest(
        Urls.shiftFilterUrl,
        authorizationHeader: authHeader,
      );
      print('Response received: ${response.isSuccess}');
      print('Response data: ${response.jsonResponse}');

      if (response.isSuccess && response.jsonResponse != null) {
        // Check if the response indicates an error
        if (response.jsonResponse['isSuccess'] == false) {
          hasError.value = true;
          errorMessage.value =
              response.jsonResponse['message'] ?? 'API returned an error';
          print('API returned error: ${response.jsonResponse['message']}');
          return;
        }

        // Check if the response has the expected structure
        if (response.jsonResponse['data'] != null) {
          print('Parsing response with data key');
          final shiftResponse = ShiftListResponse.fromJson(
            response.jsonResponse['data'],
          );

          if (page == 1) {
            shifts.value = shiftResponse.shiftList;
          } else {
            shifts.addAll(shiftResponse.shiftList);
          }

          currentPage.value = shiftResponse.pageNumber;
          totalPages.value = shiftResponse.totalPages;
          hasNextPage.value = shiftResponse.hasNextPage;
          hasPreviousPage.value = shiftResponse.hasPreviousPage;

          print('Successfully parsed ${shiftResponse.shiftList.length} shifts');

          // Check if we got any shifts
          if (shiftResponse.shiftList.isEmpty && page == 1) {
            print('No shifts found in response');
          }
        } else {
          // If no 'data' key, try to parse directly
          print('Parsing response directly (no data key)');
          final shiftResponse = ShiftListResponse.fromJson(
            response.jsonResponse,
          );

          if (page == 1) {
            shifts.value = shiftResponse.shiftList;
          } else {
            shifts.addAll(shiftResponse.shiftList);
          }

          currentPage.value = shiftResponse.pageNumber;
          totalPages.value = shiftResponse.totalPages;
          hasNextPage.value = shiftResponse.hasNextPage;
          hasPreviousPage.value = shiftResponse.hasPreviousPage;

          print('Successfully parsed ${shiftResponse.shiftList.length} shifts');

          // Check if we got any shifts
          if (shiftResponse.shiftList.isEmpty && page == 1) {
            print('No shifts found in response');
          }
        }
      } else {
        hasError.value = true;
        if (response.statusCode == 401) {
          errorMessage.value = 'Unauthorized access. Please login again.';
          // Handle authentication failure
          handleAuthFailure();
          return;
        } else if (response.statusCode == 404) {
          errorMessage.value = 'API endpoint not found.';
        } else if (response.statusCode == 500) {
          errorMessage.value = 'Server error. Please try again later.';
        } else {
          errorMessage.value = response.errorMessage;
        }
      }
    } catch (e) {
      print('Error in getShifts: $e');
      hasError.value = true;
      if (e.toString().contains('FormatException')) {
        errorMessage.value = 'Invalid data format received from server';
      } else if (e.toString().contains('SocketException')) {
        errorMessage.value =
            'Network connection error. Please check your internet connection.';
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (hasNextPage.value && !isLoading.value) {
      await getShifts(page: currentPage.value + 1);
    }
  }

  // Handle authentication failure by redirecting to login
  void handleAuthFailure() {
    AuthUtility.clearAuthData();
    Get.offAll(() => LoginScreen());
  }

  Future<void> refreshShifts() async {
    currentPage.value = 1;
    await getShifts(page: 1);
  }

  String formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        // Today
        if (difference.inHours < 24) {
          return 'Today at ${DateFormat('HH:mm').format(dateTime)}';
        }
      } else if (difference.inDays == 1) {
        // Yesterday
        return 'Yesterday at ${DateFormat('HH:mm').format(dateTime)}';
      } else if (difference.inDays < 7) {
        // This week
        return DateFormat('EEEE at HH:mm').format(dateTime);
      } else {
        // Older
        return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
      }

      return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'upcoming':
        return Colors.orange;
      case 'unassigned':
        return Colors.red;
      case 'in_progress':
        return Colors.purple;
      case 'cancelled':
        return Colors.red.shade700;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
