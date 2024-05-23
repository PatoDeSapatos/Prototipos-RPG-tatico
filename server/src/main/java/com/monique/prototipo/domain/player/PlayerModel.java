package com.monique.prototipo.domain.player;

import java.util.ArrayList;
import java.util.List;

public class PlayerModel {
    private ArrayList<Player> players = new ArrayList<>();

    public int savePlayer(String username) {
        Player newPlayer = new Player(players.size(), username);
        players.add(newPlayer);
        return newPlayer.getId();
    }

    public List<Player> getAll() {
        return players;
    }

    public Player getPlayerById(int id) {
        if ( id >= players.size() ) return null;
        
        Player player = players.get(id);
        return player;
    }
}
