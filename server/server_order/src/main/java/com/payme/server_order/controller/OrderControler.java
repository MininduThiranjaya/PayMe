package com.payme.server_order.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.server_order.service.OrderService;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;


@RestController
@RequestMapping("payme/api/order")
@RequiredArgsConstructor
public class OrderControler {

    private final OrderService orderService;

    @PostMapping("/set-new-order")
    public String setNewOrder(@RequestBody NewOrder_req_dto data) {        
        return "entity";
    }
    
}
