package a102.PickingParking.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import org.aspectj.bridge.Message;

public class LicensePlateResponse {

    @JsonProperty("zone_seq")
    private int zoneSeq;

    @JsonProperty("result")
    private String result;

    // Getters and Setters
    public int getZoneSeq() {
        return zoneSeq;
    }

    public void setZoneSeq(int zoneSeq) {
        this.zoneSeq = zoneSeq;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}


//@Getter
//@Setter
//public class LicensePlateResponse {
//    private Message message;
//
//    @Getter
//    @Setter
//    public static class Message {
//        private Integer zone_seq;
//        private String result;
//
//    }
//}