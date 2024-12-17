package a102.PickingParking.repository;

import a102.PickingParking.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PointRepository extends JpaRepository<Point, Integer> {

    @Query("SELECT SUM(p.price) FROM Point p WHERE p.user.userId = ?1")
    Integer sumPointByUserId(String userId);
}
