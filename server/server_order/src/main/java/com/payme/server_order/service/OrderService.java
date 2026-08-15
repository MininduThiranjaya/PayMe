package com.payme.server_order.service;

import org.springframework.stereotype.Service;

import com.payme.server_order.DTO.req_dto.NewOrderItem_req_dto;
import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.model.OrderItemModel;
import com.payme.server_order.model.OrderModel;
import com.payme.server_order.repository.OrderRepo;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class OrderService {

    private final OrderRepo orderRepo;
    
    public long setNewOrderService(NewOrder_req_dto data) {
        
        OrderModel orderModel = new OrderModel();
        orderModel.setMerchatId(data.getMerchantId());
        orderModel.setCustomerId(data.getCustomerId());
        for(NewOrderItem_req_dto orderItem: data.getOrderItem()) {
            OrderItemModel orderItemModel = new OrderItemModel();
            orderItemModel.setItemName(orderItem.getItemName());
            orderItemModel.setQuantity(orderItem.getQuantity());
            orderItemModel.setMetric(orderItem.getItemMetric().name());
            orderItemModel.setUnitPrice(orderItem.getUnitPrice());
            orderItemModel.setOrder(orderModel);
            orderModel.getOrderItem().add(orderItemModel);
        }
        OrderModel savedOrder = orderRepo.save(orderModel);
        return  savedOrder.getId();
    }
}
