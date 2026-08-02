package com.payme.server_api_gateway.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

@Configuration
public class CorsConfig {
    
    @Bean
    public UrlBasedCorsConfigurationSource corsConfigurationSource() {

        CorsConfiguration configuration = new CorsConfiguration();
        // Frontend applications allowed to call the gateway
        configuration.setAllowedOrigins(
                List.of(
                        "http://localhost:50438"
                )
        );
        // HTTP methods allowed from the frontend
        configuration.setAllowedMethods(
                List.of(
                        "GET",
                        "POST",
                        "PUT",
                        "PATCH",
                        "DELETE",
                        "OPTIONS"
                )
        );
        // Request headers allowed from the frontend
        configuration.setAllowedHeaders(
                List.of(
                        "Authorization",
                        "Content-Type",
                        "Accept"
                )
        );

        // You are using Bearer JWT, not browser cookies
        configuration.setAllowCredentials(false);
        // Browser can cache the preflight result for one hour
        configuration.setMaxAge(3600L);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        // Apply CORS only to your gateway API routes
        source.registerCorsConfiguration(
                "/payme/api/**",
                configuration
        );
        return source;
    }
}
