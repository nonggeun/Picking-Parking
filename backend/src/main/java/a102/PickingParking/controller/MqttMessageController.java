package a102.PickingParking.controller;

import a102.PickingParking.dto.VehicleValidationResponse;
import a102.PickingParking.entity.MqttData;
import a102.PickingParking.repository.MqttMessageRepository;
import a102.PickingParking.service.VehicleValidationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/vehicle")
public class MqttMessageController {

    @Autowired
    private MqttMessageRepository mqttMessageRepository;

    @Autowired
    private VehicleValidationService vehicleValidationService;

    @GetMapping("/validation/response")
    public ResponseEntity<List<VehicleValidationResponse>> getMessages(
            @RequestParam(required = false) Integer zoneSeq) {
        List<VehicleValidationResponse> responses = new ArrayList<>();

        // 모든 메시지 조회
        List<MqttData> messages = mqttMessageRepository.findAll();

        for (MqttData message : messages) {
            // zoneSeq가 null이거나 일치하는 경우에만 응답에 추가
            if (zoneSeq == null || message.getZoneSeq().equals(zoneSeq)) {
                // 필요한 값 추출
                String licensePlate = message.getResult(); // 차량 번호판
                Integer messageZoneSeq = message.getZoneSeq(); // zone_seq
                Boolean isMatched = vehicleValidationService.validateVehicle(licensePlate, zoneSeq);
                // DTO 객체 생성
                VehicleValidationResponse response = new VehicleValidationResponse(isMatched, licensePlate, messageZoneSeq);
                responses.add(response);
            }
        }

        return ResponseEntity.ok(responses);
    }
}


