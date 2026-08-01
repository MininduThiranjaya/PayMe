package com.payme.server_api_gateway.security;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secretKey;

    public SecretKey getSignKey() {

        byte[] keyBites = secretKey.getBytes();
        return Keys.hmacShaKeyFor(keyBites);
    }

    public Claims validateToken(String token) {
        
        return Jwts.parser()
            .verifyWith(getSignKey())
            .build()
            .parseSignedClaims(token)
            .getPayload();
    } 
}
