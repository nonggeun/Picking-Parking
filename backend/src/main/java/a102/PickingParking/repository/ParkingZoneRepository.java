package a102.PickingParking.repository;

import a102.PickingParking.entity.ParkingZone;
import a102.PickingParking.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface ParkingZoneRepository extends JpaRepository<ParkingZone, Integer> {
    // 주차장 이름으로 주차장 조회
    Optional<ParkingZone> findByPrkCmpr(String prk_cmpr);
    List<ParkingZone> findByUser(User user);
    Optional<ParkingZone> findBySeq(Integer seq);

    @Modifying
    @Query(value = "UPDATE parking_zone p SET p.zone_status = " +
            "CASE " +
            "WHEN EXISTS (SELECT 1 FROM reservation r WHERE r.zone_seq = p.zone_seq AND r.start_time <= CURRENT_TIMESTAMP AND r.end_time >= CURRENT_TIMESTAMP) THEN 'R' " + // 현재 진행 중
            "WHEN EXISTS (SELECT 1 FROM reservation r WHERE r.zone_seq = p.zone_seq AND r.start_time BETWEEN CURRENT_TIMESTAMP AND DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR)) THEN 'Y' " + // 1시간 이내
            "ELSE 'B' " + // 기본 상태
            "END " +
            "WHERE p.zone_seq = :zoneSeq", nativeQuery = true)
    void updateZoneStatusByZoneSeq(@Param("zoneSeq") Integer zoneSeq);

//    @Modifying
//    @Query("UPDATE ParkingZone p SET p.status = 'Y' WHERE p.seq IN " +
//            "(SELECT r.zone.seq FROM Reservation r WHERE r.startTime < :oneHourLater AND r.status = 'RESERVATION')")
//    void updateZoneStatusBeforeReservation(@Param("oneHourLater") LocalDateTime oneHourLater);
//
//    @Modifying
//    @Query("UPDATE ParkingZone p SET p.status = 'R' WHERE p.seq IN " +
//            "(SELECT r.zone.seq FROM Reservation r WHERE r.startTime <= CURRENT_TIMESTAMP AND r.endTime >= CURRENT_TIMESTAMP AND r.status = 'RESERVATION')")
//    void updateZoneStatusDuringReservation();


    @Modifying
    @Query("UPDATE ParkingZone p SET p.status = 'Y' " +
            "WHERE p.status = 'B' " +
            "AND EXISTS (" +
            "   SELECT 1 FROM Reservation r " +
            "   WHERE r.zone.seq = p.seq " + // zone을 통해 zoneSeq에 접근
            "    AND r.startTime = :oneHourLater" +
            ")")
    void updateZoneStatusBeforeReservation(LocalDateTime oneHourLater);

    @Modifying
    @Query("UPDATE ParkingZone p SET p.status = 'R' " +
            "WHERE p.status = 'Y' " +
            "AND EXISTS (" +
            "   SELECT 1 FROM Reservation r " +
            "   WHERE r.zone.seq = p.seq " +
            "    AND CURRENT_TIMESTAMP BETWEEN r.startTime AND r.endTime" +
            ")")
    void updateZoneStatusDuringReservation();
}
