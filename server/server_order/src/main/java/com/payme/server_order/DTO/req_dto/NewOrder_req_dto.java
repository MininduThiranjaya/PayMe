package com.payme.server_order.DTO.req_dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotEmpty;


@Getter
@Setter
@NoArgsConstructor
public class NewOrder_req_dto {
    
    @NotEmpty(message = "Merchant id is required")
    private long merchantId;
    @NotEmpty(message = "Customer id is required")
    private long customerId;
    private List<NewOrderItem_req_dto> orderItem = new ArrayList<>();
}
