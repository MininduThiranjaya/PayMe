package com.payme.server_order.model;

import org.hibernate.annotations.ManyToAny;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "order_item")
@Getter
@Setter
@NoArgsConstructor
public class OrderItemModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @ManyToOne
    @JoinColumn(name = "id", nullable = false)
    private OrderModel order;
    @Column(name = "itemname", nullable = true)
    private String itemName;
    @Column(name = "quantity", nullable = true)
    private int quantity;
    @Column(name = "metric", nullable = false)
    private String metric;
    @Column(name = "unitprice", nullable = false)
    private int unitPrice;
}
