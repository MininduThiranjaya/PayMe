package com.payme.server_user.services.authServices;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@Service

public class JWTService implements AuthenticationService {

    private final AuthenticationManager authenticationManager;
    private final UserDetailsService userDetailsService;
    private final String secretKey;
    private final long jwtExpiry = 3_600_000L;

    public JWTService(AuthenticationManager authenticationManager, UserDetailsService userDetailsService, @Value("${jwt.secret}") String secretKey) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.secretKey = secretKey;
    }
    
    @Override
    public String generateToken(UserDetails userDetails) {
        
        Map <String, Object> claims = new HashMap<>();
        return Jwts.builder()
            .claims()
            .add(claims)
            .subject(userDetails.getUsername())
            .issuedAt(new Date(System.currentTimeMillis()))
            .expiration(new Date(System.currentTimeMillis() + jwtExpiry))
            .and()
            .signWith(getSignKey(), SignatureAlgorithm.HS256)
            .compact();
    }

    public Key getSignKey() {

        byte[] keyBites = secretKey.getBytes();
        return Keys.hmacShaKeyFor(keyBites);
    }

    @Override
    public UserDetails authenticate(String nic, String password) {

        Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(nic, password));
        return (UserDetails) authentication.getPrincipal();
    }

    @Override
    public UserDetails validateToken(String token) {

        String nic = extractUserNic(token);
        UserDetails userDetails = userDetailsService.loadUserByUsername(nic);
        return userDetails;
    }

    @Override
    public String extractUserNic(String token) {
        
        Claims claims = Jwts.parser()
            .setSigningKey(getSignKey())
            .build()
            .parseClaimsJws(token)
            .getBody();
        return claims.getSubject();
    }
}
