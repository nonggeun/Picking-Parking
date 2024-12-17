package a102.PickingParking.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(columnDefinition = "INT UNSIGNED", name= "car_seq")
    private Integer seq;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(nullable = false, columnDefinition  = "INT UNSIGNED", name = "user_seq")
    @JsonIgnore
    private User user;

    @Column(nullable = false, unique = true, length = 20, name= "car_plate")
    private String plate;

    @Column(length = 1000, name = "car_submit_image")
    private String submitImage;

}