unit uFrmServidor;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  PessoaService, uServiceUtil, IniUtils;

type
  TFrmServidor = class(TForm)
    pnlMain: TPanel;
    pnlTitulo: TPanel;
    pnConfiguracaoConexao: TPanel;
    pnlAcoes: TPanel;
    pnBotaoDesinstalarServico: TPanel;
    pnBotaoInstalarServico: TPanel;
    pnBotaoPararServico: TPanel;
    pnBotaoIniciarServico: TPanel;
    imgBase: TImage;
    lblTituloConexao: TLabel;
    lblServidor: TLabel;
    edtServidor: TEdit;
    lblPortaBase: TLabel;
    edtPortaBase: TEdit;
    lblBase: TLabel;
    edtBase: TEdit;
    lblusuario: TLabel;
    edtUsuario: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    pnConfiguracaoAPI: TPanel;
    lblPortaAPI: TLabel;
    edtPortaAPI: TEdit;
    lblTituloAPI: TLabel;
    pnBotaoIniciarAPI: TPanel;
    pnBotaoPararAPI: TPanel;
    pnLog: TPanel;
    memLog: TMemo;
    pnBotaoGravarINI: TPanel;
    procedure pnBotaoIniciarAPIClick(Sender: TObject);
    procedure pnBotaoPararAPIClick(Sender: TObject);
    procedure pnBotaoIniciarServicoClick(Sender: TObject);
    procedure pnBotaoPararServicoClick(Sender: TObject);
    procedure pnBotaoInstalarServicoClick(Sender: TObject);
    procedure pnBotaoDesinstalarServicoClick(Sender: TObject);
    procedure pnBotaoGravarINIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadIniInfo;
    procedure HabilitarBotoes;
    procedure Status;
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
    procedure RegistrarLog(pMsg: string);
  end;

var
  FrmServidor: TFrmServidor;

const ServiceDescription = 'Cadastro de Pessoa API';
      NomeApi = 'PessoaAPI';

implementation

uses
  Horse, Horse.Commons, System.Json, Winapi.ShellAPI, uUtils;

{$R *.dfm}

procedure TFrmServidor.FormCreate(Sender: TObject);
begin
  HabilitarBotoes;
  LoadIniInfo;
  Status;
end;

procedure TFrmServidor.HabilitarBotoes;
begin
  pnBotaoIniciarServico.Enabled := uServiceUtil.IsServiceStopped(uUtils.GetNomeComputador, NomeApi);
  pnBotaoPararServico.Enabled := (not pnBotaoIniciarServico.Enabled) and (uServiceUtil.IsServiceInstalled(uUtils.GetNomeComputador, NomeApi));
  pnBotaoInstalarServico.Enabled := not uServiceUtil.IsServiceInstalled(uUtils.GetNomeComputador, NomeApi);
  pnBotaoDesinstalarServico.Enabled := not pnBotaoInstalarServico.Enabled;
end;

procedure TFrmServidor.LoadIniInfo;
var
  Ini: TIniUtils;
begin
  Ini := TIniUtils.New;
  edtServidor.Text := Ini.Server;
  edtPortaBase.Text := IntToStr(Ini.Port);
  edtBase.Text := Ini.Database;
  edtUsuario.Text := Ini.User;
  edtSenha.Text := Ini.Pass;
  edtPortaAPI.Text := IntToStr(Ini.PortAPI);
end;

procedure TFrmServidor.pnBotaoDesinstalarServicoClick(Sender: TObject);
begin
  try
    uServiceUtil.DelService(NomeApi);
    ShowMessage('Serviço desinstalado com sucesso!');
    HabilitarBotoes;
  except
    on E: Exception do
    begin
      HabilitarBotoes;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmServidor.pnBotaoGravarINIClick(Sender: TObject);
var
  Ini: TIniUtils;
begin
  Ini := TIniUtils.New;
  Ini.Server := edtServidor.Text;
  Ini.Port := StrToInt(edtPortaBase.Text);
  Ini.Database := edtBase.Text;
  Ini.User := edtUsuario.Text;
  Ini.Pass := edtSenha.Text;
  Ini.PortAPI := StrToInt(edtPortaAPI.Text);
  Ini.SaveIniFile;
end;

procedure TFrmServidor.pnBotaoIniciarAPIClick(Sender: TObject);
begin
  Start;
  Status;
  pnBotaoPararAPI.Color := RGB(255, 70, 70);
  pnBotaoIniciarAPI.Color := clSilver;
end;

procedure TFrmServidor.pnBotaoIniciarServicoClick(Sender: TObject);
begin
  try
    uServiceUtil.ServiceStart(uUtils.GetNomeComputador, NomeApi);
    ShowMessage('Serviço iniciado com sucesso!');
    HabilitarBotoes;
  except
    on E: Exception do
    begin
      HabilitarBotoes;
    end;
  end;
end;

procedure TFrmServidor.pnBotaoInstalarServicoClick(Sender: TObject);
begin
  try
    uServiceUtil.InstallService(NomeApi, ServiceDescription, Application.ExeName, ServiceDescription);
    ShowMessage('Serviço instalado com sucesso!');
    HabilitarBotoes;
  except
    on E: Exception do
    begin
      HabilitarBotoes;
    end;
  end;
end;

procedure TFrmServidor.pnBotaoPararAPIClick(Sender: TObject);
begin
  Stop;
  Status;
  pnBotaoPararAPI.Color := clSilver;
  pnBotaoIniciarAPI.Color := clMoneyGreen;
end;

procedure TFrmServidor.pnBotaoPararServicoClick(Sender: TObject);
begin
  try
    uServiceUtil.ServiceStop(uUtils.GetNomeComputador, NomeApi);
    ShowMessage('Serviço parado com sucesso!');
    HabilitarBotoes;
  except
    on E: Exception do
    begin
      HabilitarBotoes;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmServidor.RegistrarLog(pMsg: string);
begin
  memLog.Lines.Add(pMsg);
end;

procedure TFrmServidor.Start;
begin
  RegisterRoutes;
  THorse.Listen(StrToInt(edtPortaAPI.text));
end;

procedure TFrmServidor.Status;
begin
  pnBotaoPararAPI.Enabled := THorse.IsRunning;
  pnBotaoIniciarAPI.Enabled := not THorse.IsRunning;
  edtPortaAPI.Enabled := not THorse.IsRunning;
end;

procedure TFrmServidor.Stop;
begin
  THorse.StopListen;
end;

end.
