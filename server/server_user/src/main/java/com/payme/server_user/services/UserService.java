package com.payme.server_user.services;

import java.util.Set;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.payme.security.AppUserDetails;
import com.payme.server_user.DTO.req_dto.UserReg_req_dto;
import com.payme.server_user.DTO.res_dto.UserLogin_res_dto;
import com.payme.server_user.DTO.res_dto.UserReg_res_dto;
import com.payme.server_user.error.exceptions.UserAlreadyExistsExc;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.repository.UserRepo;
import com.payme.server_user.services.authServices.JWTService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepo userRepo;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jWTService;
    
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

    public UserLogin_res_dto userLoginService(String nic, String password) {
        
        UserDetails userDetails = jWTService.authenticate(nic, password);
        String token = jWTService.generateToken(userDetails);
        AppUserDetails appUserDetails = (AppUserDetails) userDetails;
        String roles = userDetails.getAuthorities()
            .stream()
            .findFirst()
            .get()
            .getAuthority();
        return new UserLogin_res_dto(token, 36000L, appUserDetails.getUserModel(), roles);
    }
}
