package com.payme.server_order.DTO.res_dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class NewOrder_res_dto {

    private long id;
    private long merchantId;
    private long customerId;
    private List<NewOrderItem_res_dto> orderItem = new ArrayList<>();
}
