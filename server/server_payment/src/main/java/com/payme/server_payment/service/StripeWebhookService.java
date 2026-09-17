package com.payme.server_payment.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.payme.server_payment.client.UserServiceClient;

import com.payme.server_payment.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.Account;
import com.stripe.model.Event;
import com.stripe.model.StripeObject;
import com.stripe.net.Webhook;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StripeWebhookService {

    @Value("${stripe.webhook-secret}")
    private String webhookSecret;
    private final UserServiceClient service;

    public void  handleStripeWebhookService(String payload, String signature) {

        Event event = constructWebhookEvent(
                payload,
                signature
        );
        handleWebhookEvent(event);
    }

    private Event constructWebhookEvent(String payload, String signature) {

        try {
            return Webhook.constructEvent(
                    payload,
                    signature,
                    webhookSecret
            );
        } catch (SignatureVerificationException e) {

            throw new RuntimeException("Invalid Stripe webhook signature", e);
        }
    }

    private void handleWebhookEvent(Event event) {

        switch (event.getType()) {
            case "account.updated":
                handleAccountUpdatedEvent(event);
                break;
            default:
                System.out.println("Unhandled Stripe event: " + event.getType());
                break;
        }
    }

    private void handleAccountUpdatedEvent(Event event) {

        StripeObject stripeObject =
            event
                .getDataObjectDeserializer()
                .getObject()
                .orElse(null);
        if (!(stripeObject instanceof Account account)) {
            throw new RuntimeException("Stripe account data was not found in account.updated event");
        }
        handleAccountUpdated(account);
    }

    private void handleAccountUpdated(Account account) {

        String stripeAccountId = account.getId();
        Boolean chargesEnabled = account.getChargesEnabled();
        Boolean payoutsEnabled = account.getPayoutsEnabled();
        Boolean detailsSubmitted = account.getDetailsSubmitted();
        System.out.println("Stripe account updated: " + stripeAccountId);

        StripeWebhookUpdateAcc_req_dto data =
            StripeWebhookUpdateAcc_req_dto.builder()
                .stripeId(stripeAccountId)
                .chargesEnabled(chargesEnabled)
                .payoutsEnabled(payoutsEnabled)
                .detailsSubmitted(detailsSubmitted)
                .build();
        service.updateMerchantStripeStatus(data);
    }

}
