package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "payment_seq")
    private Integer seq;

    @Column(nullable = false, name = "total_price")
    private Integer price;

    @ManyToOne(optional = false,fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, columnDefinition  = "INT UNSIGNED", name = "zone_seq")
    private ParkingZone zone;

    @Column(nullable = false, name = "payment_time")
    private LocalDateTime time;

//    @ManyToOne(optional = false, fetch = FetchType.LAZY)
//    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "point_seq")
//    private Point point;

    @Column(name = "payment_source")
    @Enumerated(EnumType.STRING)
    private PaymentSource source; // IMMEDIATE, RESERVATION

}