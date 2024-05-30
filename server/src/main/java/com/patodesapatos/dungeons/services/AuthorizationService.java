package com.patodesapatos.dungeons.services;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.patodesapatos.dungeons.controller.UserController;
import com.patodesapatos.dungeons.domain.User.UserService;

@Service
public class AuthorizationService implements UserDetailsService {

    private UserService service = UserController.userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return service.getUserByUsername(username);
    }
    
}
