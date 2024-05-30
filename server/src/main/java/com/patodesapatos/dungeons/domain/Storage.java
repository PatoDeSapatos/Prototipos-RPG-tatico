package com.patodesapatos.dungeons.domain;

import java.util.ArrayList;

import com.patodesapatos.dungeons.domain.User.User;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor 
public class Storage {
    
    public static Storage instance = new Storage();
    private ArrayList<User> users = new ArrayList<>();

    public void saveUser(User user) {
        this.users.add(user);
    }
}
