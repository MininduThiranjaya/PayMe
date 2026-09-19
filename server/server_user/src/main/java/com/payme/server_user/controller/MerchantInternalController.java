package com.payme.server_user.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.server_user.services.MerchantInternalService;
import com.payme.server_user.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("payme/api/user/internal/merchant")
@RequiredArgsConstructor
public class MerchantInternalController {
    
    private final MerchantInternalService service;

    @PutMapping("/update/stripe-status")
    public ResponseEntity<Void> updateStripeStatusController(@RequestBody StripeWebhookUpdateAcc_req_dto data) {

        System.out.println("Stripe webhook updated data received successfully - user service");
        service.updateStripeStatuService(data);
        return ResponseEntity.ok().build();
    }
}
