package a102.PickingParking.dto;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserSignupRequestDto {
    private String user_id;
    private String user_pw;
    private String user_phone;

    // 필드 초기화를 위한 생성자 추가
    public UserSignupRequestDto(String user_id, String user_pw, String user_phone) {
        this.user_id = user_id;
        this.user_pw = user_pw;
        this.user_phone = user_phone;
    }
}