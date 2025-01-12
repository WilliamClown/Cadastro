unit View.Pessoa;

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
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  REST.Client,
  REST.Types,
  System.JSON,
  System.Net.HttpClient,
  PessoaService,
  EnderecoService,
  FireDAC.Comp.Client,
  Generics.Collections,
  System.Threading,
  System.Math,
  PessoaDTO,
  EnderecoDTO,
  IniFiles,
  PessoaController;

type
  TFormPessoa = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pnlGerarLoteCadastro: TPanel;
    pnlFechar: TPanel;
    pnlSalvar: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtNome: TEdit;
    edtSobrenome: TEdit;
    edtDocumento: TEdit;
    Panel7: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    edtCep: TEdit;
    edtLogradouro: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtUf: TEdit;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Label4: TLabel;
    edtComplemento: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlGerarLoteCadastroClick(Sender: TObject);
    procedure pnlSalvarClick(Sender: TObject);
    procedure pnlFecharClick(Sender: TObject);
  private
    { Private declarations }
    FPessoaService: IPessoaService;
    FEnderecoService: IEnderecoService;
    FPessoaController: TPessoaController;
    FServerURL: string;
    FPessoaID: Integer;
    procedure CarregarDados(ID: Integer);
    procedure AtualizarEnderecoComDadosViaCep(const CEP: string; var EnderecoCompleto: Boolean);
    procedure LimparCamposEndereco;
    procedure InserirLotePessoas(const Pessoas: TList<TPessoaDTO>);
    procedure CarregarConfiguracoes;
    procedure ConfigurarServicos;
    function ObterCEPValido(CEP: string): TEnderecoDTO;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; PessoaID: Integer = -1); reintroduce;
    destructor Destroy; override;
  end;

var
  FormPessoa: TFormPessoa;

implementation

{$R *.dfm}

procedure TFormPessoa.AtualizarEnderecoComDadosViaCep(const CEP: string;
  var EnderecoCompleto: Boolean);
var
  Endereco: TEnderecoDTO;
begin
  EnderecoCompleto := False;
  Endereco := FEnderecoService.BuscarEnderecoViaCep(CEP);
  if Endereco.Logradouro <> '' then
  begin
    edtLogradouro.Text := Endereco.Logradouro;
    edtBairro.Text := Endereco.Bairro;
    edtCidade.Text := Endereco.Cidade;
    edtUf.Text := Endereco.UF;
    EnderecoCompleto := True;
  end
  else
  begin
    ShowMessage('CEP não encontrado ou inválido.');
    LimparCamposEndereco;
  end;
end;

procedure TFormPessoa.CarregarConfiguracoes;
var
  IniFile: TIniFile;
  ConfigPath: string;
begin
  ConfigPath := ExtractFilePath(ParamStr(0)) + 'Frontend.ini';
  IniFile := TIniFile.Create(ConfigPath);
  try
    FServerURL := IniFile.ReadString('Servidor', 'URL', 'http://localhost:9005');
  finally
    IniFile.Free;
  end;
end;

procedure TFormPessoa.CarregarDados(ID: Integer);
var
  Pessoa: TPessoaDTO;
  Endereco: TEnderecoDTO;
begin
  Pessoa := FPessoaController.GetPessoaById(ID);
  Endereco := FPessoaController.GetEnderecoById(ID);

  // Substitui Assigned por verificação direta se os campos estão preenchidos
  if Pessoa.Documento <> '' then
  begin
    EdtNome.Text := Pessoa.Nome;
    EdtSobrenome.Text := Pessoa.Sobrenome;
    EdtDocumento.Text := Pessoa.Documento;
    edtCep.Text := Endereco.CEP;
    edtLogradouro.Text := Endereco.Logradouro;
    edtBairro.Text := Endereco.Bairro;
    edtCidade.Text := Endereco.Cidade;
    edtUf.Text := Endereco.UF;
    edtComplemento.Text := Endereco.Complemento;
  end
  else
    ShowMessage('Erro: Registro não encontrado.');
end;

procedure TFormPessoa.ConfigurarServicos;
begin
  FPessoaService := TPessoaServiceFactory.CreateService(FServerURL);
  FEnderecoService := TEnderecoServiceFactory.CreateService;
end;

constructor TFormPessoa.Create(AOwner: TComponent; PessoaID: Integer = -1);
begin
  inherited Create(AOwner);
  FPessoaController := TPessoaController.Create;
  FPessoaID := PessoaID;
  CarregarConfiguracoes;
  ConfigurarServicos;
end;

destructor TFormPessoa.Destroy;
begin
  FPessoaService := nil;
  FEnderecoService := nil;
  inherited;
end;

procedure TFormPessoa.edtCepExit(Sender: TObject);
var
  CEP: string;
  EnderecoCompleto: Boolean;
begin
  CEP := Trim(edtCep.Text);
  if CEP.Length <> 8 then
  begin
    ShowMessage('O CEP deve ter 8 dígitos.');
    Exit;
  end;

  TTask.Run(procedure
  begin
    TThread.Synchronize(nil, procedure
    begin
      AtualizarEnderecoComDadosViaCep(CEP, EnderecoCompleto);
    end);
  end);
end;

procedure TFormPessoa.FormCreate(Sender: TObject);
begin
  FEnderecoService := TEnderecoServiceFactory.CreateService;
end;

procedure TFormPessoa.FormDestroy(Sender: TObject);
begin
  FPessoaService := nil;
  FEnderecoService := nil;
  inherited;
end;

