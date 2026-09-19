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
public class OrderService {

    private final OrderRepo orderRepo;


    @Transactional
    public long setNewOrderService(NewOrder_req_dto data, Jwt jwt) {

        String merchantNic = jwt.getSubject();
        OrderModel orderModel = new OrderModel();
        orderModel.setMerchantNic(merchantNic);
        for (NewOrderItem_req_dto orderItem : data.getOrderItem()) {
            OrderItemModel orderItemModel = new OrderItemModel();
            orderItemModel.setItemName(orderItem.getItemName());
            orderItemModel.setQuantity(orderItem.getQuantity());
            orderItemModel.setMetric(
                    orderItem
                            .getItemMetric()
                            .name());
            orderItemModel.setUnitPrice(orderItem.getUnitPrice());
            orderItemModel.setOrder(orderModel);
            orderModel
                    .getOrderItem()
                    .add(orderItemModel);
        }
        try {
            OrderModel savedOrder = orderRepo.save(orderModel);
            return savedOrder.getId();
        } catch (Exception e) {
            throw new OrderNotSavedExc(
                    "ORDER_NOT_SAVED",
                    "Order could not be saved");
        }
    }

    @Transactional
    public CustomerClaimOrder_res_dto customerClaimNewOrderService(CustomerClaimOrder_req_dto data, Jwt jwt) {

        String customerNic = jwt.getSubject();
        OrderModel order = orderRepo.findById(
            data.getOrderId())
            .orElseThrow(() -> new OrderNotFoundExc("ORDER_NOT_FOUND", "Order not found"));
        if (order.getStatus() != OrderStatus.CREATED) {
            throw new RuntimeException("Order is no longer available");
        }
        order.setCustomerNic(customerNic);
        order.setStatus(OrderStatus.CLAIMED);
        OrderModel savedOrder = orderRepo.save(order);
        List<OrderItem_res_dto> items = new ArrayList<>();
        long totalAmount = 0;
        for (OrderItemModel item : savedOrder.getOrderItem()) {
            long totalPrice = (long) item.getQuantity()* item.getUnitPrice();
            totalAmount += totalPrice;
            OrderItem_res_dto itemDto = OrderItem_res_dto.builder()
                    .id(item.getId())
                    .itemName(item.getItemName())
                    .quantity(item.getQuantity())
                    .metric( item.getMetric())
                    .unitPrice(item.getUnitPrice())
                    .totalPrice(totalPrice)
                    .build();
            items.add(itemDto);
        }
        return CustomerClaimOrder_res_dto
                .builder()
                .orderId(savedOrder.getId())
                .merchantNic(savedOrder.getMerchantNic())
                .customerNic(savedOrder.getCustomerNic())
                .status(savedOrder.getStatus())
                .orderItems(items)
                .totalAmount(totalAmount)
                .createdAt(savedOrder.getCreatedAt())
                .build();
    }
}
