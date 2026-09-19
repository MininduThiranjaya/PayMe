package com.payme.server_payment.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.payme.server_payment.service.StripeWebhookService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("payme/api/payment/stripe/webhook")
@RequiredArgsConstructor
public class StripeWebhookController {

    private final StripeWebhookService service;

    @PostMapping
    public ResponseEntity<Void> handleStripeWebhookController(@RequestBody String payload, @RequestHeader("Stripe-Signature") String signature) {

        System.out.println("Stripe webhook received successfully - payment service");
        service.handleStripeWebhookService(payload, signature);
        return ResponseEntity.ok().build();
    } 
}