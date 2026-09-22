package com.payme.server_payment.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.payme.server_payment.model.PaymentModel;

public interface PaymentRepo extends JpaRepository<PaymentModel, Long> {

    Optional<PaymentModel> findByStripePaymentIntentId(String stripePaymentIntentId);
}