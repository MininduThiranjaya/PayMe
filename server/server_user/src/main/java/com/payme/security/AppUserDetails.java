package com.payme.security;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.payme.server_user.model.UserModel;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class AppUserDetails implements UserDetails {
    
    public final UserModel userModel;

    public UserModel getUserModel() {
        return userModel;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {

        return userModel.getRoles()
            .stream()
            .map(role -> new SimpleGrantedAuthority("ROLE_" + role.name()))
            .toList();
    }

    @Override
    public String getPassword() {
        return userModel.getPassword();
    }

    @Override
    public String getUsername() {
        return userModel.getNic();
    }

    public String getDisplayUserName() {
        return userModel.getUserName();
    }
}
