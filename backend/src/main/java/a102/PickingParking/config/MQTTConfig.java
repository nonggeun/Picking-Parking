//package a102.PickingParking.config;
//import io.github.cdimascio.dotenv.Dotenv;
//import lombok.extern.slf4j.Slf4j;
//import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
//import org.bouncycastle.openssl.PEMKeyPair;
//import org.bouncycastle.openssl.PEMParser;
//import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
//import org.eclipse.paho.client.mqttv3.*;
//import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
//import org.springframework.context.annotation.Configuration;
//import jakarta.annotation.PostConstruct;
//import jakarta.annotation.PreDestroy;
//
//import javax.net.ssl.KeyManagerFactory;
//import javax.net.ssl.SSLContext;
//import javax.net.ssl.SSLSocketFactory;
//import javax.net.ssl.TrustManagerFactory;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.StringReader;
//import java.nio.charset.StandardCharsets;
//import java.security.KeyStore;
//import java.security.PrivateKey;
//import java.security.cert.Certificate;
//import java.security.cert.CertificateFactory;
//import java.security.cert.X509Certificate;
//
//
//
//@Configuration
//@Slf4j
//public class MQTTConfig {
//    private MqttClient client;
//    private MqttConnectOptions options;
//    private final String topic = "mqtt_test";
//
//    private String loadResourceAsString(String resourcePath) throws IOException {
//        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(resourcePath)) {
//            if (inputStream == null) {
//                throw new IOException("Resource not found: " + resourcePath);
//            }
//            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
//        }
//    }
//
//    private InputStream loadResource(String resourcePath) throws IOException {
//        InputStream inputStream = getClass().getClassLoader().getResourceAsStream(resourcePath);
//        if (inputStream == null) {
//            throw new IOException("Resource not found: " + resourcePath);
//        }
//        return inputStream;
//    }
//
//    @PostConstruct
//    public void init() {
//        try {
//            Dotenv dotenv = Dotenv.load();
//            String broker = "ssl://" + dotenv.get("AWS_IOT_ENDPOINT") + ":8883";
//            String clientId = dotenv.get("AWS_CLIENT_ID");
//
//            // 인증서 리소스 로드
//            String certPath = "certs/certificate.pem.crt";
//            String keyPath = "certs/private.pem.key";
//            String caPath = "certs/AmazonRootCA1.pem";
//
//            log.info("Loading certificates...");
//
//            client = new MqttClient(broker, clientId, new MemoryPersistence());
//
//            options = new MqttConnectOptions();
//            options.setCleanSession(true);
//            options.setKeepAliveInterval(60);
//            options.setConnectionTimeout(30);
//
//            // SSL 설정
//            SSLSocketFactory socketFactory = getSSLSocketFactory(caPath, certPath, keyPath);
//            options.setSocketFactory(socketFactory);
//
//            // 연결 콜백
//            client.setCallback(new MqttCallback() {
//                @Override
//                public void connectionLost(Throwable cause) {
//                    log.error("Connection lost! Trying to reconnect...", cause);
//                    reconnect();
//                }
//
//                @Override
//                public void messageArrived(String topic, MqttMessage message) {
//                    log.info("Message received on topic {}: {}", topic, new String(message.getPayload()));
//                }
//
//                @Override
//                public void deliveryComplete(IMqttDeliveryToken token) {
//                    log.info("Message delivered");
//                }
//            });
//
//            connect(options);
//
//            // ==============test==========
//            if (client.isConnected()) {
//                String payload = "Hello from PickingParking!";
//                publishMessage(topic, payload);
//                log.info("Initial message published successfully");
//            } else {
//                log.warn("Client is not connected. Unable to publish initial message.");
//            }
//            //=====================================
//
//        } catch (Exception e) {
//            log.error("Failed to initialize MQTT client", e);
//            throw new RuntimeException("Failed to initialize MQTT client", e);
//        }
//    }
//
//    private SSLSocketFactory getSSLSocketFactory(String caPath, String certPath, String keyPath) throws Exception {
//        // CA 인증서 로드
//        CertificateFactory cf = CertificateFactory.getInstance("X.509");
//        X509Certificate caCert;
//        try (InputStream caInputStream = loadResource(caPath)) {
//            caCert = (X509Certificate) cf.generateCertificate(caInputStream);
//        }
//
//        // 클라이언트 인증서 로드
//        X509Certificate clientCert;
//        try (InputStream certInputStream = loadResource(certPath)) {
//            clientCert = (X509Certificate) cf.generateCertificate(certInputStream);
//        }
//
//        // 프라이빗 키 로드
//        PEMParser pemParser = new PEMParser(new StringReader(loadResourceAsString(keyPath)));
//        Object object = pemParser.readObject();
//        PrivateKey privateKey;
//
//        if (object instanceof PEMKeyPair) {
//            privateKey = new JcaPEMKeyConverter().getPrivateKey(((PEMKeyPair) object).getPrivateKeyInfo());
//        } else if (object instanceof PrivateKeyInfo) {
//            privateKey = new JcaPEMKeyConverter().getPrivateKey((PrivateKeyInfo) object);
//        } else {
//            throw new IllegalStateException("Unexpected key format");
//        }
//
//        // 키스토어 설정
//        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
//        keyStore.load(null);
//        keyStore.setCertificateEntry("ca-certificate", caCert);
//        keyStore.setKeyEntry("client-key", privateKey, new char[0], new Certificate[]{clientCert});
//
//        // SSL 컨텍스트 설정
//        KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
//        kmf.init(keyStore, new char[0]);
//
//        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
//        tmf.init(keyStore);
//
//        SSLContext context = SSLContext.getInstance("TLSv1.2");
//        context.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);
//
//        return context.getSocketFactory();
//    }
//
//    private void connect(MqttConnectOptions options) {
//        try {
//            if (client != null && !client.isConnected()) {
//                client.connect(options);
//                client.subscribe(topic);
//                log.info("Connected to AWS IoT Core");
//            }
//        } catch (MqttException e) {
//            log.error("Failed to connect to AWS IoT Core", e);
//        }
//    }
//
//    private void reconnect() {
//        try {
//            Thread.sleep(5000);  // 5초 대기
//            connect(options);
//        } catch (Exception e) {
//            log.error("Failed to reconnect to AWS IoT Core", e);
//        }
//    }
//
//    public void publishMessage(String topic, String payload) {
//        try {
//            if (client != null && client.isConnected()) {
//                MqttMessage message = new MqttMessage(payload.getBytes());
//                message.setQos(1);
//                client.publish(topic, message);
//                log.info("Published message to topic {}: {}", topic, payload);
//            }
//        } catch (MqttException e) {
//            log.error("Failed to publish message", e);
//        }
//    }
//
//    public boolean isConnected() {
//        return client != null && client.isConnected();
//    }
//
//    @PreDestroy
//    public void cleanup() {
//        try {
//            if (client != null && client.isConnected()) {
//                client.disconnect();
//                client.close();
//                log.info("MQTT client disconnected and cleaned up");
//            }
//        } catch (MqttException e) {
//            log.error("Failed to clean up MQTT client", e);
//        }
//    }
//}
package a102.PickingParking.config;

