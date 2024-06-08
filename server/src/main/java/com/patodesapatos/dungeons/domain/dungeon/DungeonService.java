package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.WebSocketSession;

import com.patodesapatos.dungeons.domain.Storage;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.user.UserService;

@Service
public class DungeonService {
    private Storage storage = Storage.instance;
    @Autowired
    private UserService userService;

    public WaitingDTO createDungeon(String username, WebSocketSession session) {
        var user = userService.getUserByUsername(username);
        var dungeon = new Dungeon(new Player(user));

        user.setSessionId(session.getId());
        session.getAttributes().put("dungeonId", dungeon.getId());

        storage.saveDungeon(dungeon);
        return new WaitingDTO(dungeon);
    }

    public Dungeon getDungeonById(String string) {
        return storage.getDungeonById(string);
    }

    public DungeonDTO updateEntity(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        dungeon.updateEntity(data);
        return dungeon.toDTO();
    }

	public WebSocketDTO joinDungeon(String invite, String username, WebSocketSession session) {
        var dungeon = getDungeonByInvite(invite);
        var user = userService.getUserByUsername(username);

        if (dungeon == null) return null;

        user.setSessionId(session.getId());
        session.getAttributes().put("dungeonId", dungeon.getId());

        Player player = dungeon.getPlayerByUsername(username);
        if (player == null) {
            dungeon.addPlayer(new Player(user));
        } else {
            player.setOnline(true);
        }

        if (dungeon.isStarted()) return dungeon.toDTO();
        else return new WaitingDTO(dungeon);
	}

    public Dungeon getDungeonByInvite(String invite) {
        return storage.getDungeonByInvite(invite);
    }

    public WaitingDTO setPlayerReady(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        if (dungeon == null) return null;

        dungeon.setPlayerReady(username);
        return new WaitingDTO(dungeon);
    }

    public WaitingDTO changeDungeonPrivacy(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        dungeon.setPublic( !dungeon.isPublic() );
        return new WaitingDTO(dungeon);
    }

    public WebSocketDTO leaveDungeon(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        dungeon.removePlayer(username);

        if (dungeon.getPlayers().size() <= 0) {
            storage.getDungeons().remove(dungeon);
            return null;
        }

        return (dungeon.isStarted() ? (dungeon.toDTO()) : (new WaitingDTO(dungeon)));
    }

    public void leaveDungeon(WebSocketSession session) {
        var dungeonId = (String) session.getAttributes().get("dungeonId");
        if (dungeonId == null) return;

        var dungeon = getDungeonById(dungeonId);
        if (dungeon == null) return;

        var username = userService.getUserBySessionId(session.getId()).getUsername();
        if (username == null) return;

        dungeon.removePlayer(username);

        if (dungeon.getPlayers().size() <= 0) {
            storage.getDungeons().remove(dungeon);
        }
    }
}