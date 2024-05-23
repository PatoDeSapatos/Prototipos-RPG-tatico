package com.monique.prototipo.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.domain.player.PlayerModel;

@RestController
@RequestMapping("player")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class PlayerController { 

    static PlayerModel playerModel = new PlayerModel();

    public PlayerController() {
        savePlayer("Felipe");
        savePlayer("Monique");
    }

    @PostMapping("/save/{username}")
    public int savePlayer(@PathVariable String username) {
        return playerModel.savePlayer(username);
    }

    @GetMapping
    public List<Player> getAll() {
        List<Player> playerList = playerModel.getAll();
        return playerList;
    }
}