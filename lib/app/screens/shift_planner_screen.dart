import 'package:flutter/material.dart';
import 'package:flutter_intern/app/getx/shift_planner_controller.dart';
import 'package:flutter_intern/app/screens/shift_details_screen.dart';
import 'package:get/get.dart';

class ShiftPlannerScreen extends StatefulWidget {
  @override
  State<ShiftPlannerScreen> createState() => _ShiftPlannerScreenState();
}

class _ShiftPlannerScreenState extends State<ShiftPlannerScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftPlannerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shift Planner"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, controller),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshShifts(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.shifts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading shifts...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value && controller.shifts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading shifts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshShifts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.shifts.isEmpty && !controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No shifts found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'There are no shifts available at the moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshShifts(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshShifts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.shifts.length +
                1 +
                (controller.hasNextPage.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Summary header
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Shifts',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${controller.shifts.length}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (controller.hasNextPage.value)
                            Text(
                              'More available',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 32,
                            color: Colors.blue.shade600,
                          ),
                          if (controller.hasNextPage.value)
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue.shade600,
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              if (index == controller.shifts.length + 1) {
                // Load more button
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.loadNextPage,
                      child: controller.isLoading.value
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Loading...'),
                              ],
                            )
                          : const Text('Load More'),
                    ),
                  ),
                );
              }

              final shift = controller.shifts[index - 1];
              return _buildShiftCard(context, shift, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildShiftCard(
    BuildContext context,
    dynamic shift,
    ShiftPlannerController controller,
  ) {
    // Check for null or empty photoUrl before using NetworkImage
    final hasPhoto =
        shift.photoUrl != null &&
        (shift.photoUrl is String) &&
        shift.photoUrl.isNotEmpty;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ShiftDetailsScreen(shiftId: shift.id),
            arguments: {'shiftData': shift},
          );
        },
        onLongPress: () {
          _showShiftQuickPreview(context, shift, controller);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: controller
                                .getStatusColor(shift.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.getStatusColor(shift.status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            shift.status,
                            style: TextStyle(
                              color: controller.getStatusColor(shift.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ID: ${shift.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Driver information
              Row(
                children: [
                  // shift.photoUrl.isNotEmpty || shift.photoUrl != null
                  //     ? CircleAvatar(
                  //         radius: 20,
                  //         backgroundColor: Colors.grey.shade200,
                  //         backgroundImage: hasPhoto
                  //             ? NetworkImage(shift.photoUrl)
                  //             : null,
                  //         child: !hasPhoto
                  //             ? Icon(Icons.person, color: Colors.grey.shade600)
                  //             : null,
                  //         onBackgroundImageError: (exception, stackTrace) {
                  //           // Handle image loading error silently
                  //         },
                  //       )
                  //     :
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drivers',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          shift.drivers != null && shift.drivers.isNotEmpty
                              ? shift.drivers
                              : 'No driver assigned',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (shift.car != null && shift.car!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Car: ${shift.car}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Schedule information
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start: ${controller.formatDateTime(shift.scheduledStart)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          'End: ${controller.formatDateTime(shift.scheduledEnd)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Additional details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem('Co-Drivers', '${shift.coDriverCount}'),
                  _buildDetailItem('Requests', '${shift.request}'),
                  _buildDetailItem('Stops', '${shift.stops}'),
                  _buildDetailItem('Packages', '${shift.packages}'),
                ],
              ),

              const SizedBox(height: 8),

              // Status indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getStatusColor(shift.status)
                      .withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Status: ${shift.status}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.getStatusColor(shift.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _showSearchDialog(
    BuildContext context,
    ShiftPlannerController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search & Filter Shifts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filter by status:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    ['All', 'Assigned', 'Completed', 'Upcoming', 'Unassigned']
                        .map(
                          (status) => FilterChip(
                            label: Text(status),
                            selected: false,
                            onSelected: (selected) {
                              // TODO: Implement status filtering
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Other options will be added here.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showShiftQuickPreview(
    BuildContext context,
    dynamic shift,
    ShiftPlannerController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Shift ${shift.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${shift.status}'),
              const SizedBox(height: 4),
              Text(
                'Drivers: ${shift.drivers != null && shift.drivers.isNotEmpty ? shift.drivers : 'No driver assigned'}',
              ),
              if (shift.car != null && shift.car!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Car: ${shift.car}'),
              ],
              const SizedBox(height: 4),
              Text('Start: ${controller.formatDateTime(shift.scheduledStart)}'),
              const SizedBox(height: 4),
              Text('End: ${controller.formatDateTime(shift.scheduledEnd)}'),
              const SizedBox(height: 8),
              Text('Co-Drivers: ${shift.coDriverCount}'),
              Text('Requests: ${shift.request}'),
              Text('Stops: ${shift.stops}'),
              Text('Packages: ${shift.packages}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(
                  () => ShiftDetailsScreen(shiftId: shift.id),
                  arguments: {'shiftData': shift},
                );
              },
              child: const Text('View Details'),
            ),
          ],
        );
      },
    );
  }
}
