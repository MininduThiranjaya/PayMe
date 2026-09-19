package com.payme.server_order.DTO.req_dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CustomerClaimOrder_req_dto {
    
    @NotNull(message = "Order id is required")
    @Positive(message = "Order id must be greater than 0")
    private Long orderId;
}
