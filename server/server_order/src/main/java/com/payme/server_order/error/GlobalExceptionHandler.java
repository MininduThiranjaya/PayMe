package com.payme.server_order.error;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.payme.server_order.error.exceptions.OrderNotFoundExc;
import com.payme.server_order.error.exceptions.OrderNotSavedExc;

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleArgValidationException(MethodArgumentNotValidException exception) {

        Map<String, String> fieldErrors = new HashMap<>();
        exception.getBindingResult()
            .getFieldErrors()
            .forEach(error -> fieldErrors.put(error.getField(), error.getDefaultMessage()));
        Map<String, Object> response = new HashMap<>();
        response.put("status", 400);
        response.put("code", "VALIDATION_ERROR");
        response.put("message", "Invalid request data");
        response.put("fieldErrors", fieldErrors);

        return ResponseEntity
            .badRequest()
            .body(response);
    }

    @ExceptionHandler(OrderNotFoundExc.class)
    public ResponseEntity<Map<String, Object>> handleOrderNotSavedException(
            OrderNotFoundExc exception) {

        Map<String, Object> response = new HashMap<>();
        response.put("status", 404);
        response.put("code", exception.getCode());
        response.put("message", exception.getMessage());

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(response);
    }

    @ExceptionHandler(OrderNotSavedExc.class)
    public ResponseEntity<Map<String, Object>> handleOrderNotFoundException(OrderNotFoundExc exception) {
        Map<String, Object> response = new HashMap<>();
        response.put("status", 500);
        response.put("code", exception.getCode());
        response.put("message", exception.getMessage());

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGenericException(Exception exception) {
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", 500);
        response.put("code", "INTERNAL_SERVER_ERROR");
        response.put("message", "An unexpected error occurred " + exception.getMessage());

        return ResponseEntity
            .status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(response);
    }
}
