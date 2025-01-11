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
  Vcl.ExtCtrls;

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

const ServiceDescription = 'Servidor de Tarefa API';

implementation

uses
  Horse, Horse.Commons, System.Json, Winapi.ShellAPI;

{$R *.dfm}

procedure TFrmServidor.FormCreate(Sender: TObject);
begin
  HabilitarBotoes;
  LoadIniInfo;
  Status;
end;

procedure TFrmServidor.HabilitarBotoes;
begin
  //
end;

procedure TFrmServidor.LoadIniInfo;
begin
  //
end;

procedure TFrmServidor.pnBotaoDesinstalarServicoClick(Sender: TObject);
begin
//
end;

procedure TFrmServidor.pnBotaoGravarINIClick(Sender: TObject);

begin
//
end;

procedure TFrmServidor.pnBotaoIniciarAPIClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TFrmServidor.pnBotaoIniciarServicoClick(Sender: TObject);
begin
//
end;

procedure TFrmServidor.pnBotaoInstalarServicoClick(Sender: TObject);
begin
//
end;

procedure TFrmServidor.pnBotaoPararAPIClick(Sender: TObject);
begin
  Stop;
  Status;
end;

procedure TFrmServidor.pnBotaoPararServicoClick(Sender: TObject);
begin
//
end;

procedure TFrmServidor.RegistrarLog(pMsg: string);
begin
  memLog.Lines.Add(pMsg);
end;

procedure TFrmServidor.Start;
begin
 //
end;

procedure TFrmServidor.Status;
begin
  //
end;

procedure TFrmServidor.Stop;
begin
 //
end;

end.
