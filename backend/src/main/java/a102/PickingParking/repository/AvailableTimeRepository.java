package a102.PickingParking.repository;

import a102.PickingParking.entity.AvailableTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AvailableTimeRepository extends JpaRepository<AvailableTime, Integer> {
    List<AvailableTime> findByParkingZoneSeq(Integer parkingZoneSeq);
}
