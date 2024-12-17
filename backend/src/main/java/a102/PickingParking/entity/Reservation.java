package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "reservation_seq")
    private Integer seq;

    @Column(nullable = false, name = "start_time")
    private LocalDateTime startTime;

    @Column(nullable = false, name = "end_time")
    private LocalDateTime endTime;

//    @OneToOne(fetch = FetchType.LAZY, optional = false)
//    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "payment_seq")
//    private Payment payment;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "zone_seq")
    private ParkingZone zone;

    @ManyToOne(optional = false,fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "user_seq")
    private User user;

    @Column(name= "reservation_status")
    @Enumerated(EnumType.STRING)
    private ReservationStatus status; // REFUND, RESERVATION, ONGOING, FINISH
}