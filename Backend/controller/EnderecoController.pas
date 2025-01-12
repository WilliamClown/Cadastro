unit EnderecoController;

interface

uses
  Horse, System.SysUtils, System.JSON;

type
  TEnderecoController = class
  public
    class procedure GetEnderecos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetEnderecoById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure UpdateEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

uses
  EnderecoRepositoryFactory;

class procedure TEnderecoController.GetEnderecos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Enderecos: TJSONArray;
begin
  Enderecos := TEnderecoRepositoryFactory.CreateRepository.GetAll;
  Res.Send<TJSONArray>(Enderecos);
end;

class procedure TEnderecoController.UpdateEndereco(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  Body: TJSONObject;
  PessoaID: Integer;
begin
  // Obtém o ID da URL
  PessoaID := Req.Params['id'].ToInteger;
  Body := Req.Body<TJSONObject>;

  // Valida o JSON recebido
  if not Assigned(Body) then
  begin
    Res.Status(400).Send('Erro: Corpo da requisição não pode estar vazio.');
    Exit;
  end;

  try
    // Chama o repositório para atualizar o endereço e a tabela endereco_integracao
    if TEnderecoRepositoryFactory.CreateRepository.UpdateEndereco(PessoaID, Body) and
       TEnderecoRepositoryFactory.CreateRepository.UpdateEnderecoIntegracao(PessoaID, Body) then
      Res.Send('Endereço e integração atualizados com sucesso.')
    else
      Res.Status(400).Send('Erro ao atualizar endereço e integração.');
  except
    on E: Exception do
      Res.Status(500).Send('Erro ao atualizar endereço: ' + E.Message);
  end;
end;

class procedure TEnderecoController.GetEnderecoById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Endereco: TJSONObject;
  Id: Integer;
begin
  Id := Req.Params['id'].ToInteger;
  Endereco := TEnderecoRepositoryFactory.CreateRepository.GetById(Id);
  if Assigned(Endereco) then
    Res.Send<TJSONObject>(Endereco)
  else
    Res.Status(404).Send('Endereço não encontrado');
end;

end.

