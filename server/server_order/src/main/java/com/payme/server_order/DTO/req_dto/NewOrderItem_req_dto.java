package com.payme.server_order.DTO.req_dto;

import com.payme.server_order.enums.ItemMetric;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class NewOrderItem_req_dto {

    @NotBlank(message = "Item name is required")
    private String itemName;
    @Positive(message = "Quantity must be greater than 0")
    private int quantity;
    @NotNull(message = "Item metric type is required")
    private ItemMetric itemMetric;
    @Positive(message = "Unit price must be greater than 0")
    private int unitPrice;
}
