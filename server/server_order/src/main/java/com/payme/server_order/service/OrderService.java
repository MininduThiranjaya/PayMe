package com.payme.server_order.service;

import org.springframework.stereotype.Service;

import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;

@Service
public class OrderService {
    
    public String setNewOrderService(NewOrder_req_dto data) {
        return "test";
    }
}
