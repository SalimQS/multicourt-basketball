/*
      Credit:
      - Salim
      - P4lw4 (for helping me)

      if u remove this, u nerd.
*/
#include <a_samp>
#include <streamer>
#include <foreach>
#include <Pawn.CMD> //u also can use zcmd or y_cmd
#include <sscanf2>

#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_WHITEP 		0xFFE4C4FF
#define COLOR_ORANGE   		0xDB881AFF
#define COLOR_ORANGE2		0xFF5000FF
#define COLOR_IVORY 		0xFFFF82FF
#define COLOR_LIME 			0xD2D2ABFF
#define COLOR_BLUE			0x004BFFFF
#define COLOR_SBLUE			0x56A4E4FF
#define COLOR_LBLUE 		0x33CCFFFF
#define COLOR_RCONBLUE      0x0080FF99
#define COLOR_PURPLE2 		0x5A00FFFF
#define COLOR_PURPLE      	0xD0AEEBFF
#define COLOR_RED 			0xFF0000FF
#define COLOR_LRED 			0xE65555FF
#define COLOR_LIGHTGREEN 	0x00FF00FF
#define COLOR_YELLOW 		0xFFFF00FF
#define COLOR_YELLOW2 		0xF5DEB3FF
#define COLOR_LB 			0x15D4EDFF
#define COLOR_PINK			0xEE82EEFF
#define COLOR_PINK2		 	0xFF828200
#define COLOR_GOLD			0xFFD700FF
#define COLOR_FIREBRICK 	0xB22222FF
#define COLOR_GREEN 		0x3BBD44FF
#define COLOR_GREY			0xBABABAFF
#define COLOR_GREY2 		0x778899FF
#define COLOR_GREY3			0xC8C8C8FF
#define COLOR_DARK 			0x7A7A7AFF
#define COLOR_BROWN 		0x8B4513FF
#define COLOR_SYSTEM 		0xEFEFF7FF
#define COLOR_RADIO       	0x8D8DFFFF
#define COLOR_FAMILY		0x00F77AFF

#define FAMILY_E	"{F77AFF}"
#define PURPLE_E2	"{7348EB}"
#define RED_E 		"{FF0000}"
#define BLUE_E 		"{004BFF}"
#define SBLUE_E 	"{56A4E4}"
#define PINK_E 		"{FFB6C1}"
#define YELLOW_E 	"{FFFF00}"
#define LG_E 		"{00FF00}"
#define LB_E 		"{15D4ED}"
#define LB2_E 		"{87CEFA}"
#define GREY_E 		"{BABABA}"
#define GREY2_E 	"{778899}"
#define GREY3_E 	"{C8C8C8}"
#define DARK_E 		"{7A7A7A}"
#define WHITE_E 	"{FFFFFF}"
#define WHITEP_E 	"{FFE4C4}"
#define IVORY_E 	"{FFFF82}"
#define ORANGE_E 	"{DB881A}"
#define ORANGE_E2	"{FF5000}"
#define GREEN_E 	"{3BBD44}"
#define PURPLE_E 	"{5A00FF}"
#define LIME_E 		"{D2D2AB}"
#define LRED_E		"{E65555}"
#define DOOM_		"{F4A460}"
#define MATHS       "{3571FC}"
#define REACTIONS   "{FD4141}"

#define     MAX_BASKETBALL_FIELD        1 //add it when u wanna make more court
enum BasketStruct
{
 	FieldName[50],
	Float:Ring1Pos[3],
	Float:DunkPos1[3],
	Float:MissBallPos1[3],
	Float:Ring2Pos[3],
	Float:DunkPos2[3],
	Float:MissBallPos2[3],
	Float:BallDefaultPos[3],
	Float:Ring1DownBall[3],
	Float:Ring2DownBall[3],
	Float:BallPosNow[3],
	Point[2],
	Float:MaxPosX,
	Float:MinPosX,
	Float:MaxPosY,
	Float:MinPosY,
}

new bsObject[MAX_BASKETBALL_FIELD];
new bsData[MAX_BASKETBALL_FIELD][BasketStruct] =
{
	{"East Los Santos BasketBall Court", {2290.482910, -1514.774291, 28.875000}, {2290.56, -1514.91, 26.87}, {2289.982910, -1514.774291, 28.875000}, {2290.683105, -1541.114257, 28.875000}, {2290.64, -1541.00, 26.87}, {2291.183105, -1541.114257, 28.875000}, {2290.482910, -1528.274291, 26.075000}, {2290.482910, -1514.774291, 26.075000}, {2290.683105, -1541.074218, 26.075000}, {2290.482910, -1528.274291, 26.075000}, {0, 0}, 2300.0, 2280.0, -1513.0, -1542.0}
};

