package com.payme.server_user.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class authConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // suitable for stateless REST APIs
            .authorizeHttpRequests(auth ->
                    auth
                    .requestMatchers(HttpMethod.POST, "/payme/api/user/reg").permitAll() // allow registration endpoint
                    .anyRequest().authenticated() // all other requests require authentication
            );
        return http.build();
    }
}
