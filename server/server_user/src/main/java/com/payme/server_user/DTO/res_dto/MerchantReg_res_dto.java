package com.payme.server_user.DTO.res_dto;

import java.util.List;
import java.util.Set;

import com.payme.server_user.model.UserModel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MerchantReg_res_dto extends UserReg_res_dto {

    public MerchantReg_res_dto(
            String nic,
            String userName,
            Set<UserModel.Role> roles,
            List<Shop_res_dto> shops
    ) {
        super(nic, userName, roles);
        this.shops = shops;
    }
    
    private List<Shop_res_dto> shops;
}
