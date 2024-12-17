package a102.PickingParking.dto;

import a102.PickingParking.entity.PointSource;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PointRequestDto {
    private String userId;
    private int price;
    private PointSource source;

    public PointRequestDto(String userId, int price, PointSource source) {
        this.userId = userId;
        this.price = price;
        this.source = source;
    }

}
