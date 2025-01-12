unit uServiceUtil;

interface

uses
  System.SysUtils,
  System.AnsiStrings,
  WinSvc,
  Classes,
  Windows,
  WinSock,
  WinSvcEx,
  Data.DB;

function ServiceGetList(sMachine: string; dwServiceType, dwServiceState: Dword; slServicesList: TStrings): boolean;
function ServiceGetKeyName(sMachine, sServiceDispName: string): string;
function ServiceGetDisplayName(sMachine, sServiceKeyName: string): string;
function ServiceGetStatus(sMachine, sService: string): Dword;
function ServiceGetStrCode(ID: Integer): String;
function IsServiceRunning(sMachine, sService: string): boolean;
function IsServiceStopped(sMachine, sService: string): boolean;
function ServiceStart(sMachine, sService: string): boolean;
function ServiceStop(sMachine, sService: string): boolean;
function InstallService(ServiceName: String; NomeExibicao: String; Filename: String; Descricao: string): boolean;
function IsServiceInstalled(sMachine, sService: string): boolean;
function DelService(ServiceName: String): boolean;
function IsServiceProcess: boolean;

function ComputerLocalIP: string;
function WinUserName: string;
function ComputerName: string;

implementation

// -------------------------------------
// Get a list of services
//
// return TRUE if successful
//
// sMachine:
// machine name, ie: \\SERVER
// empty = local machine
//
// dwServiceType
// SERVICE_WIN32,
// SERVICE_DRIVER or
// SERVICE_TYPE_ALL
//
// dwServiceState
// SERVICE_ACTIVE,
// SERVICE_INACTIVE or
// SERVICE_STATE_ALL
//
// slServicesList
// TStrings variable to storage
// -------------------------------------

function IsServiceProcess: boolean;
var
  LSessionID, LSize: Cardinal;
  LToken: THandle;
begin
  Result := False;
  LSize := 0;
  if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, LToken) then
    Exit;

  try
    if not GetTokenInformation(LToken, TokenSessionId, @LSessionID, SizeOf(LSessionID), LSize) then
      Exit;

    if LSize = 0 then
      Exit;

    Result := LSessionID = 0;
  finally
    CloseHandle(LToken);
  end;
end;

function ServiceGetList(sMachine: string; dwServiceType, dwServiceState: Dword; slServicesList: TStrings): boolean;
const
  cnMaxServices = 4096;
type
  TSvcA = array [0 .. cnMaxServices] of TEnumServiceStatus;
  PSvcA = ^TSvcA;
var
  j: Integer;
  schm: SC_Handle;
  nBytesNeeded, nServices, nResumeHandle: Dword;
  ssa: PSvcA;
begin
  Result := False;

  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_ALL_ACCESS);

  if (schm > 0) then
  begin
    nResumeHandle := 0;
    New(ssa);
    // Delphi Rio pra baixo
{$IF RTLVersion < 34}
    EnumServicesStatus(schm, dwServiceType, dwServiceState, ssa^[0], SizeOf(ssa^), nBytesNeeded, nServices, nResumeHandle);
{$ELSE}
    EnumServicesStatus(schm, dwServiceType, dwServiceState, @ssa[0], SizeOf(ssa^), nBytesNeeded, nServices, nResumeHandle);
{$IFEND}
    for j := 0 to nServices - 1 do
    begin
      slServicesList.Add(StrPas(ssa^[j].lpDisplayName));
    end;
    Result := true;
    Dispose(ssa);
    CloseServiceHandle(schm);
  end;
end;

function ServiceGetKeyName(sMachine, sServiceDispName: string): string;
var
  schm: SC_Handle;
  nMaxNameLen: Dword;
  psServiceName: PChar;
begin
  Result := '';
  nMaxNameLen := 255;

  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    psServiceName := StrAlloc(nMaxNameLen + 1);

    if (nil <> psServiceName) then
    begin
      if (GetServiceKeyName(schm, PChar(sServiceDispName), psServiceName, nMaxNameLen)) then
      begin
        psServiceName[nMaxNameLen] := #0;
        Result := StrPas(psServiceName);
      end;
      StrDispose(psServiceName);
    end;
    CloseServiceHandle(schm);
  end;
