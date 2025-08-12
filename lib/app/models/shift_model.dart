class ShiftModel {
  final int id;
  final String drivers;
  final String? car;
  final String status;
  final int request;
  final int stops;
  final int packages;
  final String photoUrl;
  final int coDriverCount;
  final String scheduledStart;
  final String scheduledEnd;

  ShiftModel({
    required this.id,
    required this.drivers,
    this.car,
    required this.status,
    required this.request,
    required this.stops,
    required this.packages,
    required this.photoUrl,
    required this.coDriverCount,
    required this.scheduledStart,
    required this.scheduledEnd,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] ?? 0,
      drivers: json['drivers'] ?? '',
      car: json['car'],
      status: json['status'] ?? '',
      request: json['request'] ?? 0,
      stops: json['stops'] ?? 0,
      packages: json['packages'] ?? 0,
      photoUrl: json['photoUrl'] ?? '',
      coDriverCount: json['coDriverCount'] ?? 0,
      scheduledStart: json['scheduledStart'] ?? '',
      scheduledEnd: json['scheduledEnd'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drivers': drivers,
      'car': car,
      'status': status,
      'request': request,
      'stops': stops,
      'packages': packages,
      'photoUrl': photoUrl,
      'coDriverCount': coDriverCount,
      'scheduledStart': scheduledStart,
      'scheduledEnd': scheduledEnd,
    };
  }
}

class ShiftListResponse {
  final List<ShiftModel> shiftList;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  ShiftListResponse({
    required this.shiftList,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory ShiftListResponse.fromJson(Map<String, dynamic> json) {
    return ShiftListResponse(
      shiftList: (json['shiftList'] as List?)
          ?.map((item) => ShiftModel.fromJson(item))
          .toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 30,
      totalPages: json['totalPages'] ?? 1,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
