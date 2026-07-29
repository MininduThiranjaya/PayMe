package com.payme.server_user.DTO.req_dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserLogin_req_dto {
    
    @NotBlank(message = "NIC is required")
    private String nic;
    @NotBlank(message = "Password is required")
    private String password;
}
