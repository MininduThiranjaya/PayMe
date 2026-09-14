
package com.payme.server_payment.DTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ApiResponse {
    
    boolean status;
    String message;
    Object resData;
}
