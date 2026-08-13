package com.payme.server_order.DTO.req_dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class NewOrderItem_req_dto {

    public enum ItemMetric {
        ITEM,
        KG,
        G
    }
    
    private String itemName;
    private int quantity;
    private String ItemMetric;
    private int unitPrice;
}
