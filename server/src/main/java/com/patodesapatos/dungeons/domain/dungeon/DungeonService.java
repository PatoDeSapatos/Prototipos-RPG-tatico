package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.WebSocketSession;

import com.patodesapatos.dungeons.domain.Storage;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.dungeon.dto.DungeonDTO;
import com.patodesapatos.dungeons.domain.dungeon.dto.InventoryDTO;
import com.patodesapatos.dungeons.domain.dungeon.dto.PublicDTO;
import com.patodesapatos.dungeons.domain.dungeon.dto.TileEntityDTO;
import com.patodesapatos.dungeons.domain.dungeon.dto.WaitingDTO;
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
        return dungeon.toWaitingDTO();
    }

    public Dungeon getDungeonById(String string) {
        return storage.getDungeonById(string);
    }

    public DungeonDTO updateEntity(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        if (dungeon == null) return null;
        return dungeon.toDTO(dungeon.updateEntity(data));
    }

    public InventoryDTO getInventory(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        if (dungeon == null) return null;

        var entityId = data.getString("entityId");

        var entity = dungeon.getEntityById(entityId);
        return new InventoryDTO(entityId, entity);
    }

    public void updateInventory(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        var entity = dungeon.getEntityById(String.valueOf(data.get("entityId")));

        if (entity != null) {
            entity.setInventory(data.getJSONArray("inventory"));
        }
    }

    public TileEntityDTO getTileEntity(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        var tileEntId = data.getString("tileEntId");

        var tileEntity = dungeon.getTileEntityById(tileEntId);
        return new TileEntityDTO(tileEntId, tileEntity);
    }

    public void addTileEntity(JSONObject data) {
        var dungeon = getDungeonByInvite(data.getString("invite"));
        var tileEntity = new TileEntity(data.getString("tileEntId"), data.getJSONObject("data"));
        dungeon.addTileEntity(tileEntity);
    }

	public Dungeon joinDungeon(String invite, String username, WebSocketSession session) {
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

        return dungeon;
	}

    public Dungeon getDungeonByInvite(String invite) {
        return storage.getDungeonByInvite(invite);
    }

    public WaitingDTO setPlayerReady(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        if (dungeon == null) return null;

        dungeon.setPlayerReady(username);
        return dungeon.toWaitingDTO();
    }

    public WaitingDTO changeDungeonPrivacy(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        dungeon.setPublic( !dungeon.isPublic() );
        return dungeon.toWaitingDTO();
    }

    public WebSocketDTO leaveDungeon(String invite, String username) {
        var dungeon = getDungeonByInvite(invite);
        dungeon.removePlayer(username);

        if (dungeon.getPlayers().size() <= 0) {
            storage.getDungeons().remove(dungeon);
            return null;
        }

        return (dungeon.isStarted() ? dungeon.toDTO() : dungeon.toWaitingDTO());
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

    public ArrayList<Dungeon> getAll() {
        return storage.getDungeons();
    }

    public ArrayList<PublicDTO> getAllPublic() {
        var publics = new ArrayList<PublicDTO>();

        for (Dungeon dungeon : storage.getDungeons()) {
            if (dungeon.isPublic()) {
                publics.add(new PublicDTO(dungeon));
            }
        }
        return publics;
    }
}