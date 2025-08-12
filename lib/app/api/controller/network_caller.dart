import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_intern/app/api/controller/network_response.dart';
import 'package:get/get.dart';

class NetworkCaller {
  ///Post Request
  Future<NetworkResponse>? postRequest(String url,
      {Map<String, dynamic>?body}) async {
    try {
      final response = await post(
          Uri.parse(url), body: jsonEncode(body), headers: {
        "Content-type": "Application/json",
      });
      if (response.statusCode == 200) {
        return NetworkResponse(isSuccess: true, statusCode: 200,
          jsonResponse: jsonDecode(response.body),);
      } else {
        return NetworkResponse(isSuccess: false, statusCode: 400,
            jsonResponse: jsonEncode(body)
        );
      }
    } catch (e) {
      return NetworkResponse(isSuccess: false, errorMessage: e.toString());
    }
  }
}

Future<NetworkResponse> getRequest(String url,)

async {
  try {

    final  response=await get(Uri.parse(url));

    if (response.statusCode==200) {
      return NetworkResponse(statusCode: 200, isSuccess: true,

        jsonResponse: jsonDecode(response.body),
      );

    } else if(response.statusCode==401){
      return NetworkResponse(isSuccess: false,statusCode: 401,jsonResponse: jsonDecode(response.body));
    }

    else{
      return NetworkResponse(statusCode: 400, isSuccess: false, jsonResponse:jsonDecode(response.body));
    }
  } catch (e) {
    return NetworkResponse(isSuccess:false,errorMessage: e.toString());
  }
}
