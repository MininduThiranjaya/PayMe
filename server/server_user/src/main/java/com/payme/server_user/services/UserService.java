package com.payme.server_user.services;

import java.util.List;
import java.util.Set;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.payme.server_user.DTO.req_dto.MerchantReg_req_dto;
import com.payme.server_user.DTO.req_dto.UserReg_req_dto;
import com.payme.server_user.DTO.res_dto.CurrentUserProfile_res_dto;
import com.payme.server_user.DTO.res_dto.MerchantReg_res_dto;
import com.payme.server_user.DTO.res_dto.Shop_res_dto;
import com.payme.server_user.DTO.res_dto.UserLogin_res_dto;
import com.payme.server_user.DTO.res_dto.UserReg_res_dto;
import com.payme.server_user.error.exceptions.UserAlreadyExistsExc;
import com.payme.server_user.error.exceptions.UserNotFoundExc;
import com.payme.server_user.model.MerchantModel;
import com.payme.server_user.model.ShopModel;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.repository.MerchantRepo;
import com.payme.server_user.repository.UserRepo;
import com.payme.server_user.services.authServices.JWTService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepo userRepo;
    private final MerchantRepo merchantRepo;
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

    public MerchantReg_res_dto registerMerchantService(MerchantReg_req_dto data) {

        if(userRepo.existsByNic(data.getNic())) {
            throw new UserAlreadyExistsExc(data.getNic());
        }

        List<String> shopNames = data.getShopNames();
        List<String> addresses = data.getAddresses();

        if (shopNames.size() != addresses.size()) {
            throw new IllegalArgumentException(
                "The number of shop names and addresses must be equal"
            );
        }

        MerchantModel user = new MerchantModel();
        UserModel.Role role = UserModel.Role.valueOf(data.getRole());

        if (role != UserModel.Role.MERCHANT) {
            throw new IllegalArgumentException(
                "Merchant registration requires the MERCHANT role"
            );
        }
        
        user.setNic(data.getNic());
        user.setUserName(data.getUserName());
        user.setPassword(passwordEncoder.encode(data.getPassword()));
        user.setRoles(Set.of(role));
        
        for (int i = 0; i < shopNames.size(); i++) {
            ShopModel shop = new ShopModel();

            shop.setShopName(shopNames.get(i));
            shop.setAddress(addresses.get(i));

            user.addShopDetails(shop);
        }

        MerchantModel savedUser = merchantRepo.save(user);

        List<Shop_res_dto> shops = savedUser.getShopDetails()
            .stream()
            .map(shop -> new Shop_res_dto(
                shop.getShopName(),
                shop.getAddress()
            ))
            .toList();

        return new MerchantReg_res_dto(
            savedUser.getNic(),
            savedUser.getUserName(),
            savedUser.getRoles(),
            shops
        );
    }

    public UserLogin_res_dto userLoginService(String nic, String password) {
        
        UserDetails userDetails = jWTService.authenticate(nic, password);
        String token = jWTService.generateToken(userDetails);
        return new UserLogin_res_dto(token);
    }

    public CurrentUserProfile_res_dto getCurrentUserDetailsService(String nic) throws UserNotFoundExc{
        
        UserModel user = userRepo.findByNic(nic)
            .orElseThrow(() -> new UserNotFoundExc(nic));

        if(user.getRoles().contains(UserModel.Role.MERCHANT)) {
            List<Shop_res_dto> shops = ((MerchantModel) user).getShopDetails()
                .stream()
                .map(shop -> new Shop_res_dto(
                    shop.getId(),
                    shop.getShopName(),
                    shop.getAddress()
                ))
                .toList();
            return new CurrentUserProfile_res_dto(
                user.getNic(),
                user.getUserName(),
                user.getRoles(),
                user.getCreatedAt(),
                user.getUpdatedAt(),
                shops
            );
        }
            
        return new CurrentUserProfile_res_dto(
            user.getNic(),
            user.getUserName(),
            user.getRoles(),
            user.getCreatedAt(), 
            user.getUpdatedAt()
        );
    }
}
