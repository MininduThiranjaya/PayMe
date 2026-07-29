package com.payme.server_user.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.server_user.DTO.req_dto.userReg_req_dto;
import com.payme.server_user.services.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("payme/api/user")
@RequiredArgsConstructor
public class UserController {
    
    private final UserService userService;

    @PostMapping("reg")
    public String regUserControl(@Valid @RequestBody userReg_req_dto data) {
        return userService.registerUserService(data);
    }
    

}
