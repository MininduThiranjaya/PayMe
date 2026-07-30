package com.payme.server_user.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.payme.server_user.services.authServices.AuthenticationService;

import tools.jackson.databind.ObjectMapper;



@Configuration
public class authConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtFilter jwtFilter) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // suitable for stateless REST APIs
            .authorizeHttpRequests(auth ->
                    auth
                    .requestMatchers(HttpMethod.POST, "/payme/api/user/reg").permitAll() // allow registration endpoint
                    .requestMatchers(HttpMethod.POST, "/payme/api/user/login").permitAll() // allow login endpoint
                    .anyRequest().authenticated() // all other requests require authentication
            ).addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
    
    @Bean
    public JwtFilter jwtFilter(AuthenticationService service,  ObjectMapper objectMapper) {
        return new JwtFilter(service, objectMapper);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
