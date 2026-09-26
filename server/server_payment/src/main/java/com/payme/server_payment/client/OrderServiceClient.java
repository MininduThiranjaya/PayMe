package com.payme.server_payment.client;

import com.payme.server_payment.DTO.req_dto.PaymentReadyDetails_req_dto;
import com.payme.server_payment.DTO.ApiResponse;

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

    public PaymentReadyDetails_req_dto getPaymentDetailsByOrderId(long orderId) {

        try {
            ApiResponse<PaymentReadyDetails_req_dto> response =
                webClient
                    .put()
                    .uri("/internal/get-order-details/{orderId}", orderId)
                    .retrieve()
                    .bodyToMono(
                        new ParameterizedTypeReference<
                            ApiResponse<
                                PaymentReadyDetails_req_dto
                            >
                        >() {}
                    )
                    .block();
            if (response == null) {
                throw new RuntimeException("Order Service returned an empty response");
            }
            if (!response.isStatus()) {
                throw new RuntimeException(
                    "Order Service request failed: "
                        + response.getMessage()
                );
            }
            if (response.getResData() == null) {
                throw new RuntimeException("Order payment ready data was not returned");
            }
            return response.getResData();
        } catch (WebClientResponseException e) {
            throw new RuntimeException(
                "Order Service HTTP error " + e.getStatusCode() + ": " + e.getResponseBodyAsString(), e
            );
        } catch (WebClientRequestException e) {
            throw new RuntimeException(
                "Could not connect to Order Service: " + e.getMessage(), e
            );
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(
                "Order Service communication failed: " + e.getClass().getSimpleName() + " - " + e.getMessage(), e
            );
        }
    }
}