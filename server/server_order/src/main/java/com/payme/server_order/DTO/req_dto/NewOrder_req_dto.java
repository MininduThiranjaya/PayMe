package com.payme.server_order.DTO.req_dto;

import java.util.ArrayList;
import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.Valid;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class NewOrder_req_dto {
    
    @NotEmpty(message = "At least one order item is required")
    @Valid
    private List<@Valid NewOrderItem_req_dto> orderItem = new ArrayList<>();
}
