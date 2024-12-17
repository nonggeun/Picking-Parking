package a102.PickingParking.service;


import a102.PickingParking.dto.VehicleValidationResponse;
import a102.PickingParking.entity.Car;
import a102.PickingParking.entity.Reservation;
import a102.PickingParking.repository.CarRepository;
import a102.PickingParking.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class VehicleValidationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private CarRepository carRepository; // CarRepository 추가

    public Boolean validateVehicle(String licensePlate, Integer zoneSeq) {
        LocalDateTime currentTime = LocalDateTime.now(); // 현재 시간 가져오기

        // 현재 시간에 해당하는 예약 목록 조회
        List<Reservation> activeReservations = reservationRepository.findActiveReservations(currentTime, zoneSeq);

        for (Reservation reservation : activeReservations) {
            // 해당 예약의 user_seq로 차량 조회
            List<Car> cars = carRepository.findByUser_Seq(reservation.getUser().getSeq());

            // 차량 번호판 비교
            if (cars.stream().anyMatch(car -> car.getPlate().equals(licensePlate))) {
                return true; // 매칭됨
            }
        }

        return false; // 매칭되지 않음
    }



//    @Autowired
//    public VehicleValidationService(ReservationRepository reservationRepository) {
//        this.reservationRepository = reservationRepository;
//    }
//
//    public VehicleValidationResponse validateVehicle(String licensePlate) {
//        Optional<Reservation> reservation = reservationRepository.findByCarPlate(licensePlate);
//
//        VehicleValidationResponse response = new VehicleValidationResponse();
//        response.setLicensePlate(licensePlate);
//        response.setIsMatched(reservation.isPresent());
//
//        return response;
//    }
}
