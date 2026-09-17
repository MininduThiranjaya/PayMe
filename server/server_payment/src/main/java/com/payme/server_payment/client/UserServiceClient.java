package com.payme.server_payment.client;

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
            .uri(
                "internal/merchant/update/stripe-status"
            )
            .bodyValue(data)
            .retrieve()
            .toBodilessEntity()
            .block();
    }
}