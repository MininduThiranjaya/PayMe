package com.payme.server_user.DTO.res_dto;

import java.util.Set;

import com.payme.server_user.model.UserModel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserReg_res_dto {

    public UserReg_res_dto(String nic, String userName, Set<UserModel.Role> roles) {
        this.nic = nic;
        this.userName = userName;
        this.roles = roles;
    }
    
    private String nic;
    private String userName;
    private Set<UserModel.Role> roles;
}
