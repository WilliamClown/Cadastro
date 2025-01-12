unit IniUtils;

interface

uses
  System.Classes, FireDAC.Stan.Param, Data.DB;

type
  TIniUtils = class(TComponent)
  private
    FServer: string;
    FPort: Integer;
    FDatabase: string;
    FUser: string;
    FPass: string;
    FPortAPI: Integer;

    class var FInstance: TIniUtils;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadIniFile;
    procedure SaveIniFile;
    class function New: TIniUtils;

    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property Database: string read FDatabase write FDatabase;
    property User: string read FUser write FUser;
    property Pass: string read FPass write FPass;
    property PortAPI: Integer read FPortAPI write FPortAPI;
  end;

implementation

uses
  System.IniFiles, Vcl.Forms, System.SysUtils;

{ TIniUtils }

constructor TIniUtils.Create(AOwner: TComponent);
begin
  inherited;
  LoadIniFile;
end;

procedure TIniUtils.LoadIniFile;
var
  IniFile: TIniFile;
  FileName: string;
begin
  FileName := ChangeFileExt(Application.ExeName, '.INI');
  if not FileExists(FileName) then
    raise Exception.Create('Não foi encontrado o ini');

  IniFile := TIniFile.Create(FileName);
  try
    FServer := IniFile.ReadString('DATABASE', 'SERVER', '');
    FPort := IniFile.ReadInteger('DATABASE', 'PORT', 0);
    FDatabase := IniFile.ReadString('DATABASE', 'DATABASE', '');
    FUser := IniFile.ReadString('DATABASE', 'USER', '');
    FPass := IniFile.ReadString('DATABASE', 'PASS', '');
    FPortAPI := IniFile.ReadInteger('API', 'PORT', 9000);
  finally
    IniFile.Free;
  end;
end;

class function TIniUtils.New: TIniUtils;
begin
  if FInstance = nil then
    FInstance := TIniUtils.Create(Application);

  Result := FInstance;
end;

procedure TIniUtils.SaveIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    IniFile.WriteString('DATABASE', 'SERVER', FServer);
    IniFile.WriteInteger('DATABASE', 'PORT', FPort);
    IniFile.WriteString('DATABASE', 'DATABASE', FDatabase);
    IniFile.WriteString('DATABASE', 'USER', FUser);
    IniFile.WriteString('DATABASE', 'PASS', FPass);
    IniFile.WriteInteger('API', 'PORT', FPortAPI);
  finally
    IniFile.Free;
  end;
end;

end.
