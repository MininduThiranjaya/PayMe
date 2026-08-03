package com.payme.server_user.error;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.payme.server_user.error.exceptions.BadCredentialsExc;
import com.payme.server_user.error.exceptions.UserAlreadyExistsExc;
import com.payme.server_user.error.exceptions.UserNotFoundExc;
import com.payme.server_user.error.exceptions.UserNotUpdatedExc;

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

    @ExceptionHandler(UserNotFoundExc.class)
    public ResponseEntity<Map<String, Object>> handleUserNotFoundException(UserNotFoundExc exception) {

        Map<String, Object> response = new HashMap<>();
        response.put("status", 404);
        response.put("code", "USER_NOT_FOUND");
        response.put("message", exception.getMessage());

        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(response);
    }

    @ExceptionHandler(UserAlreadyExistsExc.class)
    public ResponseEntity<Map<String, Object>> handleUserAlreadyExistsException(UserAlreadyExistsExc exception) {

        Map<String, Object> response = new HashMap<>();
        response.put("status", 409);
        response.put("code", "USER_ALREADY_EXISTS");
        response.put("message", exception.getMessage());

        return ResponseEntity
            .status(HttpStatus.CONFLICT)
            .body(response);
    }

    @ExceptionHandler(UserNotUpdatedExc.class)
    public ResponseEntity<Map<String, Object>> handleUserNotUpdatedException(UserNotUpdatedExc exception) {

        Map<String, Object> response = new HashMap<>();
        response.put("status", 409);
        response.put("code", "USER_NOT_UPDATED");
        response.put("message", exception.getMessage());

        return ResponseEntity
            .status(HttpStatus.CONFLICT)
            .body(response);
    }

    @ExceptionHandler(BadCredentialsExc.class)
    public ResponseEntity<Map<String, Object>> handleBadCredentialsException(BadCredentialsExc exception) {

        Map<String, Object> response = new HashMap<>();
        response.put("status", 401);
        response.put("code", exception.getCode());
        response.put("message", exception.getMessage());

        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
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