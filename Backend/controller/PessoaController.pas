unit PessoaController;

interface

uses
  Horse, System.SysUtils, System.JSON;

type
  TPessoaController = class
  public
    class procedure GetPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetPessoaById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure CreatePessoaComEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure UpdatePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure DeletePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

uses
  PessoaRepositoryFactory;

class procedure TPessoaController.GetPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Pessoas: TJSONArray;
begin
  Pessoas := TPessoaRepositoryFactory.CreateRepository.GetAll;
  Res.Send<TJSONArray>(Pessoas);
end;

class procedure TPessoaController.GetPessoaById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Pessoa: TJSONObject;
  Id: Integer;
begin
  Id := Req.Params['id'].ToInteger;
  Pessoa := TPessoaRepositoryFactory.CreateRepository.GetById(Id);
  if Assigned(Pessoa) then
    Res.Send<TJSONObject>(Pessoa)
  else
    Res.Status(404).Send('Pessoa n�o encontrada');
end;

class procedure TPessoaController.CreatePessoaComEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body, PessoaData, EnderecoData: TJSONObject;
  Cep: string;
begin
  Body := Req.Body<TJSONObject>;
  PessoaData := Body.GetValue<TJSONObject>('pessoa');
  EnderecoData := Body.GetValue<TJSONObject>('endereco');

  // Valida��o de dados obrigat�rios
  if not Assigned(PessoaData) or not Assigned(EnderecoData) then
  begin
    Res.Status(400).Send('Erro: Pessoa e endere�o s�o obrigat�rios');
    Exit;
  end;

  Cep := EnderecoData.GetValue<string>('dscep');
  if Cep.Trim.IsEmpty then
  begin
    Res.Status(400).Send('Erro: O campo CEP � obrigat�rio');
    Exit;
  end;

  if Length(Cep) <> 8 then
  begin
    Res.Status(400).Send('Erro: O CEP deve ter 8 d�gitos');
    Exit;
  end;

  if TPessoaRepositoryFactory.CreateRepository.CreateWithEndereco(Body) then
    Res.Status(201).Send('Pessoa criada com sucesso')
  else
    Res.Status(400).Send('Erro ao criar pessoa e endere�o');
end;

class procedure TPessoaController.UpdatePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
  Body: TJSONObject;
begin
  Id := Req.Params['id'].ToInteger;
  Body := Req.Body<TJSONObject>;
  if TPessoaRepositoryFactory.CreateRepository.Update(Id, Body) then
    Res.Send('Pessoa atualizada com sucesso')
  else
    Res.Status(400).Send('Erro ao atualizar pessoa');
end;

class procedure TPessoaController.DeletePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
begin
  Id := Req.Params['id'].ToInteger;
  if TPessoaRepositoryFactory.CreateRepository.Delete(Id) then
    Res.Send('Pessoa exclu�da com sucesso')
  else
    Res.Status(400).Send('Erro ao excluir pessoa');
end;

end.