new PlayerHaveBall[MAX_PLAYERS];
new PlayerCourt[MAX_PLAYERS];
new PlayerTimer[MAX_PLAYERS];
new PlayerShooting[MAX_PLAYERS];

new YangDiInvite[MAX_PLAYERS];
new YangInvite[MAX_PLAYERS];

public OnFilterScriptInit()
{
    LoadAllBasketField();
    printf("//------------------------------\n\n\tBasket Script By Salim\n\n//------------------------------");
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerCourt[playerid] = -1;
}

public OnPlayerDisconnect(playerid, reason)

{
    new id = GetPlayerCourt(playerid);
	if(id != -1)
	{
	   	EndBasket(id);
	}
}

public OnPlayerDeath(playerid, killerid, reason)
{
    new id = GetPlayerCourt(playerid);
	if(id != -1)
	{
	   	EndBasket(id);
	}

}

LoadAllBasketField()
{
	for(new i = 0; i < MAX_BASKETBALL_FIELD; i++)
	{
	    bsObject[i] = CreateDynamicObject(2114, bsData[i][BallDefaultPos][0], bsData[i][BallDefaultPos][1], bsData[i][BallDefaultPos][2], 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
		new string[300];
		format(string, sizeof string, ""YELLOW_E"[ID : %d]\n"WHITE_E"%s\ntype "YELLOW_E"'/basket' "WHITE_E"to play.", i, bsData[i][FieldName]);
		CreateDynamic3DTextLabel(string, 0xFFFFFFFF, bsData[i][BallDefaultPos][0], bsData[i][BallDefaultPos][1], bsData[i][BallDefaultPos][2], 10.0);
	}
}

GetPlayerCourt(playerid)
{
	return PlayerCourt[playerid];
}

EndBasket(id)
{
	bsData[id][Point][0] = 0;
	bsData[id][Point][1] = 0;
	MoveDynamicObject(bsObject[id], bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2], 10.0);

	foreach(new i : Player)
	{
	    if(PlayerCourt[i] == id)
	    {
		    PlayerHaveBall[i] = 0;
		    PlayerShooting[i] = 0;
		    PlayerCourt[i] = -1;
		    KillTimer(PlayerTimer[i]);
		    GameTextForPlayer(i, "Game is over", 5000, 3);
		}
	}
}

GetNearestBasketField(playerid, Float: radius = 0.0)
{
	if(radius == 0.0)
		radius = FLOAT_INFINITY;

	new bsid = -1;

	new Float: dist;

	for(new idx; idx < MAX_BASKETBALL_FIELD; idx ++)
	{
		dist =	GetPlayerDistanceFromPoint(playerid, bsData[idx][BallDefaultPos][0], bsData[idx][BallDefaultPos][1], bsData[idx][BallDefaultPos][2]);
		if(dist < radius)
		{
			radius = dist,
			bsid = idx;
		}
	}
	return bsid;
}

StartPlayBasketball(playerid, id, otherid=INVALID_PLAYER_ID)
{
	if(!IsPlayerInRangeOfPoint(playerid, 20.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	    return SendClientMessage(playerid, -1, "[Error] You're not on any basketball court");

	if(otherid != INVALID_PLAYER_ID)
	{//duel
	    //pemain 1
        SetPlayerPos(playerid, bsData[id][DunkPos1][0], bsData[id][DunkPos1][1], bsData[id][DunkPos1][2]);
	    SetPlayerAngleToCoordinates(playerid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1]);

		//pemain 2
		SetPlayerPos(otherid, bsData[id][DunkPos2][0], bsData[id][DunkPos2][1], bsData[id][DunkPos2][2]);
	    SetPlayerAngleToCoordinates(otherid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1]);

		PlayerCourt[playerid] = id;
		PlayerCourt[otherid] = id;
		PlayerHaveBall[playerid] = 1;
		PlayerHaveBall[otherid] = 0;
		PlayerTimer[playerid] = SetTimerEx("PlayerBasketUpdate", 1000, true, "i", playerid);
		PlayerTimer[otherid] = SetTimerEx("PlayerBasketUpdate", 1000, true, "i", otherid);
	}
	else
	{//solo
	    SetPlayerPos(playerid, bsData[id][DunkPos1][0], bsData[id][DunkPos1][1], bsData[id][DunkPos1][2]);
	    SetPlayerAngleToCoordinates(playerid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1]);

		PlayerCourt[playerid] = id;
		PlayerHaveBall[playerid] = 1;
		PlayerTimer[playerid] = SetTimerEx("PlayerBasketUpdate", 1000, true, "i", playerid);
	}
	return 1;
}

