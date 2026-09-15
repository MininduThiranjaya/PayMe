package com.payme.server_user.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientRequestException;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.payme.server_user.DTO.ApiResponse;
import com.payme.server_user.DTO.res_dto.RegStripeConnectAcc_res_dto;

@Component
public class PaymentServiceClient {

    private final WebClient webClient;

    public PaymentServiceClient(WebClient.Builder webClientBuilder,
            @Value("${services.payment.url}") String paymentServiceUrl
    ) {

        this.webClient = webClientBuilder
                .baseUrl(paymentServiceUrl)
                .build();
    }

    public RegStripeConnectAcc_res_dto registerStripeConnectAccount() {

        try {
            ApiResponse<RegStripeConnectAcc_res_dto> response =
                webClient
                    .get()
                    .uri("reg/stripe-connect-acc")
                    .retrieve()
                    .bodyToMono(
                            new ParameterizedTypeReference<
                                    ApiResponse<RegStripeConnectAcc_res_dto>
                            >() {}
                    )
                    .block();
            if (response == null) {
                throw new RuntimeException(
                    "Payment Service returned an empty response"
                );
            }
            if (!response.isStatus()) {
                throw new RuntimeException(
                    "Payment Service request failed: "
                        + response.getMessage()
                );
            }
            if (response.getResData() == null) {
                throw new RuntimeException(
                    "Stripe Connect account data was not returned"
                );
            }
            return response.getResData();

        } catch (WebClientResponseException e) {

            throw new RuntimeException(
                "Payment Service HTTP error "
                    + e.getStatusCode()
                    + ": "
                    + e.getResponseBodyAsString(),
                e
            );

        } catch (WebClientRequestException e) {

            throw new RuntimeException(
                "Could not connect to Payment Service: "
                    + e.getMessage(),
                e
            );

        } catch (Exception e) {

            throw new RuntimeException(
                "Payment Service communication failed: "
                    + e.getClass().getSimpleName()
                    + " - "
                    + e.getMessage(),
                e
            );
        }
    }
}