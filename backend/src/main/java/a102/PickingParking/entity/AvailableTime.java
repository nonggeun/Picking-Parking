package a102.PickingParking.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "available_time")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AvailableTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name = "time_seq")
    private Integer seq;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parking_zone_seq")
    private ParkingZone parkingZone;

    //
    private LocalDateTime startTime;
    private LocalDateTime endTime;
}