new bawahatas[MAX_PLAYERS];

forward PlayerBasketUpdate(playerid);
public PlayerBasketUpdate(playerid)
{
    if(PlayerHaveBall[playerid] == 1)
    {
	    new id = PlayerCourt[playerid];
	    new Float: x2, Float: y2, Float: z2;
		GetPlayerPos(playerid, x2, y2, z2);
        GetXYZInFrontPlayer(playerid, x2, y2);
		switch(bawahatas[playerid])
		{
		    case 0://bawah
		    {
                MoveDynamicObject(bsObject[id], x2, y2, z2, 50.0);
                bawahatas[playerid] = 1;
		    }
		    case 1: //atas
		    {
                MoveDynamicObject(bsObject[id], x2, y2, z2-1.0, 50.0);
                bawahatas[playerid] = 0;
		    }
		}
		new Keys, ud, lr;
		GetPlayerKeys(playerid, Keys, ud, lr);
		if(Keys == 0)
		{
		    if(PlayerShooting[playerid] == 0)
		    {
		    	ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop",4.1, 1, 1, 1, 1, 1, 1);
			}
		}
	}
	else
	{
	    if(PlayerCourt[playerid] != -1)
	    {
		    new Keys, ud, lr;
			GetPlayerKeys(playerid, Keys, ud, lr);
			if(Keys == 0)
			{
	  			if(PlayerShooting[playerid] == 0)
		    	{
				    ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop",4.0, 1, 1, 1, 1, 0, 1);
				}
			}
		}
	}
    return 1;
}

