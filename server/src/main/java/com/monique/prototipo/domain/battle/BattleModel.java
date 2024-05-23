package com.monique.prototipo.domain.battle;

import java.util.ArrayList;

import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.domain.scenario.CreateScenarioRequest;
import com.monique.prototipo.domain.scenario.Scenario;

public class BattleModel {
    private ArrayList<Battle> battles = new ArrayList<>();
    
    public BattleModel() {
        Battle newBattle = new Battle(
            battles.size(),
            new Scenario(new CreateScenarioRequest(5, 5))
        );
        battles.add(newBattle);
    }

    public int createBattle(Player player, CreateScenarioRequest request) {
        Battle newBattle = new Battle(battles.size(), new Scenario(request));
        battles.add(newBattle);
        addPlayerInBattle(newBattle.getId(), player);
        return newBattle.getId();
    }

    public Entity addPlayerInBattle(int battleId, Player player) {
        Battle battle = battles.get(battleId);
        Scenario scenario = battle.getScenario();
        Entity entity;
        int x = -1;
        int y = -1;

        if (!battle.getPlayers().contains(player)) {
            battle.addPlayer(player);
        } else {
            return null;
        }

        for (int i = 0; i < scenario.getWidth(); i++) {
            for (int j = 0; j < scenario.getHeight(); j++) {
                if (scenario.getMap()[i][j] == null) {
                    x = i;
                    y = j;
                    entity = new Entity(battle.getEntities().size(), player.getId(), player.getId(), x, y, x, y);
                    battle.addEntity(entity);
                    scenario.getMap()[i][j] = entity;
                    return entity; 
                }
            }
        }


        return null;
    }

    public void updateEntity(int battleId, Entity entity) {
        Battle battle = battles.get(battleId);
        battle.updateEntity(entity);
    }

    public Scenario getBattleScenario(int battleId) {
        return battles.get(battleId).getScenario();
    }

    public ArrayList<Battle> getAll() {
        return battles;
    }

    public Battle getBattleById(int battleId) {
        return battles.get(battleId);
    }

    public void setPlayerReady(int battleId, int playerId) {
        Battle battle = getBattleById(battleId);
        ArrayList<Player> players = battle.getPlayers();
        int readyPlayers = 0;

        for(int i = 0; i < players.size(); i++) {
            if ( players.get(i).getId() == playerId ) {
                battle.getPlayers().get(i).setReady(true);
            }

            if (battle.getPlayers().get(i).isReady()) {
                readyPlayers++;
            }
        }

        if ( readyPlayers >= players.size() ) {
            battle.nextTurn(); 

            if ( battle.getTurn() >= battle.getEntities().size() ) {
                battle.setTurn(0);
            }
        }
    }
}
