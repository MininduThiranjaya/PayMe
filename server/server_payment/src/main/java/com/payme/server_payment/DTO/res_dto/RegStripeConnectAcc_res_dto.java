package com.payme.server_payment.DTO.res_dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegStripeConnectAcc_res_dto {
    
    private String stripId;
    private String stripeOnboardingURL;
}
