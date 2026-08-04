package com.payme.server_user.services;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.payme.server_user.DTO.req_dto.MerchantReg_req_dto;
import com.payme.server_user.DTO.req_dto.MerchantShop_req_dto;
import com.payme.server_user.DTO.req_dto.UserReg_req_dto;
import com.payme.server_user.DTO.res_dto.CurrentUserProfile_res_dto;
import com.payme.server_user.DTO.res_dto.MerchantReg_res_dto;
import com.payme.server_user.DTO.res_dto.Shop_res_dto;
import com.payme.server_user.DTO.res_dto.UserLogin_res_dto;
import com.payme.server_user.DTO.res_dto.UserReg_res_dto;
import com.payme.server_user.error.exceptions.BadCredentialsExc;
import com.payme.server_user.error.exceptions.UserAlreadyExistsExc;
import com.payme.server_user.error.exceptions.UserNotUpdatedExc;
import com.payme.server_user.model.MerchantModel;
import com.payme.server_user.model.ShopModel;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.repository.MerchantRepo;
import com.payme.server_user.repository.UserRepo;
import com.payme.server_user.services.authServices.JWTService;
import jakarta.persistence.EntityManager;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepo userRepo;
    private final MerchantRepo merchantRepo;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jWTService;
    private final EntityManager entityManager;
    
    public UserReg_res_dto registerCustomerService(UserReg_req_dto data) {

        if(userRepo.existsByNic(data.getNic())) {
            throw new UserAlreadyExistsExc(data.getNic());
        }

        UserModel user = new UserModel();
        UserModel.Role role = UserModel.Role.valueOf(data.getRole());

        if (role != UserModel.Role.CUSTOMER) {
            throw new IllegalArgumentException(
                "Customer registration requires the CUSTOMER role"
            );
        }
        
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
        user.setRoles(new HashSet<>(Set.of(role)));
        
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
        
        try {
            UserDetails userDetails = jWTService.authenticate(nic, password);
            String token = jWTService.generateToken(userDetails);
            return new UserLogin_res_dto(token);
        } catch (BadCredentialsException exception) {
            throw new BadCredentialsExc("INVALID_CREDENTIALS", "Invalid NIC or password");
        }
    }

    @Transactional(readOnly = true)
    public CurrentUserProfile_res_dto getCurrentUserDetailsService(String nic) throws BadCredentialsExc {
        
        UserModel user = userRepo.findByNic(nic)
            .orElseThrow(() -> new BadCredentialsExc("USER_NOT_FOUND", "User not found: " + nic));
        return buildCurrentUserProfile(user);
    }

    @Transactional
    public CurrentUserProfile_res_dto updateUserRoleToMerchantService(String nic, MerchantShop_req_dto data) throws BadCredentialsExc {
        
        UserModel user = userRepo.findByNic(nic)
            .orElseThrow(() -> new BadCredentialsExc("USER_NOT_FOUND", "User not found: " + nic));
        if (data.getShopNames().size() != data.getAddresses().size()) {
            throw new IllegalArgumentException(
                "The number of shop names must match the number of addresses"
            );
        }
        long userId = user.getId();
        try{
            entityManager.flush();
            merchantRepo.createMerchantRecord(userId);
            entityManager.clear();
            MerchantModel merchant = merchantRepo.findById(userId)
            .orElseThrow(() -> new IllegalStateException(
                "User could not be converted into a merchant"
            ));
            Set<UserModel.Role> updatedRoles =new HashSet<>(merchant.getRoles());
            updatedRoles.add(UserModel.Role.MERCHANT);
            merchant.setRoles(updatedRoles);
            for (int i = 0; i < data.getShopNames().size(); i++) {
                ShopModel shop = new ShopModel();
                shop.setShopName(data.getShopNames().get(i).trim());
                shop.setAddress(data.getAddresses().get(i).trim());
                merchant.addShopDetails(shop);
            }
            MerchantModel savedMerchant = merchantRepo.saveAndFlush(merchant);
            return buildCurrentUserProfile(savedMerchant);
        } catch(DataAccessException e) {
            throw new UserNotUpdatedExc(user.getNic(), e.getMessage());
        }
    }

    @Transactional
    public CurrentUserProfile_res_dto updateUserRoleToCustomerService(String nic) throws BadCredentialsExc {
        
        UserModel user = userRepo.findByNic(nic)
            .orElseThrow(() -> new BadCredentialsExc("USER_NOT_FOUND", "User not found: " + nic));
        try{
            Set<UserModel.Role> updatedRoles =
            new HashSet<>(user.getRoles());
            updatedRoles.add(UserModel.Role.CUSTOMER);
            user.setRoles(updatedRoles);
            UserModel savedUser = userRepo.saveAndFlush(user);
            return buildCurrentUserProfile(savedUser);
        } catch(DataAccessException e) {
            throw new UserNotUpdatedExc(user.getNic(), e.getMessage()); 
        }
    }

    private CurrentUserProfile_res_dto buildCurrentUserProfile(UserModel user) {

        if (user instanceof MerchantModel merchant) {
            List<Shop_res_dto> shops = merchant.getShopDetails()
                .stream()
                .map(shop -> new Shop_res_dto(
                    shop.getId(),
                    shop.getShopName(),
                    shop.getAddress()
                ))
                .toList();
            return new CurrentUserProfile_res_dto(
                merchant.getNic(),
                merchant.getUserName(),
                merchant.getRoles(),
                merchant.getCreatedAt(),
                merchant.getUpdatedAt(),
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
    