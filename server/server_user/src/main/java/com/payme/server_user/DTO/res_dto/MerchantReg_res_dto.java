package com.payme.server_user.DTO.res_dto;

import java.util.List;
import java.util.Set;

import com.payme.server_user.enums.MerchantStatus;
import com.payme.server_user.model.UserModel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MerchantReg_res_dto extends UserReg_res_dto {

    private String stripeAccountId;
    private String stripeOnboardingURL;
    private MerchantStatus merchantStatus;
    private List<Shop_res_dto> shops;

    public MerchantReg_res_dto(
            String nic,
            String stripeAccountId,
            String userName,
            Set<UserModel.Role> roles,
            String stripeOnboardingURL,
            MerchantStatus merchantStatus,
            List<Shop_res_dto> shops
    ) {
        super(nic, userName, roles);
        this.stripeAccountId = stripeAccountId;
        this.stripeOnboardingURL = stripeOnboardingURL;
        this.merchantStatus = merchantStatus;
        this.shops = shops;
    }
}
