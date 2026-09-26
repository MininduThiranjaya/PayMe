
package com.payme.server_order.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.payme.server_order.DTO.res_dto.PaymentReadyDetails_res_dto;
import com.payme.server_order.enums.OrderStatus;
import com.payme.server_order.model.OrderModel;
import com.payme.server_order.repository.OrderRepo;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class OrderInternalService {
    
    private final OrderRepo orderRepo;

    private OrderModel getOrderById(long orderId) {

        return orderRepo
                .findById(orderId)
                .orElseThrow(
                    () ->
                        new RuntimeException(
                            "Order not found: "
                                + orderId
                        )
                );
    }

    @Transactional
    public void setOrderPaymentPendingService(long orderId) {

        OrderModel order = getOrderById(orderId);
        if (order.getStatus() == OrderStatus.PAID) {
            throw new RuntimeException("Order is already paid");
        }
        if (order.getStatus() == OrderStatus.CANCELLED) {
            throw new RuntimeException("Cancelled order cannot be processed");
        }
        order.setStatus(OrderStatus.PAYMENT_PENDING);
        orderRepo.save(order);
    }

    @Transactional
    public void setOrderPaymentPaidService(long orderId) {

        OrderModel order = getOrderById(orderId);
        if (order.getStatus() == OrderStatus.PAID) {
            return;
        }
        if (order.getStatus() == OrderStatus.CANCELLED) {
            throw new RuntimeException("Cancelled order cannot be marked as paid"
            );
        }
        order.setStatus(OrderStatus.PAID);
        orderRepo.save(order);
    }

    @Transactional
    public void setOrderPaymentFailedService(long orderId) {

        OrderModel order =getOrderById(orderId);
        if (order.getStatus() == OrderStatus.PAID) {
            return;
        }
        if (order.getStatus() == OrderStatus.CANCELLED) {
            return;
        }
        order.setStatus(OrderStatus.CLAIMED);
        orderRepo.save(order);
    }

    @Transactional
    public PaymentReadyDetails_res_dto getPaymentDetailsByOrderIdService(long orderId) {

        OrderModel order = orderRepo
            .findById(orderId)
            .orElseThrow(
                () -> new RuntimeException(
                    "Order not found: " + orderId
                )
            );
        if (order.getStatus() != OrderStatus.CLAIMED) {
            throw new RuntimeException(
                "Order is not ready for payment. Current status: " + order.getStatus()
            );
        }
        long totalAmount = order
            .getOrderItem()
            .stream()
            .mapToLong(
                item -> (long) (item.getQuantity() * item.getUnitPrice())
            )
            .sum();
        return PaymentReadyDetails_res_dto
                .builder()
                .merchantNic(order.getMerchantNic())
                .totalAmount(totalAmount)
                .createdAt(order.getCreatedAt())
                .build();
    }
}
