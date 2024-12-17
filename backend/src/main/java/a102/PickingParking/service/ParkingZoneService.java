package a102.PickingParking.service;


import a102.PickingParking.dto.ParkingZoneResponse;
import a102.PickingParking.dto.UserIdDto;
import a102.PickingParking.entity.ParkingZone;
import a102.PickingParking.entity.User;
import a102.PickingParking.entity.ZoneStatus;
import a102.PickingParking.repository.ParkingZoneRepository;
import a102.PickingParking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ParkingZoneService {

    private final ParkingZoneRepository parkingZoneRepository;
    private final UserRepository userRepository;

    @Autowired
    public ParkingZoneService(ParkingZoneRepository parkingZoneRepository, UserRepository userRepository) {
        this.parkingZoneRepository = parkingZoneRepository;
        this.userRepository = userRepository;
    }

    // 주차장 주인 등록
    public ParkingZoneResponse registerParkingUser(String userId, String prk_cmpr) {
        // 주차장 구획 번호로 주차장 조회
        ParkingZone parkingZone = parkingZoneRepository.findByPrkCmpr(prk_cmpr)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장 구획 번호입니다."));

        // 이미 주인이 있는 경우
        if (parkingZone.getUser() != null) {
            throw new IllegalArgumentException("이미 주인이 등록된 주차장입니다.");
        }

        // 주인 조회
        User parkingUser = userRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        parkingZone.setUser(parkingUser);
        parkingZone.setStatus(ZoneStatus.B);
        parkingZoneRepository.save(parkingZone);

        // 응답 DTO 생성
        ParkingZoneResponse response = new ParkingZoneResponse();
        response.setSeq(parkingZone.getSeq());
        response.setLocation(parkingZone.getLocation());
        response.setLatitude(parkingZone.getLatitude());
        response.setLongitude(parkingZone.getLongitude());
        response.setPrice(parkingZone.getPrice());
        response.setStatus(parkingZone.getStatus());
        response.setPrkCmpr(parkingZone.getPrkCmpr());

        // userId만 포함
        UserIdDto userResponse = new UserIdDto();
        userResponse.setUserId(parkingUser.getUserId()); // userId 설정
        response.setUser(userResponse); // UserResponse로 설정

        return response;

    }

    // 특정 주차장 정보 조회
    public ParkingZoneResponse getParkingZoneBySeq(Integer zoneSeq) {
        ParkingZone parkingZone = parkingZoneRepository.findById(zoneSeq)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장입니다."));

        // 응답 DTO 생성
        ParkingZoneResponse response = new ParkingZoneResponse();
        response.setSeq(parkingZone.getSeq());
        response.setLocation(parkingZone.getLocation());
        response.setLatitude(parkingZone.getLatitude());
        response.setLongitude(parkingZone.getLongitude());
        response.setPrice(parkingZone.getPrice());
        response.setStatus(parkingZone.getStatus());
        response.setPrkCmpr(parkingZone.getPrkCmpr());

        if (parkingZone.getUser() != null) {
            UserIdDto userResponse = new UserIdDto();
            userResponse.setUserId(parkingZone.getUser().getUserId()); // userId만 설정
            response.setUser(userResponse); // UserResponse로 설정
        } else {
            response.setUser(null);
        }

        return response;
    }

    // 특정 유저의 주차장 정보 조회
    public ParkingZoneResponse getParkingZoneByUserId(String userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));


        ParkingZone parkingZone = parkingZoneRepository.findByUser(user).stream().findFirst().orElse(null);
        return convertToResponse2(parkingZone);
    }

    // 모든 주차장 조회
    public List<ParkingZoneResponse> getAllParkingZones() {
        List<ParkingZone> allParkingZones = parkingZoneRepository.findAll();
        return allParkingZones.stream()
                .map(this::convertToResponse) // 응답 DTO로 변환
                .collect(Collectors.toList());
    }

    // 주차장 객체를 응답 DTO로 변환
    private ParkingZoneResponse convertToResponse(ParkingZone parkingZone) {
        ParkingZoneResponse response = new ParkingZoneResponse();
        response.setSeq(parkingZone.getSeq());
        response.setLocation(parkingZone.getLocation());
        response.setLatitude(parkingZone.getLatitude());
        response.setLongitude(parkingZone.getLongitude());
        response.setPrice(parkingZone.getPrice());
        response.setStatus(parkingZone.getStatus());
        response.setPrkCmpr(parkingZone.getPrkCmpr());

//        // User 정보 설정
//        if (parkingZone.getUser() != null) {
//            UserIdDto userResponse = new UserIdDto();
//            userResponse.setUserId(parkingZone.getUser().getUserId()); // userId만 설정
//            response.setUser(userResponse); // UserResponse로 s설정
//        } else {
//            response.setUser(null); // 주인이 없는 경우
//        }

        return response;
    }

    // 주차장 객체 1개를 응답 DTO로 변환
    public ParkingZoneResponse convertToResponse2(ParkingZone parkingZone) {
        if (parkingZone == null) {
            return null; // 또는 예외 처리
        }

        UserIdDto userResponse = new UserIdDto();
        userResponse.setUserId(parkingZone.getUser().getUserId());


        ParkingZoneResponse response = new ParkingZoneResponse();
        response.setSeq(parkingZone.getSeq());
        response.setLocation(parkingZone.getLocation());
        response.setLatitude(parkingZone.getLatitude());
        response.setLongitude(parkingZone.getLongitude());
        response.setPrice(parkingZone.getPrice());
        response.setStatus(parkingZone.getStatus());
        response.setPrkCmpr(parkingZone.getPrkCmpr());

        response.setUser(userResponse);


        return response;
    }

//    // 주차장 개방 시간 설정
//    public ParkingZone setOpenHours(Integer zoneId, String openTime, String closeTime) {
//        ParkingZone parkingZone = parkingZoneRepository.findById(zoneId)
//                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주차장입니다."));
//
//        parkingZone.setOpenTime(openTime); // openTime 필드 추가 필요
//        parkingZone.setCloseTime(closeTime); // closeTime 필드 추가 필요
//        return parkingZoneRepository.save(parkingZone);
//    }
}
