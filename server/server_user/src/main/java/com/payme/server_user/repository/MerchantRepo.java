package com.payme.server_user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.payme.server_user.model.MerchantModel;


public interface MerchantRepo extends JpaRepository<MerchantModel, Long> {
    
    @Modifying
    @Query(
        value = """
            INSERT INTO merchant_details (id)
            VALUES (:userId)
            ON CONFLICT (id) DO NOTHING
                """,
                nativeQuery=true
    ) int createMerchantRecord(@Param("userId") long userId);
}
