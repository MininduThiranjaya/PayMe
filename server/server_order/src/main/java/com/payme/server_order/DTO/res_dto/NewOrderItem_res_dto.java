package com.payme.server_order.DTO.res_dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class NewOrderItem_res_dto {
    
    private long id;
    private String itemName;
    private int quantity;
    private String itemMetric;
    private int unitPrice;
}
