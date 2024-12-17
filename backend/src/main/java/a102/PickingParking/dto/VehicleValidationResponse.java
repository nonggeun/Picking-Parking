package a102.PickingParking.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class VehicleValidationResponse {
    private Boolean isMatched;
    private String licensePlate;
    private Integer zoneSeq;
}
