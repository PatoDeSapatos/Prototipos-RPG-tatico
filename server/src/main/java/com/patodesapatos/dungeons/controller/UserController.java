package com.patodesapatos.dungeons.controller;

import java.util.ArrayList;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.patodesapatos.dungeons.domain.user.GuestResponseDTO;
import com.patodesapatos.dungeons.domain.user.LoginDTO;
import com.patodesapatos.dungeons.domain.user.LoginResponseDTO;
import com.patodesapatos.dungeons.domain.user.RegisterDTO;
import com.patodesapatos.dungeons.domain.user.User;
import com.patodesapatos.dungeons.domain.user.UserService;

import com.patodesapatos.dungeons.domain.auth.TokenService;

@RestController
@RequestMapping("user")
public class UserController {
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private TokenService tokenService;
    public UserService userService = new UserService();

    @PostMapping("/register")
    public ResponseEntity<LoginResponseDTO> register(@RequestBody RegisterDTO data) {
        if( userService.getUserByUsername(data.username()) != null ) return ResponseEntity.badRequest().build();

        String encryptedPassword = new BCryptPasswordEncoder().encode(data.password());
        User user = new User(data.username(), encryptedPassword);
        userService.saveUser(user);
        String token = tokenService.generateToken(user);

        return ResponseEntity.ok(new LoginResponseDTO(token)); 
    }

    @PostMapping("/guest")
    public ResponseEntity<GuestResponseDTO> registerGuest() {
        Boolean validUsername = false;
        String username;
        do {
            username = "Guest-".concat( RandomStringUtils.randomAlphanumeric(6).toUpperCase() );
            if ( userService.getUserByUsername(username) != null ) {
                validUsername = true;
            }
        } while (validUsername);

        String password = RandomStringUtils.randomAlphanumeric(10);
        String encryptedPassword = new BCryptPasswordEncoder().encode(password);
        User user = new User(username, encryptedPassword);
        userService.saveUser(user);
        String token = tokenService.generateToken(user);

        return ResponseEntity.ok(new GuestResponseDTO(username, password, token));
    }

    @PostMapping("/guest/remove")
    public void removeGuest(@RequestBody String username) {
        User guest = userService.getUserByUsername(username);
        if ( guest != null && guest.isGuestUser() ) {
            userService.removeUser( guest );
        }
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginDTO data) {
        var usernamePassword = new UsernamePasswordAuthenticationToken(data.username(), data.password());
        var auth = this.authenticationManager.authenticate(usernamePassword);
        String token = tokenService.generateToken((User) auth.getPrincipal());

        return ResponseEntity.ok(new LoginResponseDTO(token));
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<Boolean> checkUsernameExists(@PathVariable String username) {
        return ResponseEntity.ok(userService.getUserByUsername(username) != null);
    }

    @GetMapping
    public ResponseEntity<ArrayList<User>> getAll() {
        return ResponseEntity.ok(userService.getAll());
    }
}
