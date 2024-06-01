package com.patodesapatos.dungeons.domain;

import java.util.ArrayList;

import com.patodesapatos.dungeons.domain.user.User;
import com.patodesapatos.dungeons.domain.dungeon.Dungeon;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor 
public class Storage {
    
    public static Storage instance = new Storage();
    private ArrayList<User> users = new ArrayList<>();
    private ArrayList<Dungeon> dungeons = new ArrayList<>();

    public void saveUser(User user) {
        this.users.add(user);
    }

    public void saveDungeon(Dungeon dungeon) {
        dungeons.add(dungeon);
    }

    public Dungeon getDungeonById(String id) {
        for (int i = 0; i < dungeons.size(); i++) {
            var dungeon = dungeons.get(i);
            if (dungeon.getId().equals(id)) return dungeon;
        }
        return null;
    }
}
