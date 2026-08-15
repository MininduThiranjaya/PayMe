package com.payme.server_order.DTO.req_dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

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
    @NotNull(message = "Quantity is required")
    @Positive(message = "Quantity must be greater than 0")
    private int quantity;
    @NotEmpty(message = "Item metric type is required")
    private ItemMetric itemMetric;
    @NotNull(message = "Unit price is required")
    @Positive(message = "Unit price must be greater than 0")
    private int unitPrice;
}
