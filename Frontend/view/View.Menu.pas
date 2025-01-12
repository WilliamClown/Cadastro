unit View.Menu;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient,
  PessoaController,
  System.Generics.Collections,
  System.Threading,
  System.IniFiles,
  System.IOUtils,
  PessoaDTO,
  EnderecoDTO;

type
  TFormMenu = class(TForm)
    pnlMain: TPanel;
    pnlTitulo: TPanel;
    pnlBotoes: TPanel;
    pnlBottom: TPanel;
    pnlRight: TPanel;
    pnlBotaoNovo: TPanel;
    pnlLeft: TPanel;
    pnlSeparador: TPanel;
    pnlBotaoEditar: TPanel;
    pnlBotaoExcluir: TPanel;
    DBGDados: TDBGrid;
    dsDados: TDataSource;
    pnlBotaoAtualizarCEP: TPanel;
    pnlStatusAtualizacao: TPanel;
    lblTituloStatus: TLabel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure pnlBotaoNovoClick(Sender: TObject);
    procedure pnlBotaoEditarClick(Sender: TObject);
    procedure pnlBotaoExcluirClick(Sender: TObject);
    procedure pnlBotaoAtualizarCEPClick(Sender: TObject);
  private
    { Private declarations }
    FAbort: Boolean;
    FPessoaController: TPessoaController;
    procedure PopularGrid;
    procedure AtualizarCEPLote;
    function DataSetToPessoaList: TList<TPessoaDTO>;
    procedure AtualizarVisualizacao(const Atual, Total: Integer; const StatusMsg: string);
    procedure VerificarOuCriarIniFrontend;
  public
    { Public declarations }
  end;

var
  FormMenu: TFormMenu;

implementation

uses
  View.Pessoa;

{$R *.dfm}

{ TFormMenu }

procedure TFormMenu.AtualizarCEPLote;
var
  Pessoas: TList<TPessoaDTO>;
  Total, Atual: Integer;
begin
  FAbort := False;
  Pessoas := DataSetToPessoaList;
  Total := Pessoas.Count;

  if Total = 0 then
  begin
    ShowMessage('Nenhum registro para atualizar.');
    Exit;
  end;

  pnlStatusAtualizacao.Visible := True;
  lblStatus.Caption := 'Preparando atualização...';

  TThread.CreateAnonymousThread(procedure
  var
    Pessoa: TPessoaDTO;
    Endereco: TEnderecoDTO;
  begin
    try
      Atual := 0;
      for Pessoa in Pessoas do
      begin
        if FAbort then
          Break;

        Inc(Atual);
        if not Pessoa.CEP.IsEmpty then
        begin
          Endereco := FPessoaController.GetEnderecoById(Pessoa.Id);
          if not Endereco.CEP.IsEmpty then
            FPessoaController.UpdatePessoa(TPessoaDTO.Create(Pessoa.Id, Pessoa.Nome, Pessoa.Sobrenome, Pessoa.Documento, Endereco.CEP, Endereco.Logradouro, Endereco.Bairro, Endereco.Cidade, Endereco.UF, Endereco.Complemento));
        end;

        AtualizarVisualizacao(Atual, Total, Format('Atualizando %d de %d registros...', [Atual, Total]));
      end;

      AtualizarVisualizacao(Total, Total, 'Atualização em lote concluída com sucesso!');
      Sleep(2000);
      TThread.Queue(nil, procedure
      begin
        pnlStatusAtualizacao.Visible := False;
      end);

    except
      on E: Exception do
        TThread.Queue(nil, procedure
        begin
          ShowMessage('Erro: ' + E.Message);
          pnlStatusAtualizacao.Visible := False;
        end);
    end;
  end).Start;
end;

procedure TFormMenu.AtualizarVisualizacao(const Atual, Total: Integer;
  const StatusMsg: string);
