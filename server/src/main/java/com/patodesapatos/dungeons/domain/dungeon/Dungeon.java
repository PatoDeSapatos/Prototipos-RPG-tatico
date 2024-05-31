package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;

import org.apache.commons.lang3.RandomStringUtils;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class Dungeon {
    private ArrayList<String> usersId;
    private String dungeonInvite;
    private boolean waiting;
    private boolean isPublic;

    public Dungeon(boolean isPublic, String userId) {
        dungeonInvite = randomInvite();
        this.waiting = true;
        this.isPublic = isPublic;

        this.usersId = new ArrayList<>();
        this.usersId.add(userId);
    }

    public String randomInvite() {
        return RandomStringUtils.randomAlphanumeric(4);
    }
}