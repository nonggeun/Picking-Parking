//package a102.PickingParking.controller;
//
//import a102.PickingParking.config.MQTTConfig;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//
//
//@RestController
//@RequestMapping("/api/mqtt")  // API 경로 구조화
//@Slf4j  // 로깅 추가
//public class MqttController {
//    private final MQTTConfig mqttConfig;
//
//    public MqttController(MQTTConfig mqttConfig) {
//        this.mqttConfig = mqttConfig;
//    }
//
//    @GetMapping("/publish")
//    public ResponseEntity<String> publishMessage(@RequestParam(defaultValue = "mqtt_test") String topic,
//                                                 @RequestParam String message) {
//        try {
//            mqttConfig.publishMessage(topic, message);
//            log.info("Successfully published message to topic: {}", topic);
//            return ResponseEntity.ok("Message published successfully!");
//        } catch (Exception e) {
//            log.error("Failed to publish message to topic: {}", topic, e);
//            return ResponseEntity.internalServerError().body("Failed to publish message: " + e.getMessage());
//        }
//    }
//
//    // 추가 엔드포인트: 연결 상태 확인
//    @GetMapping("/status")
//    public ResponseEntity<String> checkConnectionStatus() {
//        try {
//            boolean isConnected = mqttConfig.isConnected(); // MQTTConfig에 이 메서드 추가 필요
//            return ResponseEntity.ok("MQTT Client is " + (isConnected ? "connected" : "disconnected"));
//        } catch (Exception e) {
//            log.error("Failed to check MQTT connection status", e);
//            return ResponseEntity.internalServerError().body("Failed to check connection status: " + e.getMessage());
//        }
//    }
//}
package a102.PickingParking.controller;

import a102.PickingParking.config.MQTTConfig;
import a102.PickingParking.entity.ZoneStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/mqtt")  // API 경로 구조화
@Slf4j  // 로깅 추가
public class MqttController {
    private final MQTTConfig mqttConfig;

    public MqttController(MQTTConfig mqttConfig) {
        this.mqttConfig = mqttConfig;
    }

    @GetMapping("/publish")
    public ResponseEntity<String> publishMessage(@RequestParam(defaultValue = "mqtt_test") String topic,
                                                 @RequestParam String message) {
        try {
            mqttConfig.publishMessage(topic, message);
            log.info("Successfully published message to topic: {}", topic);
            return ResponseEntity.ok("Message published successfully!");
        } catch (Exception e) {
            log.error("Failed to publish message to topic: {}", topic, e);
            return ResponseEntity.internalServerError().body("Failed to publish message: " + e.getMessage());
        }
    }

    // 추가 엔드포인트: 연결 상태 확인
    @GetMapping("/status")
    public ResponseEntity<String> checkConnectionStatus() {
        try {
            boolean isConnected = mqttConfig.isConnected(); // MQTTConfig에 이 메서드 추가 필요
            return ResponseEntity.ok("MQTT Client is " + (isConnected ? "connected" : "disconnected"));
        } catch (Exception e) {
            log.error("Failed to check MQTT connection status", e);
            return ResponseEntity.internalServerError().body("Failed to check connection status: " + e.getMessage());
        }
    }

    // 새로운 엔드포인트: ZoneStatus 발행
    @PostMapping("/publish_zone_status")
    public ResponseEntity<String> publishZoneStatus(@RequestBody ZoneStatus zoneStatus) {
        try {
            String message = zoneStatus.name();  // ZoneStatus enum 값을 문자열로 변환
            String topic = "mqtt_test";  // 여기에서 topic을 지정하거나, 클라이언트가 보내는 데이터로 받을 수 있습니다
    
            mqttConfig.publishMessage(topic, message);  // 메시지를 특정 topic에 발행
            log.info("Successfully published ZoneStatus: {}", message);
            return ResponseEntity.ok("ZoneStatus published successfully: " + zoneStatus.name());
        } catch (Exception e) {
            log.error("Failed to publish ZoneStatus: {}", zoneStatus.name(), e);
            return ResponseEntity.internalServerError().body("Failed to publish ZoneStatus: " + e.getMessage());
        }
    }
}
