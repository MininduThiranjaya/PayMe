package com.payme.server_user.error.exceptions;

public class UserAlreadyExistsExc extends RuntimeException{
    
    public UserAlreadyExistsExc(String nic) {
        super("User already exists: " + nic);
    }
}
