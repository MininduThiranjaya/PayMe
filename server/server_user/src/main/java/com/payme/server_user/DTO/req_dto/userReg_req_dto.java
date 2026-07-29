package com.payme.server_user.DTO.req_dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class userReg_req_dto {
    
    @NotBlank(message = "NIC is required")
    private String nic;
    @NotBlank(message = "Password is required")
    @Size(min = 4, message = "Password must be at least 4 characters long")
    private String password;
    @NotBlank(message = "User name is required")
    private String userName;
    @NotBlank(message = "Role is required")
    private String role;
}
