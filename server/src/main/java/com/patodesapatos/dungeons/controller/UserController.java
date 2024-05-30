package com.patodesapatos.dungeons.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.patodesapatos.dungeons.domain.User.RegisterDTO;
import com.patodesapatos.dungeons.domain.User.User;
import com.patodesapatos.dungeons.domain.User.UserService;
import com.patodesapatos.dungeons.domain.User.LoginDTO;
import com.patodesapatos.dungeons.domain.User.LoginResponseDTO;
import com.patodesapatos.dungeons.services.TokenService;

@RestController
@RequestMapping("user")
public class UserController {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private TokenService tokenService;
    public static UserService userService = new UserService();

    @PostMapping("/register")
    public ResponseEntity<LoginResponseDTO> register(@RequestBody RegisterDTO data) {
        if( userService.getUserByUsername(data.username()) != null ) return ResponseEntity.badRequest().build();

        String encryptedPassword = new BCryptPasswordEncoder().encode(data.password());
        User user = new User(data.username(), encryptedPassword);
        userService.saveUser(user);
        String token = tokenService.generateToken(user);

        return ResponseEntity.ok(new LoginResponseDTO(token)); 
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginDTO data) {
        var usernamePassword = new UsernamePasswordAuthenticationToken(data.username(), data.password());
        var auth = this.authenticationManager.authenticate(usernamePassword);
        String token = tokenService.generateToken((User) auth.getPrincipal());

        return ResponseEntity.ok(new LoginResponseDTO(token));
    }

    @GetMapping
    public ResponseEntity<ArrayList<User>> getAll() {
        return ResponseEntity.ok(userService.getAll());
    }
}