import a102.PickingParking.controller.ResultController;
import a102.PickingParking.dto.LicensePlateResponse;
import a102.PickingParking.dto.VehicleValidationResponse;
import a102.PickingParking.service.MqttMessageService;
import a102.PickingParking.service.VehicleValidationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.github.cdimascio.dotenv.Dotenv;
import lombok.extern.slf4j.Slf4j;
import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

@Configuration
@Slf4j
@EnableScheduling
public class MQTTConfig {

    private final ResultController resultController;
    private MqttClient client;
    private MqttConnectOptions options;
    private final VehicleValidationService vehicleValidationService;
    private final String topic = "OCR";

    @Autowired
    public MQTTConfig(VehicleValidationService vehicleValidationService, ResultController resultController) {
        this.vehicleValidationService = vehicleValidationService;
        this.resultController = resultController;
    };

    private String loadResourceAsString(String resourcePath) throws IOException {
        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(resourcePath)) {
            if (inputStream == null) {
                throw new IOException("Resource not found: " + resourcePath);
            }
            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    private InputStream loadResource(String resourcePath) throws IOException {
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream(resourcePath);
        if (inputStream == null) {
            throw new IOException("Resource not found: " + resourcePath);
        }
        return inputStream;
    }

    @Autowired
    private MqttMessageService mqttMessageService;

    @PostConstruct
    public void init() {
        try {
            // MQTT 브로커 설정
            Dotenv dotenv = Dotenv.load();
            String broker = "ssl://" + dotenv.get("AWS_IOT_ENDPOINT") + ":8883";
            String clientId = dotenv.get("AWS_CLIENT_ID");

            // 인증서 리소스 로드 및 MQTT 클라이언트 설정
            String certPath = "certs/certificate.pem.crt";
            String keyPath = "certs/private.pem.key";
            String caPath = "certs/AmazonRootCA1.pem";

            log.info("Loading certificates...");

            client = new MqttClient(broker, clientId, new MemoryPersistence());
            options = new MqttConnectOptions();
            options.setCleanSession(true);
            options.setKeepAliveInterval(60);
            options.setConnectionTimeout(30);

            // SSL 설정
            SSLSocketFactory socketFactory = getSSLSocketFactory(caPath, certPath, keyPath);
            options.setSocketFactory(socketFactory);

            // 연결 콜백
            client.setCallback(new MqttCallback() {
                @Override
                public void connectionLost(Throwable cause) {
                    log.error("Connection lost! Trying to reconnect...", cause);
                    reconnect();
                }

                @Override
                public void messageArrived(String topic, MqttMessage message) {
                    String payload = new String(message.getPayload(), StandardCharsets.UTF_8);
                    log.info("Message received on topic {}: {}", topic, payload);
                    try {
                        // MQTT 메시지 처리
                        mqttMessageService.handleMqttMessage(payload);
                    } catch (Exception e) {
                        log.error("Failed to process MQTT message", e);
                    }

                }

                @Override
                public void deliveryComplete(IMqttDeliveryToken token) {
                    log.info("Message delivered");
                }
            });

            connect(options);
            client.subscribe(topic);
            log.info("Subscribed to topic {}", topic);

//            // 초기 테스트 메시지 발행
//            if (client.isConnected()) {
//                String payload = "Hello from PickingParking!";
//                publishMessage(topic, payload);
//                log.info("Initial message published successfully");
//            } else {
//                log.warn("Client is not connected. Unable to publish initial message.");
//            }

        } catch (Exception e) {
            log.error("Failed to initialize MQTT client", e);
            throw new RuntimeException("Failed to initialize MQTT client", e);
        }
    }

    private void handleMqttMessage(String payload) {
        log.info("Start handling MQTT message");
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            // JSON 문자열을 VehicleMessage 객체로 변환
            LicensePlateResponse vehicleMessage = objectMapper.readValue(payload, LicensePlateResponse.class);
            String licensePlate = vehicleMessage.getResult();
            Integer zoneSeq = vehicleMessage.getZoneSeq(); // zone_seq 추출

            // 차량 번호 유효성 검사 수행
            Boolean isMatched = vehicleValidationService.validateVehicle(licensePlate, zoneSeq);

            // VehicleValidationResponse 생성
            VehicleValidationResponse response = new VehicleValidationResponse(isMatched, licensePlate, zoneSeq);

            log.info("Parsed Message: {}", response);
            // ResultController의 updateValidationResult 메서드를 호출하여 결과 업데이트
            resultController.updateValidationResult(response);
//            sendResponseToFrontend(response);
        } catch (Exception e) {
            log.error("JSON parsing failed: {}", e.getMessage());
            e.printStackTrace();
        }
        log.info("End handling MQTT message");
    }
//    private String extractLicensePlateFromMessage(String payload) {
//        // JSON 파싱 로직을 추가하여 차량 번호를 반환
//        // 예를 들어, Jackson이나 Gson을 사용하여 JSON 파싱
//        // {"message": {"result": "ABC1234"}} 형식의 JSON에서 "result" 추출
//        // JSON 파싱 라이브러리를 사용하여 이 부분을 구현하세요.
//        return ""; // 실제 차량 번호 추출 로직
//    }

//    private String extractLicensePlateFromMessage(String payload) {
//        ObjectMapper objectMapper = new ObjectMapper();
//        try {
//            // JSON 문자열을 LicensePlateResponse 객체로 변환
//            LicensePlateResponse response = objectMapper.readValue(payload, LicensePlateResponse.class);
//
//            // 차량번호 추출
//            return response.getMessage().getResult();
//        } catch (Exception e) {
//            log.error("Failed to parse JSON message: {}", e.getMessage());
//            return ""; // 오류 발생 시 빈 문자열 반환 또는 적절한 예외 처리
//        }
//    }

