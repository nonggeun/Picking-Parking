package a102.PickingParking.dto;

import a102.PickingParking.entity.ReservationStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class ReservationResponse {
    private Integer seq;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private ReservationStatus status; // 상태 추가
    private Integer zoneSeq;
}
