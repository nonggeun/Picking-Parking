package a102.PickingParking;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
//import io.github.cdimascio.dotenv.Dotenv;


@EnableScheduling
@SpringBootApplication
public class PickingParkingApplication {

	public static void main(String[] args) {
//  		Dotenv dotenv = Dotenv.load();
//		System.setProperty("DB_URL", dotenv.get("DB_URL"));
//		System.setProperty("DB_USERNAME", dotenv.get("DB_USERNAME"));
//		System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"));
		SpringApplication.run(PickingParkingApplication.class, args);
	}
}

