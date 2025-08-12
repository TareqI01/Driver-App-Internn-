class ShiftDetailsModel {
  final int statusCode;
  final String message;
  final bool isSuccess;
  final ShiftDetailsData data;

  ShiftDetailsModel({
    required this.statusCode,
    required this.message,
    required this.isSuccess,
    required this.data,
  });

  factory ShiftDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShiftDetailsModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      data: ShiftDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class ShiftDetailsData {
  final Summary summary;
  final List<dynamic> requestList;
  final List<dynamic> stopList;
  final List<dynamic> productList;
  final CapacitySummary capacitySummary;

  ShiftDetailsData({
    required this.summary,
    required this.requestList,
    required this.stopList,
    required this.productList,
    required this.capacitySummary,
  });

  factory ShiftDetailsData.fromJson(Map<String, dynamic> json) {
    return ShiftDetailsData(
      summary: Summary.fromJson(json['summary'] ?? {}),
      requestList: json['requestList'] ?? [],
      stopList: json['stopList'] ?? [],
      productList: json['productList'] ?? [],
      capacitySummary: CapacitySummary.fromJson(json['capacitySummary'] ?? {}),
    );
  }
}

class Summary {
  final int numberOfRequest;
  final int numberOfCompletedRequest;
  final int numberOfInCompletedRequest;
  final int numberOfStop;
  final int numberOfCompletedStop;
  final int numberOfInCompletedStop;
  final int numberOfProduct;
  final int numberOfCompletedProduct;
  final int numberOfInCompletedProduct;

  Summary({
    required this.numberOfRequest,
    required this.numberOfCompletedRequest,
    required this.numberOfInCompletedRequest,
    required this.numberOfStop,
    required this.numberOfCompletedStop,
    required this.numberOfInCompletedStop,
    required this.numberOfProduct,
    required this.numberOfCompletedProduct,
    required this.numberOfInCompletedProduct,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      numberOfRequest: json['numberOfRequest'] ?? 0,
      numberOfCompletedRequest: json['numberOfCompletedRequest'] ?? 0,
      numberOfInCompletedRequest: json['numberOfInCompletedRequest'] ?? 0,
      numberOfStop: json['numberOfStop'] ?? 0,
      numberOfCompletedStop: json['numberOfCompletedStop'] ?? 0,
      numberOfInCompletedStop: json['numberOfInCompletedStop'] ?? 0,
      numberOfProduct: json['numberOfProduct'] ?? 0,
      numberOfCompletedProduct: json['numberOfCompletedProduct'] ?? 0,
      numberOfInCompletedProduct: json['numberOfInCompletedProduct'] ?? 0,
    );
  }
}

class CapacitySummary {
  final int shiftId;
  final double weightCapacityKg;
  final double usedWeightKg;
  final double remainingWeightKg;
  final double volumeCapacityCbm;
  final double usedVolumeCbm;
  final double remainingVolumeCbm;
  final double liquidCapacityLiters;
  final double usedLiquidLiters;
  final double remainingLiquidLiters;
  final int palletCapacity;
  final int usedPallets;
  final int remainingPallets;

  CapacitySummary({
    required this.shiftId,
    required this.weightCapacityKg,
    required this.usedWeightKg,
    required this.remainingWeightKg,
    required this.volumeCapacityCbm,
    required this.usedVolumeCbm,
    required this.remainingVolumeCbm,
    required this.liquidCapacityLiters,
    required this.usedLiquidLiters,
    required this.remainingLiquidLiters,
    required this.palletCapacity,
    required this.usedPallets,
    required this.remainingPallets,
  });

  factory CapacitySummary.fromJson(Map<String, dynamic> json) {
    return CapacitySummary(
      shiftId: json['shiftId'] ?? 0,
      weightCapacityKg: (json['weightCapacityKg'] ?? 0).toDouble(),
      usedWeightKg: (json['usedWeightKg'] ?? 0).toDouble(),
      remainingWeightKg: (json['remainingWeightKg'] ?? 0).toDouble(),
      volumeCapacityCbm: (json['volumeCapacityCbm'] ?? 0).toDouble(),
      usedVolumeCbm: (json['usedVolumeCbm'] ?? 0).toDouble(),
      remainingVolumeCbm: (json['remainingVolumeCbm'] ?? 0).toDouble(),
      liquidCapacityLiters: (json['liquidCapacityLiters'] ?? 0).toDouble(),
      usedLiquidLiters: (json['usedLiquidLiters'] ?? 0).toDouble(),
      remainingLiquidLiters: (json['remainingLiquidLiters'] ?? 0).toDouble(),
      palletCapacity: json['palletCapacity'] ?? 0,
      usedPallets: json['usedPallets'] ?? 0,
      remainingPallets: json['remainingPallets'] ?? 0,
    );
  }
}
