package com.payme.server_user.DTO;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter 
@Setter
public class ApiResponse<T> {
    
    private boolean status;
    private String message;
    private T resData;
}
