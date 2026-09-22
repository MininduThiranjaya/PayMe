package com.payme.server_payment.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientRequestException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.payme.server_payment.DTO.req_dto.StripeWebhookUpdateAcc_req_dto;

@Component
public class OrderServiceClient {

    private final WebClient webClient;

    public OrderServiceClient(
        WebClient.Builder webClientBuilder,
        @Value("${services.order.url}") String orderServiceUrl) {

        this.webClient = webClientBuilder
            .baseUrl(orderServiceUrl)
            .build();
    }

    public void setPaymentPending(long orderId) {

        webClient
            .put()
            .uri("/internal/payment-pending/{orderId}",orderId)
            .retrieve()
            .toBodilessEntity()
            .block();
    }

    public void setOrderPaid(long orderId) {

        webClient
            .put()
            .uri("/internal/payment-paid/{orderId}",orderId)
            .retrieve()
            .toBodilessEntity()
            .block();
    }

    public void setPaymentFailed(long orderId) {

        webClient
            .put()
            .uri("/internal/payment-failed/{orderId}",orderId)
            .retrieve()
            .toBodilessEntity()
            .block();
}
}