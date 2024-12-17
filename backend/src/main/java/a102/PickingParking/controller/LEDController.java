//package a102.PickingParking.controller;
//
//import a102.PickingParking.service.MQTTService;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import java.util.*;
//
//
//@RestController
//@RequestMapping("/api/led") // todo 이거 매핑 내가 임의로 해놓은거임. 승우야 수정 부탁
//public class LEDController {
//    private final MQTTService mqttService;
//
//    public LEDController(MQTTService mqttService) {
//        this.mqttService = mqttService;
//        // mqttclient 만들 때 아예 OCR 구독하도록 설정함
//        mqttService.subscribeToOCR();
//    }
//
//    // POST 요청 처리 메서드
//    @PostMapping("/control")
//    public ResponseEntity<String> controlLED(@RequestParam String color){
//        // color 파라미터가 R G Y 중 하나인지 검사
//        if(!Arrays.asList("R","G","Y").contains(color)){
//            // 잘못된 색상이면 400 에러 응답
//            return ResponseEntity.badRequest().body("잘못된 색상");
//        }
//
//        // MQTT로  LED 제어 메세지 발행하기
//        mqttService.publishLEDControl(color);
//        // 성공 응답 반환
//        return ResponseEntity.ok("LED 제어 메세지 전송됨 : "+color);
//    }
//}
