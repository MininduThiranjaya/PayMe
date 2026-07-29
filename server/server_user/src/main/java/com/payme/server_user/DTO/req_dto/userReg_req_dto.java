package com.payme.server_user.DTO.req_dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
public class UserReg_req_dto {
    
    @NotBlank(message = "NIC is required")
    private String nic;
    @NotBlank(message = "Password is required")
    @Size(min = 4, message = "Password must be at least 4 characters long")
    private String password;
    @NotBlank(message = "User name is required")
    private String userName;
    @NotBlank(message = "Role is required")
    private String role;

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
