package com.payme.server_payment.security;

import com.stripe.StripeClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class StripeConfig {

    @Bean
    public StripeClient stripeClient(@Value("${stripe.api-key}") String stripeApiKey) {
        return new StripeClient(stripeApiKey);
    }
}
