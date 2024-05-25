package com.monique.prototipo.services.battle;

import java.util.ArrayList;

import com.monique.prototipo.domain.battle.Battle;
import com.monique.prototipo.domain.battle.BattleModel;
import com.monique.prototipo.domain.battle.BattleStateDTO;
import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.domain.player.PlayerModel;
import com.monique.prototipo.exceptions.CannotFindPlayerException;

public class BattleService {
    private PlayerModel playerModel = PlayerModel.instance;
    public static BattleModel battleModel = BattleModel.instance;

    public BattleStateDTO addPlayer(AddPlayerInBattleRequest request, String sessionId) throws CannotFindPlayerException {
        Player player = playerModel.getPlayerById(request.getPlayerId());
        if ( player == null ) {
            throw new CannotFindPlayerException("Player ID doesn't exist.");
        } 

        player.setSessionId(sessionId);
        return battleModel.addPlayerInBattle(request.getPlayerId(), player);
    }

    public BattleStateDTO setTurnActions(TurnActionRequest request) {
        Battle battle = battleModel.getBattleById(request.getBattleId());
        ArrayList<Entity> entitiesChanged = request.getEntities();
        ArrayList<Entity> entitiesInBattle = battle.getEntities();

        if ( request.getPlayerId() != entitiesInBattle.get(battle.getTurn()).getPlayerId() ) {
            return null;
        }
        
        for (int i = 0; i < entitiesChanged.size(); i++) {
            battleModel.updateEntity(request.getBattleId(), entitiesChanged.get(i));
        }

        battle.setRevisedTurn(true);
        return battle.toDTO();
    }

    public BattleStateDTO setPlayerReady(int battleId, int playerId) {
        battleModel.setPlayerReady(battleId, playerId);
        return getBattleById(battleId).toDTO();
    }

    public Battle getBattleById( int battleId ) {
        return battleModel.getBattleById(battleId);
    }
}