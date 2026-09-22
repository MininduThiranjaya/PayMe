package com.payme.server_payment.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;
import com.payme.server_payment.client.UserServiceClient;
import com.payme.server_payment.client.OrderServiceClient;
import com.payme.server_payment.enums.PaymentStatus;
import  com.payme.server_payment.repository.PaymentRepo;
import  com.payme.server_payment.model.PaymentModel;
import com.payme.server_payment.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;

import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.Account;
import com.stripe.model.Charge;
import com.stripe.model.Event;
import com.stripe.model.PaymentIntent;
import com.stripe.model.StripeObject;
import com.stripe.net.Webhook;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StripeWebhookService {

    @Value("${stripe.webhook-secret}")
    private String webhookSecret;
    private final UserServiceClient userServiceClient;
    private final OrderServiceClient orderServiceClient;
    private final PaymentRepo repo;

    public void handleStripeWebhookService(String payload, String signature) {

        Event event = constructWebhookEvent(
                payload,
                signature);
        handleWebhookEvent(event);
    }

    private Event constructWebhookEvent(String payload, String signature) {

        try {
            return Webhook.constructEvent(
                    payload,
                    signature,
                    webhookSecret);
        } catch (SignatureVerificationException e) {

            throw new RuntimeException("Invalid Stripe webhook signature", e);
        }
    }

    private void handleWebhookEvent(Event event) {

        switch (event.getType()) {
            case "account.updated":
                handleAccountUpdatedEvent(event);
                break;
            case "payment_intent.created":
                handlePaymentIntentEvent(event, PaymentStatus.CREATED);
                break;
            case "payment_intent.processing":
                handlePaymentIntentEvent(event, PaymentStatus.PROCESSING);
                break;
            case "payment_intent.succeeded":
                handlePaymentIntentEvent(event, PaymentStatus.SUCCEEDED);
                break;
            case "payment_intent.payment_failed":
                handlePaymentIntentEvent(event, PaymentStatus.FAILED);
                break;
            case "charge.refunded":
                handleChargeRefundedEvent(event);
                break;
            default:
                System.out.println("Unhandled Stripe event: " + event.getType());
                break;
        }
    }

    private StripeObject deserializeStripeObject(Event event) {
        return event
            .getDataObjectDeserializer()
            .getObject()
            .orElseGet(
                () -> {
                    try {
                        return event
                            .getDataObjectDeserializer()
                            .deserializeUnsafe();
                    } catch (Exception e) {
                        throw new RuntimeException("Unable to deserialize Stripe event data: " + event.getType(), e);
                    }
                }
            );
    }

    private void handleAccountUpdatedEvent(Event event) {

        StripeObject stripeObject = deserializeStripeObject(event);
        if (!(stripeObject instanceof Account account)) {
            throw new RuntimeException(
                    "Stripe event object is not an Account");
        }
        handleAccountUpdated(account);
    }

    private void handlePaymentIntentEvent(Event event, PaymentStatus paymentStatus) {

        StripeObject stripeObject = deserializeStripeObject(event);
        if (!(stripeObject instanceof PaymentIntent paymentIntent)) {
            throw new RuntimeException("Stripe event object is not a PaymentIntent");
        }
        updatePaymentStatus(
                paymentIntent,
                paymentStatus
        );
    }

    private void handleAccountUpdated(Account account) {

        String stripeAccountId = account.getId();
        Boolean chargesEnabled = account.getChargesEnabled();
        Boolean payoutsEnabled = account.getPayoutsEnabled();
        Boolean detailsSubmitted = account.getDetailsSubmitted();

        StripeWebhookUpdateAcc_req_dto data = StripeWebhookUpdateAcc_req_dto.builder()
                .stripeId(stripeAccountId)
                .chargesEnabled(chargesEnabled)
                .payoutsEnabled(payoutsEnabled)
                .detailsSubmitted(detailsSubmitted)
                .build();
        userServiceClient.updateMerchantStripeStatus(data);
    }

    @Transactional
    protected void updatePaymentStatus(PaymentIntent paymentIntent, PaymentStatus paymentStatus) {

        String paymentIntentId = paymentIntent.getId();
        PaymentModel payment = repo.findByStripePaymentIntentId(paymentIntentId)
            .orElseThrow(
                () -> new RuntimeException("Payment not found for PaymentIntent: " + paymentIntentId)
            );
        payment.setPaymentStatus(paymentStatus);
        repo.save(payment);
        System.out.println(
                "Payment "
                        + paymentIntentId
                        + " updated to "
                        + paymentStatus
        );
        switch (paymentStatus) {
            case PROCESSING:
                orderServiceClient.setPaymentPending(payment.getOrderId());
                break;
            case SUCCEEDED:
                orderServiceClient.setOrderPaid(payment.getOrderId());
                break;
            case FAILED:
                orderServiceClient.setPaymentFailed(payment.getOrderId());
                break;
            default:
                break;
        }
    }

    private void handleChargeRefundedEvent(Event event) {

        StripeObject stripeObject =deserializeStripeObject(event);
        if (!(stripeObject instanceof Charge charge)) {
            throw new RuntimeException("Stripe event object is not a Charge");
        }
        String paymentIntentId = charge.getPaymentIntent();
        if (paymentIntentId == null) {
            throw new RuntimeException("PaymentIntent ID not found in refunded charge");
        }
        Long amount = charge.getAmount();
        Long amountRefunded = charge.getAmountRefunded();
        if (amount == null || amountRefunded == null) {
            return;
        }
        if (amountRefunded.longValue() != amount.longValue()) {
            System.out.println("Partial refund detected for PaymentIntent: " + paymentIntentId);
            return;
        }
        updateRefundedPayment(paymentIntentId);
    }

    @Transactional
    protected void updateRefundedPayment(String paymentIntentId) {

        PaymentModel payment = repo.findByStripePaymentIntentId(paymentIntentId)
            .orElseThrow(
                () -> new RuntimeException("Payment not found for refunded PaymentIntent: "+ paymentIntentId)
            );
        payment.setPaymentStatus(PaymentStatus.REFUNDED);
        repo.save(payment);
        System.out.println("Payment " + paymentIntentId + " updated to REFUNDED");
    }
}
