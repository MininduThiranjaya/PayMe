package com.payme.server_payment.service;

import java.time.LocalDateTime;
import org.springframework.stereotype.Service;

import com.payme.server_payment.model.PaymentModel;
import com.payme.server_payment.enums.PaymentStatus;

import com.payme.server_payment.DTO.res_dto.RegStripeConnectAcc_res_dto;
import com.payme.server_payment.DTO.req_dto.PaymentReadyDetails_req_dto;
import com.payme.server_payment.DTO.req_dto.MakePayment_req_dto;
import com.payme.server_payment.DTO.res_dto.MakePayment_res_dto;
import com.stripe.StripeClient;
import com.stripe.exception.StripeException;
import com.stripe.model.Account;
import com.payme.server_payment.client.OrderServiceClient;
import com.payme.server_payment.client.UserServiceClient;
import com.stripe.model.AccountLink;
import com.stripe.param.AccountCreateParams;
import com.stripe.param.AccountLinkCreateParams;
import com.payme.server_payment.repository.PaymentRepo;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PaymentService {

    private final StripeClient stripeClient;
    private final OrderServiceClient orderServiceClient;
    private final UserServiceClient userServiceClient;
    private final PaymentRepo repo;

    public RegStripeConnectAcc_res_dto regStripeConnectAccountService() {

        try {
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

    public MakePayment_res_dto makePaymentService(MakePayment_req_dto data) {

        long orderId = data.getOrderId();
        PaymentReadyDetails_req_dto orderDetails = orderServiceClient.getPaymentDetailsByOrderId(orderId);
        validateQrTime(orderDetails.getCreatedAt());
        long totalAmount = orderDetails.getTotalAmount();
        if (totalAmount <= 0) {
            throw new RuntimeException( "Invalid payment amount");
        }
        String merchantNic = orderDetails.getMerchantNic();
        if (merchantNic == null || merchantNic.isBlank()) {
            throw new RuntimeException("Merchant NIC was not found for this order");
        }
        String stripeAccountId = userServiceClient.getMerchantStripeId(merchantNic);
        if (stripeAccountId == null || stripeAccountId.isBlank()) {
            throw new RuntimeException("Merchant Stripe account was not found");
        }
        PaymentIntentCreateParams params = PaymentIntentCreateParams
                .builder()
                .setAmount(totalAmount)
                .setCurrency("lkr")
                .putMetadata("orderId", String.valueOf(orderId))
                .setTransferData(PaymentIntentCreateParams
                        .TransferData
                        .builder()
                        .setDestination(stripeAccountId)
                        .build()
                )
                .build();
        PaymentIntent paymentIntent;
        try {
            paymentIntent = stripeClient
                .v1()
                .paymentIntents()
                .create(params);
        } catch (Exception e) {
            throw new RuntimeException(
                    "Failed to create Stripe payment: " + e.getMessage(), e
            );
        }
        PaymentModel payment = new PaymentModel();
        payment.setOrderId(orderId);
        payment.setAmount(totalAmount);
        payment.setStripePaymentIntentId(paymentIntent.getId());
        payment.setPaymentStatus(PaymentStatus.CREATED);
        try {
            repo.save(payment);
        } catch (Exception e) {
            throw new RuntimeException(
                    "Payment was created in Stripe but could not be saved", e
            );
        }
        return MakePayment_res_dto
            .builder()
            .orderId(orderId)
            .amount(totalAmount)
            .paymentIntentId(paymentIntent.getId())
            .clientSecret(paymentIntent.getClientSecret())
            .build();
    }

    private void validateQrTime(LocalDateTime createdAt) {

        if (createdAt == null) {
                throw new RuntimeException("QR code creation time was not found");
        }
        LocalDateTime expiryTime = createdAt.plusMinutes(5);
        LocalDateTime currentTime = LocalDateTime.now();
        if (currentTime.isAfter(expiryTime)) {
            throw new RuntimeException("Cannot proceed with payment. QR code is invalid or expired");
        }
    }
}
