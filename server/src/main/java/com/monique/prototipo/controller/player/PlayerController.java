package com.monique.prototipo.controller.player;

import java.util.List;

import org.springframework.http.ResponseEntity;
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
    
    PlayerModel playerModel = PlayerModel.instance;

    @GetMapping("/{playerId}")
    public ResponseEntity<Boolean> playerExists(@PathVariable String playerId) {
        try {
            return ResponseEntity.ok( playerModel.getPlayerById( Integer.parseInt(playerId)) != null );
        } catch ( Exception e ) {
            return null;
        }
    }

    @GetMapping
    public List<Player> getAll() {
        List<Player> playerList = playerModel.getAll();
        return playerList;
    }

    @PostMapping("/save/{username}")
    public int savePlayer(@PathVariable String username) {
        return playerModel.savePlayer(username);
    }
}
