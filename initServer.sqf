// TODO: Написать факин документэйшн

/******         Database, Database, just living in the Database...       ******/
MPS_spawn_BDINIT = [] spawn {
  [] call ZONT_fnc_bd_initBasic;
  MPS_BDL_pres =
      ["rgpresist"] call ZONT_fnc_bd_initCustom;
  MPS_BDL_status =
      ["rgstatus"] call ZONT_fnc_bd_initCustom;
};

/******                              Autosave                            ******/
MPS_spawn_ausav = [] spawn {
  while {true} do {
    sleep 60;
    {
      private _res = [owner _x, "MPC_canSave", false] call ZONT_fnc_getMNvar;
      if (typeName _res == typeName false and {_res}) then {
        diag_log format ["Autosaving %1", name _x];
        _x call ZONT_fnc_prs_saveProfile;
      }
    } forEach allPlayers;
  };
};

/******                         Status commiting                         ******/
MPS_handler_status = [{
  private _all = [];
  private _gms = [];
  { private _guid = getPlayerUID _x;
    _all pushBack _guid;
    if ([false, _x] call ZONT_fnc_checkCuratorPermission) then {
      _gms pushBack name _x;
    }
  } forEach allPlayers;
  [MPS_BDL_status, "commitStatus", [_all, count _all, time, _gms]] call ZONT_fnc_bd_customRequest;
}, 30] call CBA_fnc_addPerFrameHandler;
