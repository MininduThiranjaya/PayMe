package com.payme.server_user.error.exceptions;

public class BadCredentialsExc extends RuntimeException{
    
    private final String code;
    public BadCredentialsExc(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() {
        return code;
    }
}
