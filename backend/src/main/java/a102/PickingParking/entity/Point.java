package a102.PickingParking.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Point {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name = "point_seq")
    private Integer seq;

    @ManyToOne(fetch = FetchType.LAZY,optional = false)
    @JoinColumn(nullable = false, columnDefinition = "INT UNSIGNED", name = "user_seq")
    private User user;

    @Column(name= "point_source")
    @Enumerated(EnumType.STRING)
    private PointSource source; // PAYMENT, CHARGE

    @Column(nullable = false, name = "point_price")
    private Integer price; // 양수 : 충전|수익 , 음수 : 출금|지출
}