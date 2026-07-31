package com.payme.server_user.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.payme.server_user.model.UserModel;

public interface  UserRepo extends JpaRepository<UserModel, Long> {

    Boolean existsByNic(String nic);
    Optional<UserModel> findByNic(String nic);
}
