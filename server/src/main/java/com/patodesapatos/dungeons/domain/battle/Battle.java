package com.patodesapatos.dungeons.domain.battle;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.patodesapatos.dungeons.domain.battle.dto.BattleDTO;
import com.patodesapatos.dungeons.domain.battle.dto.BattleStartDTO;
import com.patodesapatos.dungeons.domain.dungeon.Player;

import lombok.Data;

@Data
public class Battle {
    private int id;
    private JSONObject room;
    private ArrayList<Player> players;
    private HashMap<Integer, JSONObject> units = new HashMap<>();
    private HashMap<Integer, JSONObject> eUnits = new HashMap<>();

    public Battle(int id, JSONObject room, ArrayList<Player> players, JSONArray units, JSONArray eUnits) {
        this.id = id;
        this.room = room;
        this.players = players;

        for (var player : players) {
            player.setBattleId(id);
        }

        for (int i = 0; i < units.length(); i++) {
            var unit = units.getJSONObject(i);
            this.units.put(unit.getInt("id"), unit);
        }

        for (int i = 0; i < eUnits.length(); i++) {
            var unit = eUnits.getJSONObject(i);
            this.eUnits.put(unit.getInt("id"), unit);
        }
    }

    public boolean add(Player player, JSONArray units) {
        if (player.getBattleId() != -1 || players.contains(player)) return false;

        players.add(player);
        player.setBattleId(id);

        for (int i = 0; i < units.length(); i++) {
            var unit = units.getJSONObject(i);
            this.units.put(unit.getInt("id"), unit);
        }
        return true;
    }

    public void updateUnit(JSONObject unit) {
        if (unit.getBoolean("is_player")) {
            units.put(unit.getInt("id"), unit);
        } else {
            eUnits.put(unit.getInt("id"), unit);
        }
    }

    public BattleDTO toDTO() {
        return new BattleDTO(this);
    }

    public BattleStartDTO toStartDTO() {
        return new BattleStartDTO(this);
    }
}
