package com.payme.server_user.services;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.payme.security.AppUserDetails;
import com.payme.server_user.model.UserModel;
import com.payme.server_user.repository.UserRepo;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class LoadUserServices implements UserDetailsService {

    private final UserRepo userRepo;
    
    @Override
    public UserDetails loadUserByUsername(String nic) throws UsernameNotFoundException {

        UserModel user = userRepo.findByNic(nic)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + nic));
        return new AppUserDetails(user);
    }
}
