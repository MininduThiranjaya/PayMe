package com.payme.server_payment.DTO.req_dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.Builder;

@Getter
@Setter
@Builder
public class PaymentReadyDetails_req_dto {
    
    private String merchantNic;
    private long totalAmount;
    private LocalDateTime createdAt;
}
