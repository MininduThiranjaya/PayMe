package com.payme.server_user.DTO.res_dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Shop_res_dto {

    private Long id;
    private String shopName;
    private String address;

    public Shop_res_dto(Long id, String shopName, String address) {
        this.id = id;
        this.shopName = shopName;
        this.address = address;
    }

    public Shop_res_dto(String shopName, String address) {
        this.shopName = shopName;
        this.address = address;
    }
}