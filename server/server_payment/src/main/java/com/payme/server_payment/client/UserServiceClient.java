package com.payme.server_payment.client;

import com.payme.server_payment.DTO.ApiResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientRequestException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.payme.server_payment.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;

@Component
public class UserServiceClient {

    private final WebClient webClient;

    public UserServiceClient(
        WebClient.Builder webClientBuilder,
        @Value("${services.user.url}") String userServiceUrl) {

        this.webClient = webClientBuilder
            .baseUrl(userServiceUrl)
            .build();
    }

    public void updateMerchantStripeStatus(StripeWebhookUpdateAcc_req_dto data) {

        webClient
            .put()
            .uri("internal/merchant/update/stripe-status")
            .bodyValue(data)
            .retrieve()
            .toBodilessEntity()
            .block();
    }

    public String getMerchantStripeId(String merchantNic) {

        try {
            ApiResponse<String> response =
                webClient
                    .get()
                    .uri("/internal/merchant/stripe-id/{merchantNic}", merchantNic)
                    .retrieve()
                    .bodyToMono(
                        new ParameterizedTypeReference<
                            ApiResponse<String>
                        >() {}
                    )
                    .block();
            if (response == null) {
                throw new RuntimeException("User Service returned an empty response");
            }
            if (!response.isStatus()) {
                throw new RuntimeException(
                    "User Service request failed: " + response.getMessage()
                );
            }
            if (response.getResData() == null ||response.getResData().isBlank()) {
                throw new RuntimeException("Merchant Stripe account ID was not returned");
            }
            return response.getResData();
        } catch (WebClientResponseException e) {
            throw new RuntimeException(
                "User Service HTTP error " + e.getStatusCode() + ": " + e.getResponseBodyAsString(), e
            );
        } catch (WebClientRequestException e) {
            throw new RuntimeException(
                "Could not connect to User Service: " + e.getMessage(), e
            );

        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(
                "User Service communication failed: " + e.getClass().getSimpleName() + " - " + e.getMessage(), e
            );
        }
    }
}