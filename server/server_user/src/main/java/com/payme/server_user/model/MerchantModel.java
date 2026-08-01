package com.payme.server_user.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="merchant_details")
@Getter
@Setter
@NoArgsConstructor
public class MerchantModel extends UserModel{
    
    @OneToMany(
        mappedBy = "merchant",
        cascade = CascadeType.ALL,
        orphanRemoval = true
    )
    private List<ShopModel> shopNames = new ArrayList<>();

    public void addShopDetails(ShopModel shop) {
        shopNames.add(shop);
        shop.setMerchant(this);
    }

    public List<ShopModel> getShopDetails() {
        return shopNames;
    }
}
