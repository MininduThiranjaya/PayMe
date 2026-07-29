package com.payme.server_user.error.exceptions;

public class UserNotFoundExc extends RuntimeException {
    
    public UserNotFoundExc(String nic) {
        super("User not found: " + nic);
    }
}
