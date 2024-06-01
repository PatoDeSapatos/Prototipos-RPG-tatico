package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.patodesapatos.dungeons.domain.Storage;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.user.UserService;

@Service
public class DungeonService {
    private Storage storage = Storage.instance;
    @Autowired
    private UserService userService;

    public WaitingDTO createDungeon(boolean isPublic, String username, String sessionId) {
        var user = userService.getUserByUsername(username);
        user.setSessionId(sessionId);
        var dungeon = new Dungeon(isPublic, user.getId());
        storage.saveDungeon(dungeon);
        return new WaitingDTO(dungeon);
    }

    public Dungeon getDungeonById(String string) {
        return storage.getDungeonById(string);
    }

    public DungeonDTO updateEntity(JSONObject data) {
        var dungeon = getDungeonById(data.getString("dungeonId"));
        dungeon.updateEntity(data);
        return dungeon.toDTO();
    }

	public WebSocketDTO joinDungeon(String dungeonId, String username, String sessionId) {
        var dungeon = getDungeonById(dungeonId);
        var user = userService.getUserByUsername(username);
        user.setSessionId(sessionId);
        dungeon.addUserId(user.getId());

        if (dungeon.isWaiting()) return new WaitingDTO(dungeon);
        else return dungeon.toDTO();
	}
}