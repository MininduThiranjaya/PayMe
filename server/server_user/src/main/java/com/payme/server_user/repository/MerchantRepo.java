package com.payme.server_user.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.payme.server_user.model.MerchantModel;

public interface MerchantRepo extends JpaRepository<MerchantModel, Long> {
    
}
