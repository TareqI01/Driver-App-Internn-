class NetworkResponse{
  final bool isSuccess;
  final int statusCode;
  final dynamic jsonResponse;
  String errorMessage;
  NetworkResponse({required this.isSuccess, this.statusCode=1,this.jsonResponse,this.errorMessage="Something Went Wrong"});

}