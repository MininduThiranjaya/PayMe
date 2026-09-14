package com.payme.server_user.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.payme.server_user.DTO.ApiResponse;
import com.payme.server_user.DTO.res_dto.RegStripeConnectAcc_res_dto;

@Component
public class PaymentServiceClient {

    private final WebClient webClient;

    public PaymentServiceClient(
            WebClient.Builder webClientBuilder,
            @Value("${services.payment.url}") String paymentServiceUrl) {
        this.webClient = webClientBuilder
                .baseUrl(paymentServiceUrl)
                .build();
    }

    public RegStripeConnectAcc_res_dto registerStripeConnectAccount() {

        try {
            ApiResponse<RegStripeConnectAcc_res_dto> response =
                webClient
                    .post()
                    .uri("/auth/reg/stripe-connect-acc")
                    .retrieve()
                    .onStatus(
                        HttpStatusCode::isError,
                        clientResponse ->
                            clientResponse
                                .bodyToMono(String.class)
                                .map(body ->
                                    new RuntimeException(
                                            "Payment service error: " + body
                                    )
                                )
                    )
                    .bodyToMono(
                        new ParameterizedTypeReference<
                            ApiResponse<RegStripeConnectAcc_res_dto>
                        >() {}
                    )
                    .block();
            if (response == null) {
                throw new RuntimeException(
                    "Payment service returned an empty response"
                );
            }
            if (!response.isStatus()) {
                throw new RuntimeException(
                    "Payment service request failed: " + response.getMessage()
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
                "Payment service returned HTTP "
                    + e.getStatusCode()
                    + ": "
                    + e.getResponseBodyAsString(),
                e
            );

        } catch (Exception e) {

            throw new RuntimeException(
                "Failed to communicate with Payment Service",
                e
            );
        }
    }
}