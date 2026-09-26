package com.payme.server_user.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.payme.server_user.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;
import com.payme.server_user.enums.MerchantStatus;
import com.payme.server_user.model.MerchantModel;
import com.payme.server_user.repository.MerchantRepo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MerchantInternalService {

    private final MerchantRepo repo;

    @Transactional
    public void updateStripeStatuService(StripeWebhookUpdateAcc_req_dto data) {

        MerchantModel merchant = repo
                .findByStripeAccountId(data.getStripeId())
                .orElseThrow(() ->
                    new RuntimeException(
                        "Merchant not found for Stripe account: "
                            + data.getStripeId()
                    )
                );
        merchant.setChargesEnabled(data.getChargesEnabled());
        merchant.setPayoutsEnabled(data.getPayoutsEnabled());
        merchant.setDetailsSubmitted(data.getDetailsSubmitted());
        if (
            Boolean.TRUE.equals(data.getDetailsSubmitted())
            &&
            Boolean.TRUE.equals(data.getChargesEnabled())
            &&
            Boolean.TRUE.equals(data.getPayoutsEnabled())
        ) {
            merchant.setMerchantStatus(MerchantStatus.active_stripe_reg);
        } else if (
            Boolean.TRUE.equals(data.getDetailsSubmitted())
        ) {
            merchant.setMerchantStatus(MerchantStatus.pending_stripe_verification);
        } else {
            merchant.setMerchantStatus(MerchantStatus.pending_stripe_onboarding);
        }
        repo.save(merchant);
    }

    public String getMerchantStripeIdByMerchantNicService(String merchantNic) {
        
        MerchantModel merchant = repo
            .findByNic(merchantNic)
            .orElseThrow(
                () -> new RuntimeException(
                    "Merchant not found with NIC: " + merchantNic
                )
            );
        String stripeAccountId = merchant.getStripeAccountId();
        if (stripeAccountId == null || stripeAccountId.isBlank()) {
            throw new RuntimeException("Merchant does not have a Stripe account");
        }
        if (!Boolean.TRUE.equals(merchant.getChargesEnabled())) {
            throw new RuntimeException(
                "Merchant Stripe account is not ready to accept payments"
            );
        }
        return stripeAccountId;
    }
}
