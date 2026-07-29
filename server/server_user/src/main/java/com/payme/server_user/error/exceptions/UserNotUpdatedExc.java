package com.payme.server_user.error.exceptions;

public class UserNotUpdatedExc extends RuntimeException {
    
    public UserNotUpdatedExc(String nic, String reason) {
        super("User with NIC: " + nic + " could not be updated: " + reason);
    }
}
