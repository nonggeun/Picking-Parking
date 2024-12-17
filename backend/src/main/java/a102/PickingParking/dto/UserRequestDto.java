package a102.PickingParking.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRequestDto {
    private String user_id;
    private String user_pw;

    public UserRequestDto(String user_id, String user_pw) {
        this.user_id = user_id;
        this.user_pw = user_pw;
    }
}