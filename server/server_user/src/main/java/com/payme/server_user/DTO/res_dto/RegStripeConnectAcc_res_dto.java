package com.payme.server_user.DTO.res_dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter 
@Setter 
public class RegStripeConnectAcc_res_dto {
    
    private String stripId;
    private String stripeOnboardingURL;
}
