package com.payme.server_user.DTO.res_dto;

import java.util.List;
import java.util.Set;

import com.payme.server_user.enums.MerchantStatus;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.enums.Role;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MerchantReg_res_dto extends UserReg_res_dto {

    private String stripeAccountId;
    private String stripeOnboardingURL;
    private MerchantStatus merchantStatus;
    private List<Shop_res_dto> shops;
    private Boolean chargesEnabled;
    private Boolean payoutsEnabled;
    private Boolean detailsSubmitted;

    public MerchantReg_res_dto(
            String nic,
            String stripeAccountId,
            String userName,
            Set<Role> roles,
            String stripeOnboardingURL,
            Boolean chargesEnabled,
            Boolean payoutsEnabled,
            Boolean detailsSubmitted,
            MerchantStatus merchantStatus,
            List<Shop_res_dto> shops
    ) {
        super(nic, userName, roles);
        this.stripeAccountId = stripeAccountId;
        this.stripeOnboardingURL = stripeOnboardingURL;
        this.merchantStatus = merchantStatus;
        this.chargesEnabled = chargesEnabled;
        this.payoutsEnabled = payoutsEnabled;
        this.detailsSubmitted = detailsSubmitted;
        this.shops = shops;
    }
}
