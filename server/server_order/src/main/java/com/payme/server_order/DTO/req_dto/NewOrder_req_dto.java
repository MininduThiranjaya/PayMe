package com.payme.server_order.DTO.req_dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;


@Getter
@Setter
@NoArgsConstructor
public class NewOrder_req_dto {
    
    @NotNull(message = "Merchant id is required")
    @Positive(message = "Merchant id must be greater than 0")
    private long merchantId;
    @NotNull(message = "Customer id is required")
    @Positive(message = "Customer id must be greater than 0")
    private long customerId;
    private List<NewOrderItem_req_dto> orderItem = new ArrayList<>();
}
