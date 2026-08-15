package com.payme.server_order.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.payme.server_order.model.OrderModel;

public interface OrderRepo extends JpaRepository<OrderModel, Long>{
    
}
