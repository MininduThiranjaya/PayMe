package com.payme.server_user.services;

import java.util.Set;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.payme.server_user.DTO.req_dto.UserReg_req_dto;
import com.payme.server_user.DTO.res_dto.UserReg_res_dto;
import com.payme.server_user.error.exceptions.UserAlreadyExistsExc;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.repository.UserRepo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepo userRepo;
    private final PasswordEncoder passwordEncoder;
    
    public UserReg_res_dto registerUserService(UserReg_req_dto data) {

        if(userRepo.existsByNic(data.getNic())) {
            throw new UserAlreadyExistsExc(data.getNic());
        }

        UserModel user = new UserModel();
        UserModel.Role role = UserModel.Role.valueOf(data.getRole());
        
        user.setNic(data.getNic());
        user.setUserName(data.getUserName());
        user.setPassword(passwordEncoder.encode(data.getPassword()));
        user.setRoles(Set.of(role));

        UserModel savedUser = userRepo.save(user);

        return new UserReg_res_dto(
            savedUser.getNic(),
            savedUser.getUserName(),
            savedUser.getRoles()
        );
    }
}
