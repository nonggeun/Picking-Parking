package a102.PickingParking.repository;

import a102.PickingParking.entity.AvailableTime;
import a102.PickingParking.entity.ParkingZone;
import a102.PickingParking.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    List<Reservation> findByZone(ParkingZone zone);
    @Query("SELECT r FROM Reservation r WHERE r.user.userId = :userId")
    List<Reservation> findByUserId(@Param("userId") String userId); // 사용자 ID로 예약 목록 조회

//    @Query("SELECT r FROM Reservation r JOIN Car c ON r.user.seq = c.user.seq WHERE c.plate = :licensePlate") // car 테이블과 JOIN하여 차량 번호 확인
//    Optional<Reservation> findByCarPlate(@Param("licensePlate") String licensePlate);
    @Query("SELECT r FROM Reservation r WHERE r.startTime <= :currentTime AND r.endTime >= :currentTime AND r.zone.seq = :zoneSeq")
    List<Reservation> findActiveReservations(@Param("currentTime") LocalDateTime currentTime, @Param("zoneSeq") Integer zoneSeq);
}
