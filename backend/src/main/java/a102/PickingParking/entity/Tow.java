package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Tow {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "tow_seq")
    private Integer seq;

    @Column(nullable = false, length = 20, name = "car_id")
    private String carId;

    @Column(nullable = false, name = "start_time")
    private LocalDateTime startTime;

    @Column(nullable = false, name = "isreport")
    private Boolean isReport;

    @Column(name = "report_time")
    private LocalDateTime reportTime;

    @ManyToOne(optional = false)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "zone_seq")
    private ParkingZone zone;
}