package com.payme.server_user.services.authServices;

import org.springframework.security.core.userdetails.UserDetails;

public interface AuthenticationService {
    
    String generateToken(UserDetails userDetails);
    UserDetails validateToken(String token);
    UserDetails authenticate(String nic, String password);
    String extractUserNic(String token);
}