procedure TFormPessoa.FormShow(Sender: TObject);
begin
  if FPessoaID <> -1 then
    CarregarDados(FPessoaID);
end;

procedure TFormPessoa.InserirLotePessoas(const Pessoas: TList<TPessoaDTO>);
var
  BatchSize, StartIndex, EndIndex: Integer;
  SubList: TArray<TPessoaDTO>;
begin
  BatchSize := 1000;
  StartIndex := 0;

  while StartIndex < Pessoas.Count do
  begin
    EndIndex := Min(StartIndex + BatchSize, Pessoas.Count) - 1;

    try
      SubList := Copy(Pessoas.List, StartIndex, EndIndex - StartIndex + 1);

      TTask.Run(procedure
      begin
        FPessoaService.SalvarLote(SubList);
        TThread.Queue(nil, procedure
        begin
          ShowMessage(Format('Lote inserido com sucesso: %d', [EndIndex + 1]));
        end);
      end);
    finally
     // SubList.Free;
    end;

    Inc(StartIndex, BatchSize);
  end;
end;

procedure TFormPessoa.LimparCamposEndereco;
begin
  edtLogradouro.Clear;
  edtBairro.Clear;
  edtCidade.Clear;
  edtUf.Clear;
end;

function TFormPessoa.ObterCEPValido(CEP: string): TEnderecoDTO;
begin
  Result := FEnderecoService.BuscarEnderecoViaCep(CEP);
end;

procedure TFormPessoa.pnlFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPessoa.pnlGerarLoteCadastroClick(Sender: TObject);
var
  I: Integer;
  ListaPessoas: TList<TPessoaDTO>;
  Pessoa: TPessoaDTO;
  Endereco: TEnderecoDTO;
  Quantidade: string;
  QuantidadeValida: Integer;
begin
  repeat
    Quantidade := InputBox('Cadastro em Lote','Digite a quantidade de registro a ser gerado', '50');
  until TryStrToInt(Quantidade, QuantidadeValida);


  ListaPessoas := TList<TPessoaDTO>.Create;
  for I := 1 to QuantidadeValida do
  begin
    Endereco := ObterCEPValido('05602010');
    Pessoa := TPessoaDTO.Create(
      0,
      Format('Nome_%d', [I]),
      Format('Sobrenome_%d', [I]),
      Format('000000000%d', [I]),
      Endereco.CEP,
      Format(Endereco.Logradouro + '%d', [I]),
      Format(Endereco.Bairro + '%d', [I]),
      Format(Endereco.Cidade + '%d', [I]),
      Format(Endereco.UF + '%d', [I]),
      Format(Endereco.Complemento + '%d', [I])
    );

    ListaPessoas.Add(Pessoa);
  end;

  InserirLotePessoas(ListaPessoas);
end;

procedure TFormPessoa.pnlSalvarClick(Sender: TObject);
var
  Pessoa: TPessoaDTO;
  Endereco: TEnderecoDTO;
  EnderecoCompleto: Boolean;
begin
  if Trim(edtNome.Text).IsEmpty or Trim(edtSobrenome.Text).IsEmpty or Trim(edtDocumento.Text).IsEmpty or Trim(edtCep.Text).IsEmpty then
  begin
    ShowMessage('Todos os campos de pessoa e CEP são obrigatórios.');
    Exit;
  end;

  AtualizarEnderecoComDadosViaCep(Trim(edtCep.Text), EnderecoCompleto);
  if not EnderecoCompleto then
  begin
    ShowMessage('O CEP não é válido ou não foi encontrado.');
    Exit;
  end;

  // Monta o DTO de Pessoa
  Pessoa := TPessoaDTO.Create(
    FPessoaID,  // ID da pessoa que foi carregado
    edtNome.Text,
    edtSobrenome.Text,
    edtDocumento.Text,
    edtCep.Text,
    edtLogradouro.Text,
    edtBairro.Text,
    edtCidade.Text,
    edtUf.Text,
    edtComplemento.Text
  );

  // Monta o DTO de Endereço
  Endereco := TEnderecoDTO.Create(
    edtLogradouro.Text,
    edtBairro.Text,
    edtCidade.Text,
    edtUf.Text,
    edtCep.Text,
    edtComplemento.Text  // Inclui complemento se necessário
  );

  // Salva em thread para não travar a interface
  TTask.Run(procedure
  begin
    try
      if FPessoaID <> -1 then
      begin
        Pessoa.Id := FPessoaID;
        if FPessoaService.SalvarPessoaComEndereco(Pessoa) and FPessoaService.AtualizarEndereco(FPessoaID, Endereco) then
        begin
          TThread.Synchronize(nil, procedure
          begin
            ShowMessage('Cadastro atualizado com sucesso!');
            Self.Close;
          end);
        end
        else
          TThread.Synchronize(nil, procedure
          begin
            ShowMessage('Erro ao atualizar os dados da pessoa e endereço.');
          end);
      end
      else
      begin
        if FPessoaService.SalvarPessoaComEndereco(Pessoa) then
          TThread.Synchronize(nil, procedure
          begin
            ShowMessage('Cadastro realizado com sucesso!');
            Self.Close;
          end)
        else
          TThread.Synchronize(nil, procedure
          begin
            ShowMessage('Erro ao cadastrar pessoa e endereço.');
          end);
      end;
    except
      on E: Exception do
        TThread.Synchronize(nil, procedure
        begin
          ShowMessage('Erro: ' + E.Message);
        end);
    end;
  end);
end;

end.
