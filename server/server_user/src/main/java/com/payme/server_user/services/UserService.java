package com.payme.server_user.services;

import org.springframework.stereotype.Service;

import com.payme.server_user.DTO.req_dto.userReg_req_dto;
import com.payme.server_user.repository.UserRepo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepo userRepo;
    
    public String registerUserService(userReg_req_dto data) {
        return "done";
    }
}