PlayerShot(playerid)
{
    new id = PlayerCourt[playerid];
    new Float:ang1r = GetPlayerAngleToCoordinates(playerid, bsData[id][Ring1Pos][0], bsData[id][Ring1Pos][1]);//ring 1
    new Float:ang2r = GetPlayerAngleToCoordinates(playerid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1]);////ring 2
    new Float:angle;
    GetPlayerFacingAngle(playerid, angle);
    PlayerHaveBall[playerid] = 0;
    if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][DunkPos1][0], bsData[id][DunkPos1][1], bsData[id][DunkPos1][2]))//dunk ring 1
	{
		    SetPlayerPos(playerid, bsData[id][DunkPos1][0], bsData[id][DunkPos1][1], bsData[id][DunkPos1][2]);
		    SetPlayerFacingAngle(playerid, GetPlayerAngleToCoordinates(playerid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1]) + 180.0);
		    ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1, 0, 1, 1, 1, 1, 1);
		    SetTimerEx("ClearSekeler", 2000, false, "i", playerid);
		    MasukkanBolaKeRing(id, 1);
		    bsData[id][Point][1] += 2;//point ring 2 bertambah 2

		    new string[200];
		    format(string, sizeof string, "Team 1 Got 2 Point, Total: %d", bsData[id][Point][1]);
		    foreach(new i : Player)
		    {
		        if(PlayerCourt[i] == id)
		        {
		    		GameTextForPlayer(playerid, string, 5000, 3);
				}
			}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][DunkPos2][0], bsData[id][DunkPos2][1], bsData[id][DunkPos2][2]))//dunk ring 2
	{
		    SetPlayerPos(playerid, bsData[id][DunkPos2][0], bsData[id][DunkPos2][1], bsData[id][DunkPos2][2]);
		    SetPlayerFacingAngle(playerid, GetPlayerAngleToCoordinates(playerid, bsData[id][Ring1Pos][0], bsData[id][Ring1Pos][1]) + 180.0);
		    ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1, 0, 1, 1, 1, 1, 1);
		    SetTimerEx("ClearSekeler", 2000, false, "i", playerid);
		    MasukkanBolaKeRing(id, 2);
		    bsData[id][Point][0] += 2;//point ring 1 bertambah 2

		    new string[200];
		    format(string, sizeof string, "Team 2 Got 2 Point, Total: %d", bsData[id][Point][0]);
		    foreach(new i : Player)
		    {
		        if(PlayerCourt[i] == id)
		        {
		    		GameTextForPlayer(playerid, string, 5000, 3);
				}
			}
	}
    else if(ang1r-3 <= angle <= ang1r+3) //masuk ring 1
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, bsData[id][Ring1Pos][0], bsData[id][Ring1Pos][1], bsData[id][Ring1Pos][2]);
        new Float:x2, Float:y2, Float:z2;
        GetPlayerPos(playerid, x2, y2, z2);
    	GetXYInFrontOfPlayer(playerid, x2, y2, 5.0);

		MoveDynamicObject(bsObject[id], x2, y2, z2+5.0, 10.0);

        SetTimerEx("PlaceBall2", 2000, false, "ii", id, 1);

        new string[200];

        if(dist > 6.65)//three point
        {
        	bsData[id][Point][1] += 3;//point ring 2 bertambah 3
        	format(string, sizeof string, "Team 2 Got 3 Point, Total: %d", bsData[id][Point][1]);
		}
		else
		{
			bsData[id][Point][1] += 1;//point ring 2 bertambah 1
		    format(string, sizeof string, "Team 2 Got 1 Point, Total: %d", bsData[id][Point][1]);
		}

        ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1);
		SetTimerEx("ClearSekeler", 2000, false, "i", playerid);

	 	foreach(new i : Player)
		{
		    if(PlayerCourt[i] == id)
  			{
		    	GameTextForPlayer(playerid, string, 5000, 3);
			}
		}
    }
    else if(ang2r-3 <= angle <= ang2r+3) //masuk ring 1
    {
        new Float:dist = GetPlayerDistanceFromPoint(playerid, bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1], bsData[id][Ring2Pos][2]);
        new Float:x2, Float:y2, Float:z2;
        GetPlayerPos(playerid, x2, y2, z2);
    	GetXYInFrontOfPlayer(playerid, x2, y2, 5.0);

		MoveDynamicObject(bsObject[id], x2, y2, z2+5.0, 10.0);

        SetTimerEx("PlaceBall2", 2000, false, "ii", id, 2);

        new string[200];

        if(dist > 6.65)//three point
        {
        	bsData[id][Point][0] += 3;//point ring 1 bertambah 3
        	format(string, sizeof string, "Team 1 Got 3 Point, Total: %d", bsData[id][Point][0]);
		}
		else
		{
			bsData[id][Point][0] += 1;//point ring 1 bertambah 1
		    format(string, sizeof string, "Team 1 Got 1 Point, Total: %d", bsData[id][Point][0]);
		}

        ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1);
		SetTimerEx("ClearSekeler", 2000, false, "i", playerid);

		foreach(new i : Player)
		{
		    if(PlayerCourt[i] == id)
  			{
		    	GameTextForPlayer(playerid, string, 5000, 3);
			}
		}
    }
    else//gamasuk shotnya
    {
		// ga masuk sama sekali aowkaokw
		{
		    new Float:x2, Float:y2,
			 Float:z2;
		    GetPlayerPos(playerid, x2, y2, z2);
		    GetXYInFrontOfPlayer(playerid, x2, y2, 5.0);

		    MoveDynamicObject(bsObject[id], x2, y2, z2+5.0, 10.0);

		    GetXYInFrontOfPlayer(playerid, x2, y2, 7.0);

		    SetTimerEx("PlaceBall", 1000, false, "ifff", id, x2, y2, z2-0.8);

            ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1);
		    SetTimerEx("ClearSekeler", 2000, false, "i", playerid);

		    foreach(new i : Player)
		{
		    if(PlayerCourt[i] == id)
  			{
		    	GameTextForPlayer(playerid, "~r~Shooting fail", 5000, 3);
			}
		}
		}
    }
}

