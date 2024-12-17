package a102.PickingParking.repository;

import a102.PickingParking.entity.Car;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CarRepository extends JpaRepository<Car, Integer> {
    List<Car> findByUser_Seq(Integer userSeq);
}
