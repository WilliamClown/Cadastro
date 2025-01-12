unit PessoaController;

interface

uses
  System.Classes,
  System.SysUtils,
  PessoaService,
  Data.DB,
  Datasnap.DBClient,
  PessoaDTO,
  EnderecoDTO;

type
  TPessoaController = class
  private
    FPessoaService: IPessoaService;
  public
    constructor Create;
    function GetPessoasDataSet: TClientDataSet;
    procedure DeletePessoa(ID: Integer);
    procedure UpdatePessoa(const Pessoa: TPessoaDTO);
    function GetPessoaById(ID: Integer): TPessoaDTO;
    function GetEnderecoById(ID: Integer): TEnderecoDTO;
  end;

implementation

constructor TPessoaController.Create;
begin
  FPessoaService := TPessoaServiceFactory.CreateService('http://localhost:9005');
end;

function TPessoaController.GetEnderecoById(ID: Integer): TEnderecoDTO;
begin
  Result := FPessoaService.BuscarEnderecoPorID(ID);
end;

function TPessoaController.GetPessoaById(ID: Integer): TPessoaDTO;
begin
  Result := FPessoaService.BuscarPessoaPorID(ID);
end;

function TPessoaController.GetPessoasDataSet: TClientDataSet;
begin
  Result := FPessoaService.GetPessoas;
end;

procedure TPessoaController.DeletePessoa(ID: Integer);
begin
  FPessoaService.ExcluirPessoa(ID);
end;

procedure TPessoaController.UpdatePessoa(const Pessoa: TPessoaDTO);
begin
  if not FPessoaService.SalvarPessoaComEndereco(Pessoa) then
    raise Exception.Create('Erro ao atualizar a pessoa');
end;

end.
