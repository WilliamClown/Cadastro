unit Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.SvcMgr,
  Vcl.Dialogs,
  Horse,
  PessoaService,
  IniUtils;

type
  TMainService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
    function GetPort: Integer;
  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
  end;


var
  MainService: TMainService;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MainService.Controller(CtrlCode);
end;

function TMainService.GetPort: Integer;
begin
  Result := TIniUtils.New.PortAPI;
end;

function TMainService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMainService.ServiceCreate(Sender: TObject);
begin
  RegisterRoutes;
end;

procedure TMainService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  THorse.Listen(GetPort);
  Started := True;
end;

procedure TMainService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  THorse.StopListen;
  Stopped := True;
end;

end.
