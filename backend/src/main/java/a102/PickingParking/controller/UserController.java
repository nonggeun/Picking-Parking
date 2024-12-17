package a102.PickingParking.controller;

import a102.PickingParking.dto.UserIdDto;
import a102.PickingParking.dto.UserRequestDto;
import a102.PickingParking.dto.UserSignupRequestDto;
import a102.PickingParking.entity.User;
import a102.PickingParking.service.PointService;
import a102.PickingParking.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/user")
@Tag(name = "인증/인가 API", description = "인증/인가 관련 API")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final PointService pointService;


    @PostMapping("/signup")
    @Operation(summary = "회원가입")
    public ResponseEntity<String> signupUser(@RequestBody UserSignupRequestDto userSignupRequestDto) {
        try {
            userService.signupUser(userSignupRequestDto.getUser_id(),
                    userSignupRequestDto.getUser_pw(),
                    userSignupRequestDto.getUser_phone());
            return ResponseEntity.ok("회원가입이 완료되었습니다.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // 로그인 API
    // @RequestParam String username, @RequestParam String password
    @Operation(summary = "로그인")
    @PostMapping("/login")
    public ResponseEntity<Map<String,String>> loginUser(@RequestBody UserRequestDto userRequestDto) {
        try {
            Map<String,String> response = userService.loginUser(userRequestDto.getUser_id(),userRequestDto.getUser_pw());
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", e.getMessage()));
        }
    }

    @PostMapping("/delete")
    @Operation(summary = "회원 탈퇴")
    public ResponseEntity<String> deleteUser(@RequestBody UserIdDto userIdDto) {
        try {
            userService.deleteUser(userIdDto.getUserId());
            return ResponseEntity.ok("회원 탈퇴가 완료되었습니다.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    // 사용자 포인트 조회
    @Operation(summary = "특정 유저의 포인트 조회")
    @GetMapping("/{userId}/point")
    public ResponseEntity<Integer> getUserPoint(@PathVariable String userId) {
        User user = userService.getUserByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException(("존재하지 않는 사용자입니다.")));
        pointService.updateUserPoint(userId);
        return ResponseEntity.ok(user.getPoint());
    }
}
// 회원가입 API
//    @PostMapping("/signup")
//    public ResponseEntity<String> signupUser(@RequestParam String username,
//                                             @RequestParam String password,
//                                             @RequestParam String phoneNumber) {
//        try {
//            userService.signupUser(username, password, phoneNumber);
//            return ResponseEntity.ok("회원가입이 완료되었습니다.");
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
//        }
//    }