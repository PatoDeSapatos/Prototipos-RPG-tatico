package com.patodesapatos.dungeons.domain.User;

import java.util.ArrayList;

import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.patodesapatos.dungeons.domain.Storage;

@Service
public class UserService {
    private Storage storage = Storage.instance;

    @Bean
    private void initialiazeDb() {
        saveUser(new User("PatoDeSapatos", new BCryptPasswordEncoder().encode("123456")));
    }

    public ArrayList<User> getAll() {
        return storage.getUsers();
    }

    public String saveUser(User user) {
        storage.getUsers().add(user);
        return user.getId();
    }

    public String loginUser(String username, String password) {
        User user = getUserByUsername(username);
        if (user == null || !user.getPassword().equals(password)) return null;

        return user.getId();
    } 

    public User getUserById(String userId) {
        for (int i = 0; i < storage.getUsers().size(); i++) {
            if ( storage.getUsers().get(i).getId().equals(userId) ) {
                return storage.getUsers().get(i);
            }
        }
        return null;
    }

    public User getUserByUsername(String username) {
        for (int i = 0; i < storage.getUsers().size(); i++) {
            if ( storage.getUsers().get(i).getUsername().equals(username) ) {
                return storage.getUsers().get(i);
            }
        }
        return null;
    }

    public void setPlayerOnline(String username, String sessionId) {
        getUserByUsername(username).setSessionId(sessionId);
    }
}


