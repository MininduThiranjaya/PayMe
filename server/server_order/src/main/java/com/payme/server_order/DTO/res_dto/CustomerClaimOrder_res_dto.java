package com.payme.server_order.DTO.res_dto;

import java.time.LocalDateTime;
import java.util.List;

import com.payme.server_order.enums.OrderStatus;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class CustomerClaimOrder_res_dto {

    private long orderId;
    private String merchantNic;
    private String customerNic;
    private OrderStatus status;
    private List<OrderItem_res_dto> orderItems;
    private long totalAmount;
    private LocalDateTime createdAt;
}