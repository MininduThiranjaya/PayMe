
package com.payme.server_order.service;

import java.util.*;

import org.springframework.stereotype.Service;

import com.payme.server_order.DTO.req_dto.CustomerClaimOrder_req_dto;
import com.payme.server_order.DTO.req_dto.NewOrderItem_req_dto;
import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.DTO.res_dto.CustomerClaimOrder_res_dto;
import com.payme.server_order.DTO.res_dto.OrderItem_res_dto;
import com.payme.server_order.enums.OrderStatus;
import com.payme.server_order.error.exceptions.OrderNotFoundExc;
import com.payme.server_order.error.exceptions.OrderNotSavedExc;
import com.payme.server_order.model.OrderItemModel;
import com.payme.server_order.model.OrderModel;
import com.payme.server_order.repository.OrderRepo;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.security.oauth2.jwt.Jwt;

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
}
