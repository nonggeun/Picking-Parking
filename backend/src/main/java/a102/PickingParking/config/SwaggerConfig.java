package a102.PickingParking.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.swagger.v3.oas.models.servers.Server;

import java.util.Arrays;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        OpenAPI openAPI = new OpenAPI()
                .info(new Info()
                        .title("거주자 우선 주차 관리 시스템 API")
                        .version("v1")
                        .description("API 명세서"));
//        // 서버 정보 추가
//        Server localServer = new Server();
//        localServer.setDescription("local server");
//        localServer.setUrl("http://localhost:8080");

        Server prodHttpServer = new Server();
        prodHttpServer.setDescription("prod Https Server");
        prodHttpServer.setUrl("http://k11a102.p.ssafy.io:8080");

        openAPI.setServers(Arrays.asList(prodHttpServer));
        return openAPI;

    }


    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("PickingParking")
                .pathsToMatch("/**")
                .build();
    }



}