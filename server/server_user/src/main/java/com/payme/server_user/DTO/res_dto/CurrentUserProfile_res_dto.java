package com.payme.server_user.DTO.res_dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import com.payme.server_user.model.UserModel;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CurrentUserProfile_res_dto {

    private String nic;
    private String userName;
    private Set<UserModel.Role> roles;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<Shop_res_dto> shops;

    public CurrentUserProfile_res_dto(String nic, String userName, Set<UserModel.Role> roles, LocalDateTime createdAt, LocalDateTime updatedAt, List<Shop_res_dto> shops) {
        this.nic = nic;
        this.userName = userName;
        this.roles = roles;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.shops = shops;
    }

    public CurrentUserProfile_res_dto(String nic, String userName, Set<UserModel.Role> roles, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.nic = nic;
        this.userName = userName;
        this.roles = roles;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}
