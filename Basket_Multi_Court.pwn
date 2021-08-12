/*
      Credit:
      - Salim
      - P4lw4 (for helping me)
      
      if u remove this, u nerd.
*/

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
	    return SendActivyMessage(playerid, "ERROR", "You're not on any basketball court");

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

function PlayerBasketUpdate(playerid)
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

function PlaceBall(id, Float:x, Float:y, Float:z)
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

function PlaceBall2(id, ring)
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

function BolaJatuhDariRing(id, ring)
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
CMD:basket(playerid, params[])
{
    if(pData[playerid][IsLoggedIn] == false) return 1;

	new type[20], string[128];
	if(sscanf(params, "s[20]S()[128]", type, string)) return SendActivyMessage(playerid, "USAGE", "/basket <Duel/Solo/End>");

	if(!strcmp(params, "end", true, 20))
	{
	    new id = GetPlayerCourt(playerid);
	    
	    if(id == -1)
	    {
	        SendActivyMessage(playerid, "BASKET", "You're not playing basket");
	        return 1;
	    }
	    
	    EndBasket(id);
	}
	if(!strcmp(params, "duel", true, 20))
	{
	    new otherid;
	    if(!sscanf(string, "i", otherid)) return SendActivyMessage(playerid, "USAGE", "/basket <Duel> <Playerid>");

		new id = GetNearestBasketField(playerid, 50.0);
	    if(id == -1) return SendActivyMessage(playerid, "ERROR", "You're not on any basketball court");
	    if(pData[otherid][IsLoggedIn] == false) return SendActivyMessage(playerid, "ERROR", "That player not online");
	    if(!IsPlayerInPlayerArea(playerid, otherid, 5.0)) return SendActivyMessage(playerid, "ERROR", "You too far from person you invite");

        if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	    {
		    pData[playerid][YangDiInvite] = otherid;
		    pData[otherid][YangDiInvite] = otherid;
		    pData[playerid][YangInvite] = playerid;
		    pData[otherid][YangInvite] = playerid;

		    SendActivyMessage(otherid, "BASKET", "%s has invite you to playing basket. type "YELLOW_E"'/accept basket' "WHITE_E"to accept.", GetPlayerNameEx(playerid));
		}
		else SendActivyMessage(playerid, "BASKET", "You're not near to any basketball court");
	}
	if(!strcmp(params, "solo", true, 20))
	{
	    new id = GetNearestBasketField(playerid, 50.0);
	    
	    /*if(!IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	        return SendActivyMessage(playerid, "ERROR", "Kamu harus berada ditengah lapangan");*/
	        
        if(id == -1) return SendActivyMessage(playerid, "ERROR", "You're not on any basketball court");
	        
	    foreach(new i : Player)
	    {
	        if(PlayerCourt[i] == id)
	        {
	            {
	                return SendActivyMessage(playerid, "BASKET", "Someone use this basketball court");
	            }
	        }
	    }
	    if(IsPlayerInRangeOfPoint(playerid, 1.0, bsData[id][BallDefaultPos][0], bsData[id][BallDefaultPos][1], bsData[id][BallDefaultPos][2]))
	    {
	    	StartPlayBasketball(playerid, id);
	    	SendActivyMessage(playerid, "BASKET", "You started playing basketball alone");
		}
		else SendActivyMessage(playerid, "BASKET", "You're not near to any basketball court");
	}
	return 1;
}

function BS_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
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

function ClearSekeler(playerid)
{
    ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(playerid, 1);
	if(PlayerHaveBall[playerid])
	{
		PlayerShooting[playerid] = 0;
	}
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

function Float:GetPlayerAngleToCoordinates(playerid, Float:X, Float:Y)
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