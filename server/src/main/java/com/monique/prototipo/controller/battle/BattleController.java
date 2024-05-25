package com.monique.prototipo.controller.battle;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.monique.prototipo.domain.battle.BattleModel;
import com.monique.prototipo.domain.battle.BattleStateDTO;
import com.monique.prototipo.domain.player.PlayerModel;
import com.monique.prototipo.domain.scenario.CreateScenarioRequest;

@RestController
@RequestMapping("battle")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class BattleController {
    
    BattleModel battleModel = BattleModel.instance;
    PlayerModel playerModel = PlayerModel.instance;

    @GetMapping("/{battleId}/state")
    public ResponseEntity<BattleStateDTO> getBattleState(@PathVariable int battleId) {
        return ResponseEntity.ok(battleModel.getBattleById(battleId).toDTO());
    }

    @GetMapping("/{battleId}")
    public ResponseEntity<Boolean> battleExists(@PathVariable String battleId) {
        try {
            return ResponseEntity.ok( battleModel.getBattleById( Integer.parseInt(battleId) ) != null );
        } catch ( Exception e ) {
            return null;
        }
    }

    @PostMapping("/create/{playerId}")
    public ResponseEntity<Integer> createNewBattle(@PathVariable int playerId, @RequestBody CreateScenarioRequest request) {
        return ResponseEntity.ok(battleModel.createBattle(playerModel.getPlayerById(playerId), request));
    }
}
