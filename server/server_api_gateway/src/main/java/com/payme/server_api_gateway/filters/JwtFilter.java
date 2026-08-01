package com.payme.server_api_gateway.filters;

import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import java.nio.charset.StandardCharsets;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import com.payme.server_api_gateway.security.JwtService;
import org.springframework.http.HttpHeaders;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@Component
@RequiredArgsConstructor
public class JwtFilter implements GlobalFilter, Ordered {
    
    private final JwtService jwtService;

    private Mono<Void> writeError(ServerWebExchange exchange, HttpStatus status, String code, String message) {
        
        String json = """
            {
                "status":%d,
                "code":%s,
                "message":%s
            }
        """.formatted(status.value(), code, message);
        byte[] bytes = json.getBytes(StandardCharsets.UTF_8);
        exchange.getResponse().setStatusCode(status);
        exchange.getResponse()
            .getHeaders()
            .setContentType(MediaType.APPLICATION_JSON);
        DataBuffer buffer = exchange.getResponse().bufferFactory().wrap(bytes);
        return exchange.getResponse().writeWith(Mono.just(buffer));
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {

        String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if(authHeader == null || !authHeader.startsWith("Bearer ")){
            return chain.filter(exchange);
        }
        String token = authHeader.substring(7);
        try{
            jwtService.validateToken(token);
            return chain.filter(exchange);
        } catch(ExpiredJwtException e) {
            return writeError(
                exchange,
                HttpStatus.UNAUTHORIZED,
                "TOKEN_EXPIRED",
                "JWT token has expired"
            );
        } catch(JwtException | IllegalArgumentException e) {
            return writeError(
                exchange,
                HttpStatus.UNAUTHORIZED,
                "INVALID_TOKEN",
                "JWT token is invalid"
            );
        }
    }

    @Override
    public int getOrder() {
        return -100;
    }
}
