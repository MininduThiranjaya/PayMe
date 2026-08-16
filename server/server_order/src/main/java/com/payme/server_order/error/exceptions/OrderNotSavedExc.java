package com.payme.server_order.error.exceptions;

public class OrderNotSavedExc extends RuntimeException {
    
    private final String code;
    
    public OrderNotSavedExc(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() {
        return code;
    }
}
