package com.payme.server_order.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.server_order.DTO.ApiResponse;
import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.DTO.req_dto.CustomerClaimOrder_req_dto;
import com.payme.server_order.DTO.res_dto.CustomerClaimOrder_res_dto;
import com.payme.server_order.service.OrderInternalService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("payme/api/order/internal")
@RequiredArgsConstructor
public class OrderInternalController {

    private final OrderInternalService service;
    
    @PutMapping("/payment-pending/{orderId}")
    public ResponseEntity<Void> setOrderPaymentPendingController(@PathVariable long orderId) {

        service.setOrderPaymentPendingService(orderId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/payment-paid/{orderId}")
    public ResponseEntity<Void> setOrderPaymentPaidController(@PathVariable long orderId) {

        service.setOrderPaymentPaidService(orderId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/payment-failed/{orderId}")
    public ResponseEntity<Void> setOrderPaymentFailedController(@PathVariable long orderId) {

            service.setOrderPaymentFailedService(orderId);
            return ResponseEntity.noContent().build();
    }
}
