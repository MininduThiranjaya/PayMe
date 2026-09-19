package com.payme.server_user.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.payme.security.AppUserDetails;
import com.payme.server_user.DTO.ApiResponse;
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
    public ResponseEntity<ApiResponse<UserReg_res_dto>> regUserControl(@Valid @RequestBody UserReg_req_dto data) {
        
        UserReg_res_dto savedUser =  userService.registerCustomerService(data);
        ApiResponse response = ApiResponse.<UserReg_res_dto>builder()
            .status(true)
            .message("Customer registered successfully")
            .resData(savedUser)
            .build();
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reg/merchant")
    public ResponseEntity<ApiResponse<MerchantReg_res_dto>> regMerchantControl(@Valid @RequestBody MerchantReg_req_dto data) {
        
        MerchantReg_res_dto savedUser =  userService.registerMerchantService(data);
        ApiResponse<MerchantReg_res_dto> response = ApiResponse.<MerchantReg_res_dto>builder()
            .status(true)
            .message("Merchant registered successfully")
            .resData(savedUser)
            .build();
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserLogin_res_dto>> userLoginController(@Valid @RequestBody UserLogin_req_dto data) {
        
        UserLogin_res_dto loggedUser = userService.userLoginService(data.getNic(), data.getPassword());
        ApiResponse response = ApiResponse.<UserLogin_res_dto>builder()
            .status(true)
            .message("User loggedin successfully")
            .resData(loggedUser)
            .build();
        return ResponseEntity.ok(response); 
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<CurrentUserProfile_res_dto>> getCurrentUserDetailsController(@AuthenticationPrincipal AppUserDetails currentUser) {
        
        CurrentUserProfile_res_dto currentUserDetails = userService.getCurrentUserDetailsService(currentUser.getUsername());
        ApiResponse response = ApiResponse.<CurrentUserProfile_res_dto>builder()
            .status(true)
            .message("Get authoriz user succssfully")
            .resData(currentUserDetails)
            .build();
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('CUSTOMER')")
    @PutMapping("/update/role-merchant")
    public ResponseEntity<ApiResponse<CurrentUserProfile_res_dto>> updateUserRoleToMerchantController(@AuthenticationPrincipal AppUserDetails currentUser, @Valid @RequestBody MerchantShop_req_dto data) {

        CurrentUserProfile_res_dto updatedUserCustomer = userService.updateUserRoleToMerchantService(currentUser.getUsername(), data);
        ApiResponse response = ApiResponse.<CurrentUserProfile_res_dto>builder()
            .status(true)
            .message("Customer add additional role merchant successfully")
            .resData(updatedUserCustomer)
            .build();
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('MERCHANT')")
    @PutMapping("/update/role-customer")
    public ResponseEntity<ApiResponse<CurrentUserProfile_res_dto>> updateUserRoleToCustomerController(@AuthenticationPrincipal AppUserDetails currentUser) {

        CurrentUserProfile_res_dto updatedUserMerchant = userService.updateUserRoleToCustomerService(currentUser.getUsername());
        ApiResponse response = ApiResponse.<CurrentUserProfile_res_dto>builder()
            .status(true)
            .message("Merchant add additional role customer successfully")
            .resData(updatedUserMerchant)
            .build();
        return ResponseEntity.ok(response);
    }
}
