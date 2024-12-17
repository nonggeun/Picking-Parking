package a102.PickingParking.controller;

import a102.PickingParking.repository.ParkingZoneRepository;
import a102.PickingParking.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Component
public class ZoneStatusUpdater {
    @Autowired
    private ParkingZoneRepository parkingZoneRepository;

    @Scheduled(fixedRate = 60000) // 1분마다 실행
    @Transactional
    public void updateZoneStatus() {
        // 모든 주차장에 대해 상태 업데이트
        parkingZoneRepository.findAll().forEach(parkingZone -> {
            parkingZoneRepository.updateZoneStatusByZoneSeq(parkingZone.getSeq());
        });
    }


    @Scheduled(fixedRate = 60000) // 1분마다 실행
    @Transactional
    public void updateZoneStatusBeforeReservation() {
        LocalDateTime oneHourLater = LocalDateTime.now().plusHours(1);
        parkingZoneRepository.updateZoneStatusBeforeReservation(oneHourLater);
    }

    @Scheduled(fixedRate = 60000) // 1분마다 실행
    @Transactional
    public void updateZoneStatusDuringReservation() {
        parkingZoneRepository.updateZoneStatusDuringReservation();
    }
}
