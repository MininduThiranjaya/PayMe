package com.payme.server_user.auth;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import com.payme.security.AppUserDetails;
import com.payme.server_user.error.exceptions.UserNotFoundExc;
import com.payme.server_user.services.authServices.AuthenticationService;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import tools.jackson.databind.ObjectMapper;

@AllArgsConstructor
public class JwtFilter extends OncePerRequestFilter {

    public final AuthenticationService authenticationService;
    public final ObjectMapper objectMapper;

    private void writeErrorResponse(
        HttpServletResponse response,
        HttpStatus status,
        String code,
        String message
    ) throws IOException {

        Map<String, Object> responseBody = new LinkedHashMap<>();

        responseBody.put("status", status.value());
        responseBody.put("code", code);
        responseBody.put("message", message);

        response.setStatus(status.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        objectMapper.writeValue(
                response.getOutputStream(),
                responseBody
        );
    }

    @Override
    protected void  doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String nic = null;

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }
        
        try {
            if(authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);
                nic = authenticationService.extractUserNic(token);
            }
            if(nic != null && token != null && SecurityContextHolder
                    .getContext()
                    .getAuthentication() == null) {
                UserDetails userDetails = authenticationService.validateToken(token);
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                authentication.setDetails(
                        new WebAuthenticationDetailsSource()
                                .buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authentication);
                if(userDetails instanceof AppUserDetails appUserDetails) {
                    request.setAttribute("nic", appUserDetails.getUsername());
                }
            }
        } catch (ExpiredJwtException exception) {

            SecurityContextHolder.clearContext();
            writeErrorResponse(
                    response,
                    HttpStatus.UNAUTHORIZED,
                    "TOKEN_EXPIRED",
                    "JWT token has expired"
            );
            return;
        } catch (JwtException | IllegalArgumentException exception) {

            SecurityContextHolder.clearContext();
            writeErrorResponse(
                    response,
                    HttpStatus.UNAUTHORIZED,
                    "INVALID_TOKEN",
                    "JWT token is invalid"
            );
            return;
        } catch (UserNotFoundExc | UsernameNotFoundException exception) {

            SecurityContextHolder.clearContext();
            writeErrorResponse(
                    response,
                    HttpStatus.UNAUTHORIZED,
                    "USER_NOT_FOUND",
                    "The user connected to this token was not found"
            );
            return;
        } catch (AuthenticationException exception) {

            SecurityContextHolder.clearContext();
            writeErrorResponse(
                    response,
                    HttpStatus.UNAUTHORIZED,
                    "AUTHENTICATION_FAILED",
                    "User authentication failed"
            );
            return;
        } catch (Exception exception) {

            SecurityContextHolder.clearContext();
            writeErrorResponse(
                    response,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "INTERNAL_SERVER_ERROR",
                    "An unexpected error occurred"
            );
            return;
        }
        filterChain.doFilter(request, response);
    }
}