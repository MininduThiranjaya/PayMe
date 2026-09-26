package com.payme.server_payment.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;

import com.payme.server_payment.DTO.ApiResponse;
import com.payme.server_payment.DTO.res_dto.RegStripeConnectAcc_res_dto;
import com.payme.server_payment.DTO.res_dto.MakePayment_res_dto;
import com.payme.server_payment.DTO.req_dto.MakePayment_req_dto;
import com.payme.server_payment.service.PaymentService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("payme/api/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService service;
    
    @GetMapping("/reg/stripe-connect-acc")
    public ResponseEntity<ApiResponse<RegStripeConnectAcc_res_dto>> regStripeConnectAccountController() {
        
        RegStripeConnectAcc_res_dto res = service.regStripeConnectAccountService();
        ApiResponse response = ApiResponse.<RegStripeConnectAcc_res_dto>builder()
            .status(true)
            .message("Stripe merchant register url fetched successfully")
            .resData(res)
            .build();
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasAuthority('ROLE_CUSTOMER')")
    @PostMapping("/make-payment")
    public ResponseEntity<ApiResponse<MakePayment_res_dto>> makePaymentController(@Valid @RequestBody MakePayment_req_dto data) {  

        MakePayment_res_dto orderId = service.makePaymentService(data);
        ApiResponse response = ApiResponse.<MakePayment_res_dto>builder()
            .status(true)
            .message("Set new order successfully")
            .resData(orderId)
            .build();
        return ResponseEntity.ok(response);
    }
}
