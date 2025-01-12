unit uUtils;

interface

function validarEmail(AEmail: string): Boolean;
function GetIp: string;
function GetNomeComputador: string;
function GetMemoriaRAM: string;
function GetDisco: string;
function GetNomeSO: string;
function GetSerialNum: string;
function GetNomeUsuario: string;
function Crypt(AAcao, AValor: string): string;
function GetVersion: string;
function RemoveAcentosXML(AJson: string): string;
function ExtractFileNameSemExt(const FileName: string): string;
function GetIdProduto: string;
function GetBase64(pString: string): string;
function Padl(Valor: String; Tamanho: Integer; Caracter: String): string;
function Replicate(Caracter: String; Tamanho: Integer): string;
function FilterNumbers(const AValue: string): string;

implementation

uses
  Winapi.Windows, System.SysUtils, Winapi.WinSock, System.Win.Registry,
  Vcl.Forms, IdCoderMIME, JclStrings;

function GetBase64(pString: string): string;
var
  utf8: UTF8String;
  encodeMime: TIdEncoderMIME;
begin
  try
    utf8 := UTF8String(pString);
    encodeMime := TIdEncoderMIME.Create(Application);
    Result := encodeMime.EncodeString(UTF8ToString(utf8));
  finally
    FreeAndNil(encodeMime);
  end;
end;

function validarEmail(AEmail: string): Boolean;
begin
  Result := False;
end;

function GetIp: string;
type
  pu_long = ^u_long;
var
  varTWSAData: TWSAData;
  varPHostEnt: PHostEnt;
  varTInAddr: TInAddr;
  namebuf: Array [0 .. 255] of AnsiChar;
begin
  if WSAStartup($101, varTWSAData) <> 0 Then
    Result := 'No IP Address'
  else
  begin
    Gethostname(namebuf, sizeof(namebuf));
    varPHostEnt := Gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := string(inet_ntoa(varTInAddr));
  end;
  WSACleanup;
end;

function GetNomeComputador: string;
var
  buf: array [0 .. 256] of char;
  nsize: DWord;
begin
  nsize := 256;
  GetComputerName(buf, nsize);
  Result := string(buf);
end;

function GetMemoriaRAM: string;
var
  v_MS: TMemoryStatusEx;
begin
  v_MS.dwLength := sizeof(v_MS);
  GlobalMemoryStatusEx(v_MS);
  Result := FormatFloat('#,###" KB"', v_MS.ullTotalPhys / 1024);
end;

function GetDisco: string;
var
  FreeAvailable, TotalSpace, TotalFree: Int64;
begin
  GetDiskFreeSpaceEx('c:', FreeAvailable, TotalSpace, @TotalFree);
  Result := FormatFloat('#,0', TotalFree / 1048576);
end;

function GetNomeSO: string;
var
  Registry: TRegistry;
  str: string;
begin
  Registry := TRegistry.Create(KEY_READ OR $0100);
  try
    Registry.Lazywrite := False;
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if not Registry.OpenKeyReadOnly('\Software\Microsoft\Windows NT\CurrentVersion') then
      Result := ''
    else
    begin
      str := Registry.ReadString('ProductName');
      Result := str;
      str := Registry.ReadString('CSDVersion');
      Result := Result + ' ' + str;
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

function GetSerialNum: string;
var
  Serial: DWord;
  DirLen, Flags: DWord;
  DLabel: Array [0 .. 11] of char;
begin
  Try
    GetVolumeInformation(PChar(ExtractFileDir(Application.ExeName)), DLabel, 12, @Serial, DirLen, Flags, nil, 0);
    Result := IntToHex(Serial, 8);
  Except
    Result := '';
  end;
end;

function GetNomeUsuario: string;
var
  ipbuffer: string;
  nsize: DWord;
begin
  nsize := 255;
  SetLength(ipbuffer, nsize);
  if GetUserName(PChar(ipbuffer), nsize) then
  begin
    Result := Trim(ipbuffer);
  end;
end;

function Crypt(AAcao, AValor: string): string;
Label Fim;
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  Dest, Key: String;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;
begin
  if (AValor = '') Then
  begin
    Result := '';
    Goto Fim;
  end;;
  Key := 'SL9RT3KL23DF90WIJAS467NMWWMCL0AOMM4A4VCXXL6JAOAUZYW9KHJJKDF3424SUI2347EJHKL K3LAYUQL25E1KDJIKJ';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  Range := 256;
  if (AAcao = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x', [OffSet]);
    for SrcPos := 1 to Length(AValor) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(AValor[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x', [SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (AAcao = UpperCase('D')) then
  begin
    OffSet := StrToInt('$' + copy(AValor, 1, 2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + copy(AValor, SrcPos, 2));
      if (KeyPos < KeyLen) Then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      if TmpSrcAsc <= OffSet then
        TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      else
        TmpSrcAsc := TmpSrcAsc - OffSet;
      Dest := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
    until (SrcPos >= Length(AValor));
  end;
  Result := Dest;
Fim:
end;

function GetVersion: string;
var
  VerInfoSize: DWord;
  VerInfo: Pointer;
  VerValueSize: DWord;
  VerValue: PVSFixedFileInfo;
  Dummy: DWord;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function RemoveAcentosXML(AJson: string): string;
begin

end;

function ExtractFileNameSemExt(const FileName: string): string;
var
  ext: string;
begin
  Result := ExtractFileName(FileName);
  if Length(Result) = 0 then
    exit;
  ext := ExtractFileExt(Result);
  if Length(ext) = 0 then
  begin
    if Result[Length(Result)] = '.' then
      Result := copy(Result, 1, Length(Result) - 1);
  end
  else
    Result := copy(Result, 1, Length(Result) - Length(ext));
end;

function GetIdProduto: string;
var
  Registry: TRegistry;
  str: string;
begin
  Registry := TRegistry.Create(KEY_READ OR $0100);
  try
    Registry.Lazywrite := False;
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if not Registry.OpenKeyReadOnly('\Software\Microsoft\Windows NT\CurrentVersion') then
      Result := ''
    else
    begin
      str := Registry.ReadString('ProductId');
      Result := str;
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

function Padl(Valor: String; Tamanho: Integer; Caracter: String): string;
begin
  Result := copy(Replicate(Caracter, Tamanho), 1, Tamanho - Length(Trim(Valor))) + Trim(Valor);
end;

function Replicate(Caracter: String; Tamanho: Integer): string;
var
  TmpCC: string;
  TmpII: Integer;
begin
  for TmpII := 1 to Tamanho do
  begin
    TmpCC := TmpCC + Caracter;
  end;
  Result := TmpCC;
end;

function FilterNumbers(const AValue: string): string;
var
  i: Integer;
  NewStr: string;
begin
  NewStr := '';
  for i := 1 to Length(AValue) do
    if CharIsDigit(AValue[i]) then
      NewStr := NewStr + AValue[i];
  Result := Trim(NewStr);
end;

end.
