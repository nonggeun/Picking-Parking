package a102.PickingParking.dto;

import a102.PickingParking.entity.ZoneStatus;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class ParkingZoneResponse {
    private int seq;
    private String location;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Integer price;
    private ZoneStatus status;
    private String prkCmpr;
    private UserIdDto user;
}
