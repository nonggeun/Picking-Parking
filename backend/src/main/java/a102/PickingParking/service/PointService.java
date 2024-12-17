package a102.PickingParking.service;

import a102.PickingParking.dto.PointRequestDto;
import a102.PickingParking.entity.Point;
import a102.PickingParking.entity.PointSource;
import a102.PickingParking.entity.User;
import a102.PickingParking.repository.PointRepository;
import a102.PickingParking.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PointService {

    private final UserRepository userRepository;

    private final PointRepository pointRepository;

    @Autowired
    public PointService(PointRepository pointRepository, UserRepository userRepository) {
        this.userRepository = userRepository;
        this.pointRepository = pointRepository;
    }

    // 사용자 ID로 현재 포인트 조회
    public void updateUserPoint(String userId) {

        Integer totalPoint = pointRepository.sumPointByUserId(userId);
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new IllegalArgumentException("사용자가 존재하지 않습니다."));

        if (totalPoint != null) {
            user.setPoint(totalPoint);
            userRepository.save(user);
        };


        // 현재 포인트 반환
    }
    // 포인트 충전과 사용



    public void pointRequest(PointRequestDto request) {

        String userId = request.getUserId();
        int price = request.getPrice();
        String source = request.getSource().name();

        // user_id로 user_seq 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 포인트 충전 및 인출 처리
        if ("CHARGE".equals(source)) {
            if (price > 0) {
                // 포인트 충전
                Point point = new Point();
                point.setUser(user);
                point.setPrice(price); // 충전은 양수로 기록
                point.setSource(PointSource.CHARGE); // 거래 유형 설정
                pointRepository.save(point); // 포인트 기록 저장
            } else {
                // 포인트 인출
                if (user.getPoint() < -price) {
                    throw new IllegalArgumentException("인출할 포인트가 부족합니다.");
                }
                Point point = new Point();
                point.setUser(user);
                point.setPrice(price); // 인출은 음수로 기록
                point.setSource(PointSource.CHARGE); // 거래 유형 설정 (인출도 CHARGE로 처리)
                pointRepository.save(point); // 포인트 기록 저장
            }
        }
        // 포인트 사용 및 수익 처리
        else if ("PAYMENT".equals(source)) {
            if (price > 0) {
                // 포인트 수익
                Point point = new Point();
                point.setUser(user);
                point.setPrice(price); // 수익은 양수로 기록
                point.setSource(PointSource.PAYMENT); // 거래 유형 설정
                pointRepository.save(point); // 포인트 기록 저장
            } else {
                // 포인트 지출
                if (user.getPoint() < -price) {
                    throw new IllegalArgumentException("지출할 포인트가 부족합니다.");
                }
                Point point = new Point();
                point.setUser(user);
                point.setPrice(price); // 지출은 음수로 기록
                point.setSource(PointSource.PAYMENT); // 거래 유형 설정
                pointRepository.save(point); // 포인트 기록 저장
            }
        } else {
            throw new IllegalArgumentException("유효하지 않은 거래 유형입니다.");
        }
        updateUserPoint(userId);
    }
}
