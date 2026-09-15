package com.payme.server_api_gateway.config;

import java.nio.charset.StandardCharsets;
import java.util.List;

import javax.crypto.SecretKey;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimNames;
import org.springframework.security.oauth2.jwt.JwtClaimValidator;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusReactiveJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.oauth2.server.resource.authentication.ReactiveJwtAuthenticationConverterAdapter;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;
import org.springframework.beans.factory.annotation.Value;

import org.springframework.core.convert.converter.Converter;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import reactor.core.publisher.Mono;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http, UrlBasedCorsConfigurationSource corsSource) {
        
        http
            .csrf(csrf -> csrf.disable())
            .cors(cors -> cors.configurationSource(corsSource))
            .authorizeExchange(auth -> 
                auth
                .pathMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                .pathMatchers(HttpMethod.POST, "/payme/api/user/login").permitAll()
                .pathMatchers(HttpMethod.POST, "/payme/api/user/reg/customer").permitAll()
                .pathMatchers(HttpMethod.POST, "/payme/api/user/reg/merchant").permitAll()
                .anyExchange().authenticated()
            ).oauth2ResourceServer(oauth2 -> 
                oauth2.jwt(jwt -> 
                    jwt.jwtAuthenticationConverter(
                        jwtAuthenticationConvertor()
                    )
                )
            );
        return http.build();
    }

    @Bean
    public ReactiveJwtDecoder jwtDecoder(@Value("${JWT_SECRET}") String secretKey) {

        SecretKey  key = Keys.hmacShaKeyFor(
            secretKey.getBytes(StandardCharsets.UTF_8)
        );
        NimbusReactiveJwtDecoder decoder = NimbusReactiveJwtDecoder
            .withSecretKey(key)
            .macAlgorithm(MacAlgorithm.HS256)
            .build();
        OAuth2TokenValidator<Jwt> issuerValidator = JwtValidators.createDefaultWithIssuer("payme-auth");
        OAuth2TokenValidator<Jwt> audienceValidator = new JwtClaimValidator<List<String>>(
            JwtClaimNames.AUD,
            audience -> audience != null && audience.contains("payme-api")
        );
        decoder.setJwtValidator(
            new DelegatingOAuth2TokenValidator<>(
                issuerValidator,
                audienceValidator
            )
        );
        return decoder;
    }

    @Bean
    public Converter<Jwt, Mono<AbstractAuthenticationToken>> jwtAuthenticationConvertor() {
        
        JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
        authoritiesConverter.setAuthoritiesClaimName("roles");
        authoritiesConverter.setAuthorityPrefix("");
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(
            authoritiesConverter
        );
        return new ReactiveJwtAuthenticationConverterAdapter(converter);
    }
}
