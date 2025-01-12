unit ConfigSingleton;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils;

type
  TIniConfig = class
  private
    class var FInstance: TIniConfig;
    FIniFile: TIniFile;
    FFilePath: string;
    constructor CreateInternal;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    class function GetInstance: TIniConfig;
    function GetValue(const Section, Key, Default: string): string;
    procedure SetValue(const Section, Key, Value: string);
    procedure Save;
  end;

implementation

{ TIniConfig }

constructor TIniConfig.CreateInternal;
begin
  FFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Frontend.ini');
  if not FileExists(FFilePath) then
  begin
    FIniFile := TIniFile.Create(FFilePath);
    try
      FIniFile.WriteString('Servidor', 'URL', 'http://localhost:9005');
      FIniFile.UpdateFile;
    finally
      FIniFile.Free;
    end;
  end;
  FIniFile := TIniFile.Create(FFilePath);
end;

constructor TIniConfig.Create;
begin
  raise Exception.Create('Use TIniConfig.GetInstance para obter a instância.');
end;

destructor TIniConfig.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

class function TIniConfig.GetInstance: TIniConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TIniConfig.CreateInternal;
  Result := FInstance;
end;

function TIniConfig.GetValue(const Section, Key, Default: string): string;
begin
  Result := FIniFile.ReadString(Section, Key, Default);
end;

procedure TIniConfig.SetValue(const Section, Key, Value: string);
begin
  FIniFile.WriteString(Section, Key, Value);
end;

procedure TIniConfig.Save;
begin
  FIniFile.UpdateFile;
end;

initialization
  TIniConfig.GetInstance;

finalization
  FreeAndNil(TIniConfig.FInstance);

end.

