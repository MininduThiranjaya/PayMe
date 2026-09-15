package com.payme.server_payment.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.server_payment.DTO.ApiResponse;
import com.payme.server_payment.DTO.res_dto.RegStripeConnectAcc_res_dto;
import com.payme.server_payment.service.PaymentService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("payme/api/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService service;
    
    @GetMapping("/reg/stripe-connect-acc")
    public ResponseEntity<ApiResponse> regStripeConnectAccountController() {
        
        RegStripeConnectAcc_res_dto res = service.regStripeConnectAccountService();
        ApiResponse response = ApiResponse.builder()
            .status(true)
            .message("Stripe merchant register url fetched successfully")
            .resData(res)
            .build();
        return ResponseEntity.ok(response);
    }
}
