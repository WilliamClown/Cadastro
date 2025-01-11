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
  Horse.CORS,
  Horse.JWT,
  PessoaService,
  Data;

type
  TService1 = class(TService)
  private
    { Private declarations }
  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
    procedure StartServer;
  end;



var
  Service1: TService1;

const
  SECRET_KEY = 'Ii7NSJL4AxKvP0BBu3tbv8OcQt99d6';

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service1.Controller(CtrlCode);
end;

function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.StartServer;
begin
  THorse.Use(HorseJWT(SECRET_KEY));  // Middleware para autenticação JWT
  THorse.Use(CORS);
  RegisterRoutes;
  DataModule1 := TDataModule1.Create(nil);
  THorse.Listen(8080);
end;

end.
