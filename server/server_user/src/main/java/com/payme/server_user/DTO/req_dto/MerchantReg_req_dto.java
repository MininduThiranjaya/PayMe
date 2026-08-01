package com.payme.server_user.DTO.req_dto;

import java.util.ArrayList;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MerchantReg_req_dto extends UserReg_req_dto{
    
    @NotEmpty(message = "At least one shop name is required")
    private List<
        @NotBlank(message = "Shop name cannot be blank")
        String
    > shopNames = new ArrayList<>();
    @NotEmpty(message = "At least one shop address is required")
    private List<
        @NotBlank(message = "Shop address cannot be blank")
        String
    > addresses = new ArrayList<>();
}