    private void sendResponseToFrontend(VehicleValidationResponse response) {
        RestTemplate restTemplate = new RestTemplate();
        String url = "http://k11a102.p.ssafy.io/api/vehicle/validation/response";
        try {
            restTemplate.postForObject(url, response, String.class);
            log.info("Response sent to frontend successfully: {}", response);
        } catch (Exception e) {
            log.error("Failed to send response to frontend: {}", e.getMessage());
        }
    }


    private SSLSocketFactory getSSLSocketFactory(String caPath, String certPath, String keyPath) throws Exception {
        // CA 인증서 로드
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate caCert;
        try (InputStream caInputStream = loadResource(caPath)) {
            caCert = (X509Certificate) cf.generateCertificate(caInputStream);
        }

        // 클라이언트 인증서 로드
        X509Certificate clientCert;
        try (InputStream certInputStream = loadResource(certPath)) {
            clientCert = (X509Certificate) cf.generateCertificate(certInputStream);
        }

        // 프라이빗 키 로드
        PEMParser pemParser = new PEMParser(new StringReader(loadResourceAsString(keyPath)));
        Object object = pemParser.readObject();
        PrivateKey privateKey;

        if (object instanceof PEMKeyPair) {
            privateKey = new JcaPEMKeyConverter().getPrivateKey(((PEMKeyPair) object).getPrivateKeyInfo());
        } else if (object instanceof PrivateKeyInfo) {
            privateKey = new JcaPEMKeyConverter().getPrivateKey((PrivateKeyInfo) object);
        } else {
            throw new IllegalStateException("Unexpected key format");
        }

        // 키스토어 설정
        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
        keyStore.load(null);
        keyStore.setCertificateEntry("ca-certificate", caCert);
        keyStore.setKeyEntry("client-key", privateKey, new char[0], new Certificate[]{clientCert});

        // SSL 컨텍스트 설정
        KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        kmf.init(keyStore, new char[0]);

        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(keyStore);

        SSLContext context = SSLContext.getInstance("TLSv1.2");
        context.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);