forward PlaceBall(id, Float:x, Float:y, Float:z);
public PlaceBall(id, Float:x, Float:y, Float:z)
{
    MoveDynamicObject(bsObject[id], x, y, z, 10.0);
    bsData[id][BallPosNow][0] = x;
    bsData[id][BallPosNow][1] = y;
    bsData[id][BallPosNow][2] = z;

    if(bsData[id][MinPosX] >= x >= bsData[id][MaxPosX] || bsData[id][MinPosY] >= y >= bsData[id][MaxPosY])
    {
        MoveDynamicObject(bsObject[id], bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2], 10.0);
	    bsData[id][BallPosNow][0] = bsData[id][BallDefaultPos][0];
	    bsData[id][BallPosNow][1] = bsData[id][BallDefaultPos][1];
	    bsData[id][BallPosNow][2] = bsData[id][BallDefaultPos][2];
    }
}

forward PlaceBall2(id, ring);
public PlaceBall2(id, ring)
{
    switch(ring)
	{
    	case 1:
		{
    		MasukkanBolaKeRing(id, 1);
		}
		case 2:
		{
		    MasukkanBolaKeRing(id, 2);
		}
	}
}

MasukkanBolaKeRing(id, ring)
{
	switch(ring)
	{
    	case 1:
		{
			MoveDynamicObject(bsObject[id], bsData[id][Ring1Pos][0], bsData[id][Ring1Pos][1], bsData[id][Ring1Pos][2], 50.0);
			SetTimerEx("BolaJatuhDariRing", 5000, false, "ii", id, ring);
		}
		case 2:
		{
		    MoveDynamicObject(bsObject[id], bsData[id][Ring2Pos][0], bsData[id][Ring2Pos][1], bsData[id][Ring2Pos][2], 50.0);
		    SetTimerEx("BolaJatuhDariRing", 5000, false, "ii", id, ring);
		}
    }
}

forward BolaJatuhDariRing(id, ring);
public BolaJatuhDariRing(id, ring)
{
    switch(ring)
	{
    	case 1:
		{
		    MoveDynamicObject(bsObject[id], bsData[id][Ring1DownBall][0], bsData[id][Ring1DownBall][1], bsData[id][Ring1DownBall][2], 10.0);
		    bsData[id][BallPosNow][0] = bsData[id][Ring1DownBall][0];
		    bsData[id][BallPosNow][1] = bsData[id][Ring1DownBall][1];
		    bsData[id][BallPosNow][2] = bsData[id][Ring1DownBall][2];
		}
		case 2:
		{
		    MoveDynamicObject(bsObject[id], bsData[id][Ring2DownBall][0], bsData[id][Ring2DownBall][1], bsData[id][Ring2DownBall][2], 10.0);
		    bsData[id][BallPosNow][0] = bsData[id][Ring2DownBall][0];
		    bsData[id][BallPosNow][1] = bsData[id][Ring2DownBall][1];
		    bsData[id][BallPosNow][2] = bsData[id][Ring2DownBall][2];
		}
	}
}

//IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
CMD:accept(playerid, params[])
{
    if(GetPlayerCourt(playerid) != -1) return SendClientMessage(playerid, -1, "[Error] You playing basketball, type "YELLOW_E"'/basket end' "WHITE_E"for end your game");

	if(YangInvite[playerid] >= 0)
 	{
  		new id = GetNearestBasketField(playerid, 50.0);

		SendClientMessageEx(YangInvite[playerid], -1, "%s Menerima tantangan anda untuk bermain basket", ReturnName(playerid));
		SendClientMessageEx(playerid, -1, "[Basket] Anda menerima tantangan untuk bermain basket dari %s", ReturnName(YangInvite[playerid]));
		StartPlayBasketball(YangInvite[playerid], id, playerid);
    }
    return 1;
}
        
