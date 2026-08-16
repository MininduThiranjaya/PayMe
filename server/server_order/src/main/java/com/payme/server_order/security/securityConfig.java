package com.payme.server_order.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class securityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception{

        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth ->
                auth
                    .requestMatchers(HttpMethod.POST, "/payme/api/order/set-new-order").permitAll()
                    .requestMatchers(HttpMethod.GET, "/payme/api/order/get-order-by-id/{id}").permitAll()
                    .anyRequest().authenticated()
            );
        return http.build();
    }
}
