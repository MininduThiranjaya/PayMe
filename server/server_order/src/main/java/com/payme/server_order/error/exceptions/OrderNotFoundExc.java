package com.payme.server_order.error.exceptions;

public class OrderNotFoundExc extends RuntimeException{
    
    private final String code;
    public OrderNotFoundExc(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() {
        return code;
    }
}
