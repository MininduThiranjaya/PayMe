package com.payme.server_order.service;

import org.springframework.stereotype.Service;

import com.payme.server_order.DTO.req_dto.NewOrderItem_req_dto;
import com.payme.server_order.DTO.req_dto.NewOrder_req_dto;
import com.payme.server_order.DTO.res_dto.NewOrderItem_res_dto;
import com.payme.server_order.DTO.res_dto.NewOrder_res_dto;
import com.payme.server_order.error.exceptions.OrderNotFoundExc;
import com.payme.server_order.error.exceptions.OrderNotSavedExc;
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
        try {
            OrderModel savedOrder = orderRepo.save(orderModel);
            return savedOrder.getId();
        } catch (Exception e) {
            throw new OrderNotSavedExc("ORDER_NOT_SAVED", "Order could not be saved");
        }
    }

    public NewOrder_res_dto getOrderByIdService(long id) {
        
        
        OrderModel orderModel = orderRepo.findById(id)
            .orElseThrow(() -> new OrderNotFoundExc("ORDER_NOT_FOUND", "Order not found"));
        NewOrder_res_dto order = new NewOrder_res_dto();
        order.setId(orderModel.getId());
        order.setMerchantId(orderModel.getMerchatId());
        order.setCustomerId(orderModel.getCustomerId());
        for(OrderItemModel orderItemModel: orderModel.getOrderItem()) {
            NewOrderItem_res_dto orderItem = new NewOrderItem_res_dto();
            orderItem.setId(orderItemModel.getId());
            orderItem.setItemName(orderItemModel.getItemName());
            orderItem.setItemMetric(orderItemModel.getMetric());
            orderItem.setQuantity(orderItemModel.getQuantity());
            orderItem.setUnitPrice(orderItemModel.getUnitPrice());
            order.getOrderItem().add(orderItem);
        }
        return order;
    }
}
