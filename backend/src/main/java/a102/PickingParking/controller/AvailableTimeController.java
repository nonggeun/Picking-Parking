package a102.PickingParking.controller;


import a102.PickingParking.dto.AvailableTimeResponse;
import a102.PickingParking.service.AvailableTimeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/time")
@Tag(name = "이용시간 API", description = "이용시간 관련 API")
public class AvailableTimeController {

    private final AvailableTimeService availableTimeService;

    @Autowired
    public AvailableTimeController(AvailableTimeService availableTimeService) {
        this.availableTimeService = availableTimeService;
    }

    // 특정 주차장의 예약 가능 시간 조회
    @Operation(summary = "특정 주차장의 예약 가능 시간 조회")
    @GetMapping("/available/{zoneSeq}")
    public ResponseEntity<List<AvailableTimeResponse>> getAvailableTime(@PathVariable Integer zoneSeq) {
        List<AvailableTimeResponse> availableTimes = availableTimeService.getAllAvailableTimes(zoneSeq);
        return ResponseEntity.ok(availableTimes);
    }
}
