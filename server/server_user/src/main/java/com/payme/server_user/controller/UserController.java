package com.payme.server_user.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.security.AppUserDetails;
import com.payme.server_user.DTO.req_dto.MerchantReg_req_dto;
import com.payme.server_user.DTO.req_dto.MerchantShop_req_dto;
import com.payme.server_user.DTO.req_dto.UserLogin_req_dto;
import com.payme.server_user.DTO.req_dto.UserReg_req_dto;
import com.payme.server_user.DTO.res_dto.CurrentUserProfile_res_dto;
import com.payme.server_user.DTO.res_dto.MerchantReg_res_dto;
import com.payme.server_user.DTO.res_dto.UserLogin_res_dto;
import com.payme.server_user.DTO.res_dto.UserReg_res_dto;
import com.payme.server_user.services.UserService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;


@RestController
@RequestMapping("payme/api/user")
@RequiredArgsConstructor
public class UserController {
    
    private final UserService userService;


    @PostMapping("/reg/customer")
    public ResponseEntity<UserReg_res_dto> regUserControl(@Valid @RequestBody UserReg_req_dto data) {
        
        UserReg_res_dto savedUser =  userService.registerCustomerService(data);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/reg/merchant")
    public ResponseEntity<MerchantReg_res_dto> regMerchantControl(@Valid @RequestBody MerchantReg_req_dto data) {
        
        MerchantReg_res_dto savedUser =  userService.registerMerchantService(data);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/login")
    public ResponseEntity<UserLogin_res_dto> userLoginController(@Valid @RequestBody UserLogin_req_dto data) {
        
        UserLogin_res_dto loggedUser = userService.userLoginService(data.getNic(), data.getPassword());
        return ResponseEntity.ok(loggedUser); 
    }

    @GetMapping("/me")
    public ResponseEntity<CurrentUserProfile_res_dto> getCurrentUserDetailsController(@AuthenticationPrincipal AppUserDetails currentUser) {
        
        CurrentUserProfile_res_dto currentUserDetails = userService.getCurrentUserDetailsService(currentUser.getUsername());
        return ResponseEntity.ok(currentUserDetails);
    }

    @PutMapping("/update/role-merchant")
    public ResponseEntity<CurrentUserProfile_res_dto> updateUserRoleToMerchantController(@AuthenticationPrincipal AppUserDetails currentUser, @Valid @RequestBody MerchantShop_req_dto data) {

        CurrentUserProfile_res_dto updatedUserCustomer = userService.updateUserRoleToMerchantService(currentUser.getUsername(), data);
        return ResponseEntity.ok(updatedUserCustomer);
    }

    @PutMapping("/update/role-customer")
    public ResponseEntity<CurrentUserProfile_res_dto> updateUserRoleToCustomerController(@AuthenticationPrincipal AppUserDetails currentUser) {

        CurrentUserProfile_res_dto updatedUserMerchant = userService.updateUserRoleToCustomerService(currentUser.getUsername());
        return ResponseEntity.ok(updatedUserMerchant);
    }

    @GetMapping("/test")
    public String testApi() {
        return "only for testing purpose";
    }
    
}
