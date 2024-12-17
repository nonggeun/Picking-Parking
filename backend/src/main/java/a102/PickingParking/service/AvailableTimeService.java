package a102.PickingParking.service;


import a102.PickingParking.dto.AvailableTimeResponse;
import a102.PickingParking.dto.ReservationRequest;
import a102.PickingParking.entity.AvailableTime;
import a102.PickingParking.entity.ParkingZone;
import a102.PickingParking.repository.AvailableTimeRepository;
import a102.PickingParking.repository.ParkingZoneRepository;
import a102.PickingParking.repository.ReservationRepository;
import a102.PickingParking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AvailableTimeService {

    private final AvailableTimeRepository availableTimeRepository;
    private final ParkingZoneRepository parkingZoneRepository;

    @Autowired
    public AvailableTimeService(AvailableTimeRepository availableTimeRepository, ParkingZoneRepository parkingZoneRepository) {
        this.availableTimeRepository = availableTimeRepository;
        this.parkingZoneRepository = parkingZoneRepository;

    }

    // 특정 주차장의 예약 가능 시간 조회
    public List<AvailableTimeResponse> getAllAvailableTimes(Integer zoneSeq) {
        List<AvailableTime> availableTimes = availableTimeRepository.findByParkingZoneSeq(zoneSeq);
        return availableTimes.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    // AvailableTimeResponse 객체로 변환
    private AvailableTimeResponse convertToResponse(AvailableTime availableTime) {
        AvailableTimeResponse response = new AvailableTimeResponse();
        response.setSeq(availableTime.getSeq());
        response.setStartTime(availableTime.getStartTime());
        response.setEndTime(availableTime.getEndTime());
        return response;
    }

    public void updateTimes(Integer zoneSeq, ReservationRequest request) {
        // 주차장 정보 조회
        ParkingZone parkingZone = parkingZoneRepository.findById(zoneSeq)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장입니다."));

        // 예약 시간
        LocalDateTime newStartTime = request.getStartTime();
        LocalDateTime newEndTime = request.getEndTime();

        // 해당 주차장의 예약 가능 시간 조회
        List<AvailableTime> availableTimes = availableTimeRepository.findByParkingZoneSeq(zoneSeq);

        // 예약 처리 로직
        for (AvailableTime availableTime : availableTimes) {
            LocalDateTime availableStart  = availableTime.getStartTime();
            LocalDateTime availableEnd = availableTime.getEndTime();

            // 예약 시간이 포함되는 경우
            if (newStartTime.isBefore(availableEnd) && newEndTime.isAfter(availableStart)) {
                // 예약 시간과 기존 시간을 비교하여 남은 시간을 업데이트
                if (newStartTime.isAfter(availableStart) && newEndTime.isBefore(availableEnd)) {
                    // 예약 시간이 기존 시간의 중간에 위치한 경우
                    availableTime.setEndTime(newStartTime); // 이전 시간의 끝을 새 시작 시간으로 설정
                    availableTimeRepository.save(availableTime); // 업데이트
                    availableTimeRepository.save(new AvailableTime(null, parkingZone, newEndTime, availableEnd)); // 새로 남은 시간 추가
                } else if (newStartTime.isEqual(availableStart)) {
                    // 예약 시작 시간이 기존 시간의 시작과 같은 경우
                    availableTime.setStartTime(newEndTime); // 시작 시간을 예약 종료 시간으로 설정
                    availableTimeRepository.save(availableTime); // 업데이트
                } else if (newEndTime.isEqual(availableEnd)) {
                    // 예약 종료 시간이 기존 시간의 종료와 같은 경우
                    availableTime.setEndTime(newStartTime); // 종료 시간을 예약 시작 시간으로 설정
                    availableTimeRepository.save(availableTime); // 업데이트
                } else if (newStartTime.isBefore(availableStart) && newEndTime.isAfter(availableEnd)) {
                    // 예약 시간이 기존 시간의 범위를 완전히 포함하는 경우
                    availableTimeRepository.delete(availableTime); // 기존 시간 삭제
                }
            }
        }
    }
}
