package com.payme.server_order.DTO.res_dto;

import lombok.Getter;
import lombok.Setter;
import lombok.Builder;

@Getter
@Setter
@Builder
public class OrderItem_res_dto {
    
    private long id;
    private String itemName;
    private int quantity;
    private String metric;
    private int unitPrice;
    private long totalPrice;
}