CMD:basket(playerid, params[])
{
	new type[20], string[128];
	if(sscanf(params, "s[20]S()[128]", type, string)) return SendClientMessage(playerid, -1, "Usage: /basket <Duel/Solo/End>");

	if(!strcmp(params, "end", true, 20))
	{
	    new id = GetPlayerCourt(playerid);

	    if(id == -1)
	    {
	        SendClientMessage(playerid, -1, "[Basket] You're not playing basket");
	        return 1;
	    }

	    EndBasket(id);
	}
	if(!strcmp(params, "duel", true, 20))
	{
	    new otherid;
	    if(!sscanf(string, "i", otherid)) return SendClientMessage(playerid, -1, "Usage: /basket <Duel> <Playerid>");

		new id = GetNearestBasketField(playerid, 50.0);
	    if(id == -1) return SendClientMessage(playerid, -1, "[Error] You're not on any basketball court");
	    if(!IsPlayerInPlayerArea(playerid, otherid, 5.0)) return SendClientMessage(playerid, -1, "[Error] You too far from person you invite");

        if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	    {
		    YangDiInvite[playerid] = otherid;
		    YangDiInvite[otherid] = otherid;
		    YangInvite[playerid] = playerid;
		    YangInvite[playerid] = playerid;

		    SendClientMessageEx(otherid, -1, "[Basket] %s has invite you to playing basket. type "YELLOW_E"'/accept' "WHITE_E"to accept.", ReturnName(playerid));
		}
		else SendClientMessage(playerid, -1, "[Basket] You're not near to any basketball court");
	}
	if(!strcmp(params, "solo", true, 20))
	{
	    new id = GetNearestBasketField(playerid, 50.0);

	    /*if(!IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	        return SendClientMessage(playerid, -1, "[Error] Kamu harus berada ditengah lapangan");*/

        if(id == -1) return SendClientMessage(playerid, -1, "[Error] You're not on any basketball court");

	    foreach(new i : Player)
	    {
	        if(PlayerCourt[i] == id)
	        {
	            {
	                return SendClientMessage(playerid, -1, "[Basket] Someone use this basketball court");
	            }
	        }
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	    {
	    	StartPlayBasketball(playerid, id);
	    	SendClientMessage(playerid, -1, "[Basket] You started playing basketball alone");
		}
		else SendClientMessage(playerid, -1, "[Basket] You're not near to any basketball court");
	}
	return 1;
}

static BS_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(newkeys == KEY_FIRE)
		{
		    new id = PlayerCourt[playerid];

			if(id > -1)
			{
			    if(PlayerHaveBall[playerid])
			    {
		            PlayerShooting[playerid] = 1;
		            PlayerShot(playerid);
			    }
			    else
			    {
			        if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallPosNow][0], bsData[id][BallPosNow][1], bsData[id][BallPosNow][2]))
			        {
						foreach(new i : Player)
						{
						    if(i != playerid)
						    {
						        if(PlayerCourt[i] == id)
						        {
						            if(PlayerHaveBall[i] == 1)
						            {
						                return 1;
						            }
						        }
						    }
						}
                        ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.0, 0, 1, 1, 1, 1, 1);
                        PlayerHaveBall[playerid] = 1;
			        }
			    }
			}
		}
		if(newkeys == KEY_SPRINT)
		{
		    if(PlayerHaveBall[playerid])
		    {
		        ApplyAnimation(playerid,"BSKTBALL","BBALL_run",4.1, 1, 1, 1, 1, 1, 1);
		    }
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    BS_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
}

forward ClearSekeler(playerid);
public ClearSekeler(playerid)
{
    ClearAnimations(playerid);
	//StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(playerid, 1);
	if(PlayerHaveBall[playerid])
	{
		PlayerShooting[playerid] = 0;
	}
}

forward Float:GetPlayerAngleToCoordinates(playerid, Float:X, Float:Y);
public Float:GetPlayerAngleToCoordinates(playerid, Float:X, Float:Y)
{
    new Float:pX, Float:pY, Float:pZ, Float:ang;
    GetPlayerPos(playerid, pX, pY, pZ);
    if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
    else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
    else ang = (floatabs(ang) - 180.0);

    return ang;
}

SetPlayerAngleToCoordinates(playerid, Float:X, Float:Y)
{
    new Float:pX, Float:pY, Float:pZ, Float:ang;
    GetPlayerPos(playerid, pX, pY, pZ);
    if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
    else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
    if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
    else ang = (floatabs(ang) - 180.0);

    return SetPlayerFacingAngle(playerid, ang);
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

GetXYZInFrontPlayer(playerid, &Float:x, &Float:y)
{
	new Float:fa, Float:z;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, fa);
    x += (0.6 * floatsin(-fa, degrees));
   	y += (0.6 * floatcos(-fa, degrees));
}

ReturnName(playerid)
{
	new name[20+1];
	GetPlayerName(playerid, name, sizeof name);
	return name;
}

IsPlayerInPlayerArea(playerid, otherid, Float:range)
{
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(IsPlayerInRangeOfPoint(otherid, range, pos[0], pos[1], pos[2]))
	{
	    return 1;
	}
	return 0;
}

SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
            str[144];

    if((args = numargs()) == 3)
    {
            SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}
