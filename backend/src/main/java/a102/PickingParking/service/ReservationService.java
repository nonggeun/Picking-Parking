package a102.PickingParking.service;

import a102.PickingParking.dto.ReservationRequest;
import a102.PickingParking.dto.ReservationResponse;
import a102.PickingParking.entity.*;
import a102.PickingParking.repository.AvailableTimeRepository;
import a102.PickingParking.repository.ParkingZoneRepository;
import a102.PickingParking.repository.ReservationRepository;
import a102.PickingParking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final AvailableTimeService availableTimeService;
    private final ParkingZoneRepository parkingZoneRepository;
    private final UserRepository userRepository;

    @Autowired
    public ReservationService(ReservationRepository reservationRepository,
                              AvailableTimeService availableTimeService,
                              ParkingZoneRepository parkingZoneRepository,
                              UserRepository userRepository) {
        this.reservationRepository = reservationRepository;
        this.availableTimeService = availableTimeService;
        this.parkingZoneRepository = parkingZoneRepository;
        this.userRepository = userRepository;
    }

    // 예약 처리
    public void createReservation(Integer zoneSeq, ReservationRequest request, String userId) {
        // 주차장 정보 조회
        ParkingZone parkingZone = parkingZoneRepository.findById(zoneSeq)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장입니다."));

        // 사용자 정보 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

//        // payment_seq가 4인 결제 정보 조회
//        Payment payment = new Payment();
//        payment.setSeq(4); // 고정된 payment_seq 설정

        // 예약 생성
        Reservation reservation = new Reservation();
        reservation.setStartTime(request.getStartTime());
        reservation.setEndTime(request.getEndTime());
        reservation.setZone(parkingZone);
        reservation.setUser(user);
//        reservation.setPayment(payment);
        reservation.setStatus(ReservationStatus.RESERVATION); // 예약 상태 설정

        // 예약 저장
        reservationRepository.save(reservation);

        // 예약 가능한 시간 업데이트
        availableTimeService.updateTimes(zoneSeq, request);

    }

    // 특정 주차장 예약 목록 조회
    public List<ReservationResponse> getReservationsByZoneSeq(Integer zoneSeq) {
        ParkingZone parkingZone = parkingZoneRepository.findBySeq(zoneSeq)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장입니다."));

        List<Reservation> reservations = reservationRepository.findByZone(parkingZone);
        return reservations.stream().map(this::convertToResponse).collect(Collectors.toList());
    }

    // 사용자 ID로 예약 목록 조회
    public List<ReservationResponse> getReservationsByUserId(String userId) {
        List<Reservation> reservations = reservationRepository.findByUserId(userId);
        return reservations.stream().map(this::convertToResponse).collect(Collectors.toList());
    }

    private ReservationResponse convertToResponse(Reservation reservation) {
        ReservationResponse response = new ReservationResponse();
        response.setSeq(reservation.getSeq());
        response.setStartTime(reservation.getStartTime());
        response.setEndTime(reservation.getEndTime());
        response.setStatus(reservation.getStatus());
        response.setZoneSeq(reservation.getZone().getSeq());
        return response;
    }

}
