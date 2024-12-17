package a102.PickingParking.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableMethodSecurity
public class SecurityConfig {

//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        http.cors().configurationSource(corsConfigurationSource()) // CORS 설정 적용
//                .and().csrf().disable()
//                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
//                .and()
//                .authorizeHttpRequests()
//                .requestMatchers(
//                        // Swagger 허용 URL
//                        "/v2/api-docs", "/v3/api-docs", "/v3/api-docs/**", "/swagger-resources",
//                        "/swagger-resources/**", "/configuration/ui", "/configuration/security", "/swagger-ui/**",
//                        "/webjars/**", "/swagger-ui.html"
//                ).permitAll()
//                .anyRequest().authenticated();
//
//        return http.build();
//    }
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // CORS 설정
                .csrf(csrf -> csrf.disable()) // CSRF 비활성화
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // 세션 관리
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/api/**",
                        "/v2/api-docs", "/v3/api-docs", "/v3/api-docs/**", "/swagger-resources",
                       "/swagger-resources/**", "/configuration/ui", "/configuration/security", "/swagger-ui/**",
                       "/webjars/**", "/swagger-ui.html").permitAll() // 공개 경로 설정
                        .anyRequest().authenticated() // 나머지 경로는 인증 요구
                );

        return http.build();
    }

    // CORS 설정 메서드
    @Bean
    public UrlBasedCorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.addAllowedOriginPattern("*"); // 모든 도메인 허용
        configuration.addAllowedMethod("*"); // 모든 HTTP 메서드 허용
        configuration.addAllowedHeader("*"); // 모든 헤더 허용

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

}