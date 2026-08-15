package com.payme.server_order.DTO.req_dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotEmpty;

@Getter
@Setter
@NoArgsConstructor
public class NewOrderItem_req_dto {

    public enum ItemMetric {
        ITEM,
        KG,
        G
    }
    
    @NotEmpty(message = "Item name is required")
    private String itemName;
    @NotEmpty(message = "Quantity is required")
    private int quantity;
    @NotEmpty(message = "Item metric type is required")
    private String ItemMetric;
    @NotEmpty(message = "Unit price is required")
    private int unitPrice;
}
