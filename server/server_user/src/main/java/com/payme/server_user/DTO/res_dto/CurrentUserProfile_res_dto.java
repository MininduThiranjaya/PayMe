package com.payme.server_user.DTO.res_dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import com.payme.server_user.enums.MerchantStatus;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.enums.Role;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CurrentUserProfile_res_dto {

    private String nic;
    private String stripeAccountId;
    private String userName;
    private Set<Role> roles;
    private MerchantStatus merchantStatus;
    private Boolean chargesEnabled;
    private Boolean payoutsEnabled;
    private Boolean detailsSubmitted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<Shop_res_dto> shops;

    public CurrentUserProfile_res_dto(String nic, String stripeAccountId, String userName, Set<Role> roles, MerchantStatus merchantStatus, Boolean chargesEnabled, Boolean payoutsEnabled, Boolean detailsSubmitted, LocalDateTime createdAt, LocalDateTime updatedAt, List<Shop_res_dto> shops) {
        this.nic = nic;
        this.stripeAccountId = stripeAccountId;
        this.userName = userName;
        this.roles = roles;
        this.merchantStatus = merchantStatus;
        this.chargesEnabled = chargesEnabled;
        this.payoutsEnabled = payoutsEnabled;
        this.detailsSubmitted = detailsSubmitted;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.shops = shops;
    }

    public CurrentUserProfile_res_dto(String nic, String userName, Set<Role> roles, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.nic = nic;
        this.userName = userName;
        this.roles = roles;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}