end;

function ServiceGetDisplayName(sMachine, sServiceKeyName: string): string;
var
  schm: SC_Handle;
  nMaxNameLen: Dword;
  psServiceName: PChar;
begin
  Result := '';
  nMaxNameLen := 255;
  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    psServiceName := StrAlloc(nMaxNameLen + 1);
    if (nil <> psServiceName) then
    begin
      if (GetServiceDisplayName(schm, PChar(sServiceKeyName), psServiceName, nMaxNameLen)) then
      begin
        psServiceName[nMaxNameLen] := #0;
        Result := StrPas(psServiceName);
      end;
      StrDispose(psServiceName);
    end;
    CloseServiceHandle(schm);
  end;
end;

{ ****************************************** }
{ *** Parameters: *** }
{ *** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** *** }
{ *** Return Values: *** }
{ *** -1 = Error opening service *** }
{ *** 1 = SERVICE_STOPPED *** }
{ *** 2 = SERVICE_START_PENDING *** }
{ *** 3 = SERVICE_STOP_PENDING *** }
{ *** 4 = SERVICE_RUNNING *** }
{ *** 5 = SERVICE_CONTINUE_PENDING *** }
{ *** 6 = SERVICE_PAUSE_PENDING *** }
{ *** 7 = SERVICE_PAUSED *** }
{ ****************************************** }
function ServiceGetStatus(sMachine, sService: string): Dword;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwStat: Dword;
begin
  dwStat := 0;
  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(sService), SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (QueryServiceStatus(schs, ss)) then
      begin
        dwStat := ss.dwCurrentState;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);

    Result := dwStat;
  end
  else
    Result := SERVICE_STOPPED;
end;

function ServiceGetStrCode(ID: Integer): String;
begin
  case ID of
    SERVICE_STOPPED:
      Result := 'STOPPED';
    SERVICE_RUNNING:
      Result := 'RUNNING';
    SERVICE_PAUSED:
      Result := 'PAUSED';
    SERVICE_START_PENDING:
      Result := 'START/PENDING';
    SERVICE_STOP_PENDING:
      Result := 'STOP/PENDING';
    SERVICE_CONTINUE_PENDING:
      Result := 'CONTINUE/PENDING';
    SERVICE_PAUSE_PENDING:
      Result := 'PAUSE/PENDING';
  else
    Result := 'UNKNOWN';
  end;
end;

function IsServiceRunning(sMachine, sService: string): boolean;
begin
  Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService);
end;

function IsServiceStopped(sMachine, sService: string): boolean;
begin
  Result := SERVICE_STOPPED = ServiceGetStatus(sMachine, sService);
end;

function ServiceStart(sMachine, sService: string): boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  psTemp: PChar;
  dwChkP: Dword;
