package com.payme.server_order.DTO.req_dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class NewOrder_req_dto {
    
    private long merchantId;
    private long customerId;
    private List<NewOrderItem_req_dto> orderItem = new ArrayList<>();
}
