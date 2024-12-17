import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio_pkg;
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class ApiService {
  final MainController controller = Get.put(MainController());
  String? baseUrl = dotenv.env['BASE_URL'];
  String? googleApi = dotenv.env['GOOGLE_API_KEY'];

  Future<dynamic> signUp(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/api/user/signup');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> searchMap(String query) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApi');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['predictions'];
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchJsonNano() async {
    final url = Uri.parse('$baseUrl/api/vehicle/validation/response');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchParkingZone() async {
    final url = Uri.parse('$baseUrl/api/zone');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print(responseData);
        return responseData;
      } else {
        print(response.statusCode);
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchSpecificParkingZone(int zoneSeq) async {
    final url = Uri.parse('$baseUrl/api/zone/$zoneSeq');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        return responseData;
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchMyParkingZone() async {
    final userId = controller.userName.value;
    final url = Uri.parse('$baseUrl/api/zone/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData is Map<String, dynamic>) {
          return [responseData];
        } else if (responseData is List) {
          return responseData;
        } else {
          return {'error': 'Unexpected data format'};
        }
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchMyReservation() async {
    final userId = controller.userName.value;
    final url = Uri.parse('$baseUrl/api/reservation/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData is Map<String, dynamic>) {
          return [responseData];
        } else if (responseData is List) {
          return responseData;
        } else {
          return {'error': 'Unexpected data format'};
        }
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchMyCar() async {
    final userId = controller.userName.value;
    final url = Uri.parse('$baseUrl/api/car/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData is Map<String, dynamic>) {
          return [responseData];
        } else if (responseData is List) {
          return responseData;
        } else {
          return {'error': 'Unexpected data format'};
        }
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> searchMyParkingZoneReservations(int zoneSeq) async {
    final url = Uri.parse('$baseUrl/api/reservation/zone/$zoneSeq');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData is List) {
          return responseData;
        } else {
          return {'error': 'Unexpected data format'};
        }
      } else {
        return {'error': 'Failed to fetch data', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<dynamic> userIdCheck(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members/emailCheck');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        if (response.body == "true") {
          return true;
        } else {
          return false;
        }
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> login(Map<String, dynamic> formData) async {
    const storage = FlutterSecureStorage();
    final url = Uri.parse('$baseUrl/api/user/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        controller.userName.value = responseData['userId'];
        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> submitParkingZone(Map<String, dynamic> formData) async {
    final userId = controller.userName.value;
    final url = Uri.parse('$baseUrl/api/user/zone/$userId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'status': 200, 'data': responseData};
      } else {
        return {'status': response.statusCode, 'error': '등록 실패'};
      }
    } catch (e) {
      return {'status': 500, 'error': e.toString()};
    }
  }

  Future<dynamic> withdraw(Map<String, dynamic> formData) async {
    final url = Uri.parse('$baseUrl/members');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );
      if (response.statusCode == 200) {
        controller.accessToken.value = "";
        controller.userId.value = 0;
        controller.userName.value = "";

        return response.statusCode;
      } else {
        final responseData = jsonDecode(response.body);
        return responseData;
      }
    } catch (e) {
      return e;
    }
  }
}
