import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/screens/complete_screen.dart';
import 'package:frontend/services/api_service.dart';

class ParkingSubmit extends StatefulWidget {
  final double latitude;
  final double longitude;
  final VoidCallback onClose;

  const ParkingSubmit({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ParkingSubmit> createState() => _ParkingSubmitState();
}

class _ParkingSubmitState extends State<ParkingSubmit> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController detailedAddressController =
      TextEditingController();
  final ApiService apiService = ApiService();

  String? address1;
  String? address2;
  String? address3;
  String? address4;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    final naverApiId = dotenv.env['NAVER_Api_Id'];
    final naverApiKey = dotenv.env['NAVER_Api_KEY'];
    final url = 'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc'
        '?coords=${widget.longitude},${widget.latitude}&output=json&orders=roadaddr';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-ncp-apigw-api-key-id': naverApiId!,
          'x-ncp-apigw-api-key': naverApiKey!,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["results"].isNotEmpty) {
          setState(() {
            address1 = data["results"][0]['region']['area1']['name'];
            address2 = data["results"][0]['region']['area2']['name'];
            address3 = data["results"][0]['region']['area3']['name'];
            address4 = data["results"][0]['land']['name'];

            addressController.text =
                '${address1 ?? ''} ${address2 ?? ''} ${address3 ?? ''} ${address4 ?? ''}';
            loading = false;
          });
        } else {
          _setAddressError('주소를 찾을 수 없습니다.');
        }
      } else {
        _setAddressError('주소 가져오기 실패');
      }
    } catch (e) {
      _setAddressError('오류: $e');
    }
  }

  void _setAddressError(String error) {
    setState(() {
      address1 = error;
      loading = false;
    });
  }

  Future<void> _submitAddress() async {
    final address = addressController.text;
    final detailedAddress = detailedAddressController.text;

    final formData = {
      'prk_cmpr': '$address $detailedAddress',
    };

    try {
      final response = await apiService.submitParkingZone(formData);
      if (response['status'] == 200) {
        Get.to(() => CompleteScreen(), arguments: {'type': 'parking'});
      } else {
        _showError(response['error'] ?? '등록 실패');
      }
    } catch (e) {
      _showError('오류 발생: $e');
    }
  }

  void _showError(String message) {
    Get.snackbar('오류', message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth < 600 ? screenWidth * 0.9 : 500;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: inputWidth),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '주차장 위치',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildAddressFields(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.onClose,
                    child: const Text('닫기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '현재 위치: ${addressController.text}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: '주소',
            border: OutlineInputBorder(),
          ),
          readOnly: true,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: detailedAddressController,
          decoration: const InputDecoration(
            labelText: '상세 주소',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitAddress,
          child: const Text('주소 제출하기'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
