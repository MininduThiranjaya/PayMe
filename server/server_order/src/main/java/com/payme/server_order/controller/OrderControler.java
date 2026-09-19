package com.payme.server_order.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;

import com.payme.server_order.DTO.ApiResponse;
import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.DTO.req_dto.CustomerClaimOrder_req_dto;
import com.payme.server_order.DTO.res_dto.CustomerClaimOrder_res_dto;
import com.payme.server_order.service.OrderService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("payme/api/order")
@RequiredArgsConstructor
public class OrderControler {

    private final OrderService orderService;

    @PreAuthorize("hasAuthority('ROLE_MERCHANT')")
    @PostMapping("/create-order")
    public ResponseEntity<ApiResponse<Long>> setNewOrderController(
        @Valid @RequestBody NewOrder_req_dto data,
        @AuthenticationPrincipal Jwt jwt
    ) {  

        long orderId = orderService.setNewOrderService(data, jwt);
        ApiResponse response = ApiResponse.<Long>builder()
            .status(true)
            .message("Set new order successfully")
            .resData(orderId)
            .build();
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasAuthority('ROLE_CUSTOMER')")
    @PostMapping("/claim-order")
    public ResponseEntity<ApiResponse<CustomerClaimOrder_res_dto>> customerClaimNewOrderController(
        @Valid @RequestBody CustomerClaimOrder_req_dto data,
        @AuthenticationPrincipal Jwt jwt
    ) {  

        CustomerClaimOrder_res_dto orderId = orderService.customerClaimNewOrderService(data, jwt);
        ApiResponse response = ApiResponse.<CustomerClaimOrder_res_dto>builder()
            .status(true)
            .message("Set new order successfully")
            .resData(orderId)
            .build();
        return ResponseEntity.ok(response);
    }
}
