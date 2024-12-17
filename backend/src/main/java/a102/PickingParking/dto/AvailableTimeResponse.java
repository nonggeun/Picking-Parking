package a102.PickingParking.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AvailableTimeResponse {
    private Integer seq;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
}
