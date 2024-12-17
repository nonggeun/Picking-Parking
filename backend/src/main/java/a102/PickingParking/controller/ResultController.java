package a102.PickingParking.controller;

import a102.PickingParking.dto.VehicleValidationResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.concurrent.CopyOnWriteArrayList;

@RestController
@Tag(name = "하드웨어 통신 API", description = "하드웨어 관련 API")
@RequestMapping("/api/vehicle/validation")
public class ResultController {

//    private VehicleValidationResponse latestResponse;
//
//    @PostMapping("/response")
//    @Operation(summary = "자동차 번호판 결과")
//    public ResponseEntity<VehicleValidationResponse> getValidationResult() {
//        // 프론트엔드에서 결과를 요청할 때 이 메서드가 호출됨
//        if (latestResponse != null) {
//            return ResponseEntity.ok(latestResponse);
//        } else {
//            return ResponseEntity.noContent().build(); // 결과가 없을 경우 204 No Content 반환
//        }
//    }
//
//    // MQTTConfig에서 호출하는 메서드
//    public void updateValidationResult(VehicleValidationResponse response) {
//        this.latestResponse = response;
//    }
    private static final Long DEFAULT_TIMEOUT = 60L * 1000; // 1분
    private final CopyOnWriteArrayList<SseEmitter> emitters = new CopyOnWriteArrayList<>();

    @GetMapping(value = "/response", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamValidationResults() {
        SseEmitter emitter = new SseEmitter(DEFAULT_TIMEOUT);

        // 클라이언트 연결 시 emitters에 추가
        emitters.add(emitter);

        // 클라이언트가 연결을 끊을 때 emitters에서 제거
        emitter.onCompletion(() -> emitters.remove(emitter));
        emitter.onTimeout(() -> emitters.remove(emitter));

        return emitter;
    }

    // MQTTConfig에서 호출하는 메서드
    public void updateValidationResult(VehicleValidationResponse response) {
        for (SseEmitter emitter : emitters) {
            try {
                emitter.send(response); // 연결된 클라이언트에게 데이터 전송
            } catch (IOException e) {
                emitters.remove(emitter); // 전송 실패 시 emitter 제거
            }
        }
    }
}
