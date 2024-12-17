package a102.PickingParking.service;

import a102.PickingParking.entity.Car;
import a102.PickingParking.entity.User;
import a102.PickingParking.repository.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CarService {

    @Autowired
    private CarRepository carRepository;

    @Autowired
    private UserService userService; // UserService 주입

    // 차량 등록
    public Car registerCar(String userId, Car car) {
        User user = userService.getUserByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        car.setUser(user); // 차량에 사용자 정보 설정
        return carRepository.save(car);
    }

    // userId로 차량 목록 조회
    public List<Car> getCarsByUser(String userId) {
        User user = userService.getUserByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다.")); // Optional 처리
        return carRepository.findByUser_Seq((user.getSeq()));
    }

    // 차량 상세 조회
    public Car getCarById(String userId, Integer carId) {
        User user = userService.getUserByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다.")); // User 객체 가져오기
        List<Car> cars = getCarsByUser(userId); // 사용자 ID로 차량 목록 조회

        // 사용자의 차량 목록에서 carId에 해당하는 차량 찾기
        return cars.stream()
                .filter(car -> car.getSeq().equals(carId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("차량을 찾을 수 없습니다."));

//        Car car = carRepository.findCarBy(carId)
//                .orElseThrow(() -> new IllegalArgumentException("차량을 찾을 수 없습니다."));
    }
}

//    // 차량 정보 수정
//    public Car updateCar(Integer carId, Car updatedCar) {
//        Car car = getCarById(updatedCar.getUserSeq().toString(), carId); // userSeq 필요
//        car.setPlate(updatedCar.getPlate());
//        car.setSubmitImage(updatedCar.getSubmitImage());
//        return carRepository.save(car);
//    }
//
//    // 차량 삭제
//    public void deleteCar(Integer carId) {
//        Car car = getCarById(carId.toString(), carId); // userSeq 필요
//        carRepository.delete(car);
//    }
