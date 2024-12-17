package a102.PickingParking.controller;

import a102.PickingParking.dto.ReservationRequest;
import a102.PickingParking.dto.ReservationResponse;
import a102.PickingParking.service.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservation")
@Tag(name = "예약 API", description = "예약 관련 API")
public class ReservationController {

    private final ReservationService reservationService;

    @Autowired
    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    // 예약 API
    @PostMapping()
    @Operation(summary = "예약 등록")
    public ResponseEntity<String> reserveTime(@RequestParam Integer zoneSeq,
                                              @RequestBody ReservationRequest request,
                                              @RequestParam String userId) {
        reservationService.createReservation(zoneSeq, request, userId);
        return ResponseEntity.ok("예약 완료");
    }

    // 특정 주차장의 예약 목록 조회
    @Operation(summary = "특정 주차장의 예약 목록 조회")
    @GetMapping("/zone/{zone_seq}")
    public ResponseEntity<List<ReservationResponse>> getReservationsByZoneSeq(@PathVariable Integer zone_seq) {
        List<ReservationResponse> reservations = reservationService.getReservationsByZoneSeq(zone_seq);
        return ResponseEntity.ok(reservations);
    }

    // 사용자 ID로 예약 목록 조회
    @Operation(summary = "사용자 ID로 예약 목록 조회")
    @GetMapping("/user/{user_id}")
    public ResponseEntity<List<ReservationResponse>> getReservationsByUserId(@PathVariable String user_id) {
        List<ReservationResponse> reservations = reservationService.getReservationsByUserId(user_id);
        return ResponseEntity.ok(reservations);
    }
}
