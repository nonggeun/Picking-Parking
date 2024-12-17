package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "notification_seq")
    private Integer seq;

    @Column(length = 100)
    private String title;

    @Column(length = 10000)
    private String content;

    @Column(nullable = false, length = 100)
    @Enumerated(EnumType.STRING)
    private NotificationType type; // app, push

    @Column(name = "isread")
    private Boolean isRead;

    @Column(name = "created_at")
    @Builder.Default
    private LocalDateTime createdDate = LocalDateTime.now();

    @ManyToOne(optional = false)
    @JoinColumn(nullable = false, columnDefinition  = "INT UNSIGNED", name = "user_seq")
    private User user;

    @ManyToOne()
    @JoinColumn(columnDefinition  = "INT UNSIGNED", name = "zone_seq")
    private ParkingZone zone;

    @ManyToOne()
    @JoinColumn(columnDefinition  = "INT UNSIGNED", name = "tow_seq")
    private Tow tow;

    @ManyToOne()
    @JoinColumn(columnDefinition  = "INT UNSIGNED", name = "reservation_seq")
    private Reservation reservation;

    @ManyToOne()
    @JoinColumn(columnDefinition  = "INT UNSIGNED", name = "immediate_seq")
    private Immediate immediate;

    @ManyToOne()
    @JoinColumn(columnDefinition  = "INT UNSIGNED", name = "point_seq")
    private Point point;
}