        return context.getSocketFactory();
    }

    private void connect(MqttConnectOptions options) {
        try {
            if (client != null && !client.isConnected()) {
                client.connect(options);
                client.subscribe(topic);
                log.info("Connected to AWS IoT Core");
            }
        } catch (MqttException e) {
            log.error("Failed to connect to AWS IoT Core", e);
        }
    }

    private void reconnect() {
        try {
            Thread.sleep(5000);  // 5초 대기
            connect(options);
        } catch (Exception e) {
            log.error("Failed to reconnect to AWS IoT Core", e);
        }
    }

    public void publishMessage(String topic, String payload) {
        try {
            if (client != null && client.isConnected()) {
                MqttMessage message = new MqttMessage(payload.getBytes());
                message.setQos(1);
                client.publish(topic, message);
                log.info("Published message to topic {}: {}", topic, payload);
            }
        } catch (MqttException e) {
            log.error("Failed to publish message", e);
        }
    }

    public boolean isConnected() {
        return client != null && client.isConnected();
    }

    @PreDestroy
    public void cleanup() {
        try {
            if (client != null && client.isConnected()) {
                client.disconnect();
                client.close();
                log.info("MQTT client disconnected and cleaned up");
            }
        } catch (MqttException e) {
            log.error("Failed to clean up MQTT client", e);
        }
    }
}
