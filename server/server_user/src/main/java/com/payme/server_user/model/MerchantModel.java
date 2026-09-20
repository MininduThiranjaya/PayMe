package com.payme.server_user.model;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.payme.server_user.enums.MerchantStatus;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "merchant_details")
@Getter
@Setter
@NoArgsConstructor
@OnDelete(
    action = OnDeleteAction.CASCADE
)
public class MerchantModel extends UserModel {

    @OneToMany(
        mappedBy = "merchant",
        cascade = CascadeType.ALL,
        orphanRemoval = true
    )
    @OnDelete(
        action = OnDeleteAction.CASCADE
    )
    private List<ShopModel> shopNames = new ArrayList<>();
    private String stripeAccountId;
    private Boolean chargesEnabled;
    private Boolean payoutsEnabled;
    private Boolean detailsSubmitted;
    @Enumerated(EnumType.STRING)
    private MerchantStatus merchantStatus = MerchantStatus
        .pending_stripe_onboarding;
    public void addShopDetails(ShopModel shop) {
        shopNames.add(shop);
        shop.setMerchant(this);
    }
    public List<ShopModel> getShopDetails() {
        return shopNames;
    }
}