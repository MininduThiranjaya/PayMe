package com.payme.server_payment.DTO.res_dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class MakePayment_res_dto {

    private long orderId;
    private double amount;
    private String paymentIntentId;
    private String clientSecret;
}