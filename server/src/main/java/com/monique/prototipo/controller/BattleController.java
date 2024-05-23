package com.monique.prototipo.controller;

import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.monique.prototipo.domain.battle.Battle;
import com.monique.prototipo.domain.battle.BattleModel;
import com.monique.prototipo.domain.battle.BattleStateDTO;
import com.monique.prototipo.domain.battle.TurnActionRequest;
import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.scenario.CreateScenarioRequest;
import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.domain.player.PlayerModel;

@RestController
@RequestMapping("battle")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class BattleController {
    private BattleModel battleModel = new BattleModel();
    private PlayerModel playerModel = PlayerController.playerModel;

    @PostMapping("/{battleId}/add/{playerId}")
    public ResponseEntity<Entity> addPlayer(@PathVariable int battleId, @PathVariable int playerId) {
        Player player = playerModel.getPlayerById(playerId);
        if ( player == null ) return null;

        Entity playerEntity = battleModel.addPlayerInBattle(battleId, player);
        return ResponseEntity.ok(playerEntity);
    }

    @PostMapping("/{battleId}/turnAction")
    public ResponseEntity<String> setTurnActions(@PathVariable int battleId, @RequestBody TurnActionRequest request) {
        Battle battle = battleModel.getBattleById(battleId);
        ArrayList<Entity> entitiesChanged = request.entities();
        ArrayList<Entity> entitiesInBattle = battle.getEntities();

        if ( request.playerId() != entitiesInBattle.get(battle.getTurn()).playerId() ) {
            return ResponseEntity.badRequest().build();
        }
        
        for (int i = 0; i < entitiesChanged.size(); i++) {
            battleModel.updateEntity(battleId, entitiesChanged.get(i));
        }

        battle.setRevisedTurn(true);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{battleId}/{playerId}/ready")
    public ResponseEntity<String> setPlayerReady(@PathVariable int battleId, @PathVariable int playerId) {
        battleModel.setPlayerReady(battleId, playerId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{battleId}/state")
    public ResponseEntity<BattleStateDTO> getBattleState(@PathVariable int battleId) throws InterruptedException, ExecutionException {
        CompletableFuture<ResponseEntity<BattleStateDTO>> cf = new CompletableFuture<>();
        battleModel.getBattleById(battleId).getCfs().add(cf);
        return cf.get();
    }

    @PostMapping("/create/{playerId}")
    public ResponseEntity<Integer> createNewBattle(@PathVariable int playerId, @RequestBody CreateScenarioRequest request) {
        return ResponseEntity.ok(battleModel.createBattle(playerModel.getPlayerById(playerId), request));
    }
}