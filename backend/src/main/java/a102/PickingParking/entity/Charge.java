package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Charge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "charge_seq")
    private Integer seq;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "user_seq")
    private User user;

    @Column(nullable = false, name = "charge_price")
    private Integer price;  // 양수:충전, 음수:출금

    @Column(nullable = false, name = "charge_time")
    private LocalDateTime time;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "point_seq")
    private Point point;
}