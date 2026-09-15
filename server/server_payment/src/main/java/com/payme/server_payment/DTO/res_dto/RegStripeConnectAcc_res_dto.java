package com.payme.server_payment.DTO.res_dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter 
@Builder
public class RegStripeConnectAcc_res_dto {
    
    private String stripeId;
    private String stripeOnboardingURL;
    private Boolean chargesEnabled;
    private Boolean payoutsEnabled;
    private Boolean detailsSubmitted;
}
