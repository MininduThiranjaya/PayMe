package com.payme.server_order.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.DTO.res_dto.NewOrder_res_dto;
import com.payme.server_order.service.OrderService;

import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("payme/api/order")
@RequiredArgsConstructor
public class OrderControler {

    private final OrderService orderService;

    @PostMapping("/set-new-order")
    public ResponseEntity<Long> setNewOrderController(@Valid @RequestBody NewOrder_req_dto data) {  

        long orderId = orderService.setNewOrderService(data);
        return ResponseEntity.ok(orderId);
    }

    @GetMapping("/get-order-by-id/{id}")
    public ResponseEntity<NewOrder_res_dto> getOrderByIdController(@PathVariable long id) {

        NewOrder_res_dto order = orderService.getOrderByIdService(id);
        return ResponseEntity.ok(order);
    }
    
}
