package a102.PickingParking.repository;


import a102.PickingParking.entity.MqttData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MqttMessageRepository extends JpaRepository<MqttData, Integer> {
}