begin
  TThread.Synchronize(nil, procedure
  begin
    lblStatus.Caption := StatusMsg;
    pnlStatusAtualizacao.Visible := True;
  end);
end;

function TFormMenu.DataSetToPessoaList: TList<TPessoaDTO>;
var
  PessoaList: TList<TPessoaDTO>;
  Pessoa: TPessoaDTO;
begin
  PessoaList := TList<TPessoaDTO>.Create;
  try
    dsDados.DataSet.First;
    while not dsDados.DataSet.Eof do
    begin
      Pessoa := TPessoaDTO.Create(
        dsDados.DataSet.FieldByName('ID').AsInteger,
        dsDados.DataSet.FieldByName('Nome').AsString,
        dsDados.DataSet.FieldByName('Sobrenome').AsString,
        dsDados.DataSet.FieldByName('Documento').AsString,
        dsDados.DataSet.FieldByName('Cep').AsString,
        '', '', '', '', ''
      );
      PessoaList.Add(Pessoa);
      dsDados.DataSet.Next;
    end;
  finally
    Result := PessoaList;
  end;
end;

procedure TFormMenu.FormCreate(Sender: TObject);
begin
  VerificarOuCriarIniFrontend;
  FPessoaController := TPessoaController.Create;
  dsDados := TDataSource.Create(Self);
  DBGDados.DataSource := dsDados;
  PopularGrid;
end;

procedure TFormMenu.pnlBotaoAtualizarCEPClick(Sender: TObject);
begin
  AtualizarCEPLote;
end;

procedure TFormMenu.pnlBotaoEditarClick(Sender: TObject);
var
  IDSelecionado: Integer;
  FormCadastro: TFormPessoa;
begin
  if not dsDados.DataSet.IsEmpty then
  begin
    // Obtém o ID da pessoa selecionada no DBGrid
    IDSelecionado := dsDados.DataSet.FieldByName('ID').AsInteger;

    // Cria a tela de cadastro e passa o ID para carregar os dados
    FormCadastro := TFormPessoa.Create(Self, IDSelecionado);
    try
      FormCadastro.ShowModal;
      PopularGrid;  // Atualiza a lista após edição
    finally
      FormCadastro.Free;
    end;
  end
  else
    ShowMessage('Nenhum registro selecionado para editar.');
end;

procedure TFormMenu.pnlBotaoExcluirClick(Sender: TObject);
var
  ID: Integer;
begin
  if not dsDados.DataSet.IsEmpty then
  begin
    ID := dsDados.DataSet.FieldByName('ID').AsInteger;
    if MessageDlg('Deseja realmente excluir este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try
        FPessoaController.DeletePessoa(ID);
        ShowMessage('Registro excluído com sucesso.');
        PopularGrid;
      except
        on E: Exception do
          ShowMessage('Erro ao excluir registro: ' + E.Message);
      end;
    end;
  end
  else
    ShowMessage('Nenhum registro selecionado para excluir.');
end;

procedure TFormMenu.pnlBotaoNovoClick(Sender: TObject);
var
  FormCadastro: TFormPessoa;
begin
  FormCadastro := TFormPessoa.Create(Self);
  try
    FormCadastro.ShowModal;
    PopularGrid;  // Recarrega os dados após inserção
  finally
    FormCadastro.Free;
  end;
end;

procedure TFormMenu.PopularGrid;
begin
  try
    dsDados.DataSet := FPessoaController.GetPessoasDataSet;
    dsDados.DataSet.First;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar dados: ' + E.Message);
  end;
end;

procedure TFormMenu.VerificarOuCriarIniFrontend;
var
  IniFile: TIniFile;
  FilePath: string;
begin
  FilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Frontend.ini');
  if not FileExists(FilePath) then
  begin
    IniFile := TIniFile.Create(FilePath);
    try
      IniFile.WriteString('Servidor', 'URL', 'http://localhost:9005');
    finally
      IniFile.Free;
    end;
  end;
end;

end.
