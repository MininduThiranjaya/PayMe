package com.payme.server_payment.service;

import org.springframework.stereotype.Service;

import com.payme.server_payment.DTO.res_dto.RegStripeConnectAcc_res_dto;
import com.stripe.StripeClient;
import com.stripe.exception.StripeException;
import com.stripe.model.Account;
import com.stripe.model.AccountLink;
import com.stripe.param.AccountCreateParams;
import com.stripe.param.AccountLinkCreateParams;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PaymentService {

    private final StripeClient stripeClient;

    public RegStripeConnectAcc_res_dto regStripeConnectAccountService() {

        try {
            // create Stripe Express connected account
            AccountCreateParams accountParams = AccountCreateParams.builder()
                    .setType(AccountCreateParams.Type.EXPRESS)
                    .build();
            Account account = stripeClient
                    .v1()
                    .accounts()
                    .create(accountParams);
            String stripeAccountId = account.getId();
            // create onboarding link
            AccountLinkCreateParams accountLinkParams = AccountLinkCreateParams.builder()
                    .setAccount(stripeAccountId)
                    .setRefreshUrl("http://localhost:50438/#/merchant/stripe/reg/refresh")
                    .setReturnUrl("http://localhost:50438/#/merchant/stripe/reg/success")
                    .setType(AccountLinkCreateParams.Type.ACCOUNT_ONBOARDING)
                    .build();
            AccountLink accountLink = stripeClient
                    .v1()
                    .accountLinks()
                    .create(accountLinkParams);
            // return useful information
            RegStripeConnectAcc_res_dto response =  RegStripeConnectAcc_res_dto.builder()
                    .stripeId(stripeAccountId)
                    .stripeOnboardingURL(accountLink.getUrl())
                    .chargesEnabled(account.getChargesEnabled())
                    .payoutsEnabled(account.getPayoutsEnabled())
                    .detailsSubmitted(account.getDetailsSubmitted())
                    .build();
            return response;
        } catch (StripeException e) {

            throw new RuntimeException(
                    "Failed to create Stripe Connect account: "+ e.getMessage(), e
            );
        }
    }
}
