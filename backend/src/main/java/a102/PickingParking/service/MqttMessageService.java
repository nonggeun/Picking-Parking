package a102.PickingParking.service;

import a102.PickingParking.dto.LicensePlateResponse;
import a102.PickingParking.dto.VehicleValidationResponse;
import a102.PickingParking.entity.MqttData;
import a102.PickingParking.repository.MqttMessageRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;

@Service
public class MqttMessageService {

    @Autowired
    private MqttMessageRepository mqttMessageRepository;

    @Autowired
    private VehicleValidationService vehicleValidationService; // 서비스 주입

    public void handleMqttMessage(String payload) {

        try {
            // JSON 문자열을 DTO로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            LicensePlateResponse messageDto = objectMapper.readValue(payload, LicensePlateResponse.class);

            String licensePlate = messageDto.getResult();
            Integer zoneSeq = messageDto.getZoneSeq();

            // 차량 유효성 검사
            Boolean isMatched = vehicleValidationService.validateVehicle(licensePlate, zoneSeq);

            // 데이터베이스에 저장
            MqttData messageData = new MqttData();
            messageData.setZoneSeq(zoneSeq);
            messageData.setResult(licensePlate);
            messageData.setIsMatched(isMatched); // isMatched를 MqttData에 추가해야 함
            mqttMessageRepository.save(messageData);

        } catch (Exception e) {
            e.printStackTrace(); // 예외 처리
        }
    }
}