begin
  ss.dwCurrentState := 0;
  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(sService), SERVICE_START or SERVICE_QUERY_STATUS);

    if (schs > 0) then
    begin
      psTemp := Nil;
      if (StartService(schs, 0, psTemp)) then
      begin
        Sleep(2000);
        if (QueryServiceStatus(schs, ss)) then
        begin
          while (SERVICE_RUNNING <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs, ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_RUNNING = ss.dwCurrentState;
end;

function ServiceStop(sMachine, sService: string): boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwChkP: Dword;
begin
  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(sService), SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (ControlService(schs, SERVICE_CONTROL_STOP, ss)) then
      begin
        Sleep(2000);
        if (QueryServiceStatus(schs, ss)) then
        begin
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(ss.dwWaitHint);
            if (not QueryServiceStatus(schs, ss)) then
            begin
              break;
            end;
            if (ss.dwCheckPoint < dwChkP) then
            begin
              break;
            end;
          end;
        end;
      end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;

  Result := SERVICE_STOPPED = ss.dwCurrentState;
end;

function IsServiceInstalled(sMachine, sService: string): boolean;
var
  hSCM: THandle;
  hService: THandle;
begin
  hSCM := OpenSCManager(PChar(sMachine), 'ServicesActive', SC_MANAGER_ALL_ACCESS);
  Result := False;
  if hSCM <> 0 then
  begin
    hService := OpenService(hSCM, PChar(sService), SERVICE_QUERY_CONFIG);
    if hService <> 0 then
    begin
      Result := true;
      CloseServiceHandle(hService);
    end;
    CloseServiceHandle(hSCM);
  end
end;

function InstallService(ServiceName: String; NomeExibicao: String; Filename: String; Descricao: string): boolean;
var
  ss: TServiceStatus;
  psTemp: PChar;
  hSCM, hSCS: THandle;

  srvdesc: PServiceDescription;
  desc: string;
begin
  Result := False;
  psTemp := Nil;

  hSCM := OpenSCManager('', nil, SC_MANAGER_ALL_ACCESS);

  hSCS := CreateService(hSCM, PChar(ServiceName), PChar(NomeExibicao), SERVICE_ALL_ACCESS, SERVICE_WIN32_OWN_PROCESS or
    SERVICE_INTERACTIVE_PROCESS, SERVICE_AUTO_START, SERVICE_ERROR_IGNORE, PChar(Filename), nil, nil, nil, nil, nil);

  if Assigned(ChangeServiceConfig2) then
  begin
    // Descrições de serviço não podem ser maiores que 1024 !!!
    desc := Copy(Descricao, 1, 1024);
    GetMem(srvdesc, SizeOf(TServiceDescription));
    GetMem(srvdesc^.lpDescription, Length(desc) + 1);
    try

      System.AnsiStrings.StrPCopy(srvdesc^.lpDescription, AnsiString(desc));

      ChangeServiceConfig2(hSCS, SERVICE_CONFIG_DESCRIPTION, srvdesc);

    finally
      FreeMem(srvdesc^.lpDescription);
      FreeMem(srvdesc);
    end;
  end;

  if (StartService(hSCS, 0, psTemp)) then
  begin
    while QueryServiceStatus(hSCS, ss) do
    begin
      if ss.dwCurrentState = SERVICE_START_PENDING then
        Sleep(30)
      else
        break;
      if ss.dwCurrentState = SERVICE_RUNNING then
      begin
        CloseServiceHandle(hSCS);
        Result := true;
      end
      else
        Result := False;
    end;
  end;
end;

function DelService(ServiceName: String): boolean;
var
  sm: THandle;
  sh: THandle;
  ret: Integer;
begin
  Result := False;
  try
    ret := 0;
    sm := OpenSCManager('', nil, SC_MANAGER_ALL_ACCESS);
    if sm <> 0 then
    begin
      sh := OpenService(sm, PChar(ServiceName), SERVICE_ALL_ACCESS);
      if sh <> 0 then
      begin
        DeleteService(sh);
        ret := 1;
        CloseServiceHandle(sh);
      end;
      CloseServiceHandle(sm);
    end;
    if ret > 0 then
      Result := true
    else
      Result := False;
  except

  end;
end;

function ComputerName: string;
var
  FStr: PChar;
  FSize: Cardinal;
begin
  FSize := 255;
  GetMem(FStr, FSize);
  Windows.GetComputerName(FStr, FSize);
  Result := FStr;
  FreeMem(FStr);
end;

function WinUserName: string;
var
  FStr: PChar;
  FSize: Cardinal;
begin
  FSize := 255;
  GetMem(FStr, FSize);
  GetUserName(FStr, FSize);
  Result := FStr;
  FreeMem(FStr);
end;

function ComputerLocalIP: string;
var
  ch: array [1 .. 32] of char;
  wsData: TWSAData;
  myHost: PHostEnt;
  i: Integer;
begin
  Result := '';
  if WSAstartup(2, wsData) <> 0 then
    Exit;
  try
    if GetHostName(@ch[1], 32) <> 0 then
      Exit;
  except
    Exit;
  end;
  myHost := GetHostByName(@ch[1]);
  if myHost = nil then
    Exit;
  for i := 1 to 4 do
  begin
    Result := Result + IntToStr(Ord(myHost.h_addr^[i - 1]));
    if i < 4 then
      Result := Result + '.';
  end;
end;

end.
