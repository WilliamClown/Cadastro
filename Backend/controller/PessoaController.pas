unit PessoaController;

interface

uses
  Horse,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  PessoaRepositoryFactory,
  uIPessoaRepository;

type
  TPessoaController = class
  public
    class procedure CreateLotePessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetPessoaById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure CreatePessoaComEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure UpdatePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure DeletePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

class procedure TPessoaController.GetPessoas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Pessoas: TJSONArray;
begin
  try
    Pessoas := TPessoaRepositoryFactory.CreateRepository.GetAll;
    Res.Send<TJSONArray>(Pessoas);
  except
    on E: Exception do
    begin
      if E.Message.Contains('connection reset by peer') then
        Res.Status(503).Send('Erro: Conexão interrompida pelo cliente durante a consulta.')
      else
        Res.Status(500).Send('Erro ao buscar pessoas: ' + E.Message);
    end;
  end;
end;

class procedure TPessoaController.GetPessoaById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Pessoa: TJSONObject;
  Id: Integer;
begin
  Id := Req.Params['id'].ToInteger;
  try
    Pessoa := TPessoaRepositoryFactory.CreateRepository.GetById(Id);
    if Assigned(Pessoa) then
      Res.Send<TJSONObject>(Pessoa)
    else
      Res.Status(404).Send('Pessoa não encontrada');
  except
    on E: Exception do
    begin
      Res.Status(500).Send('Erro ao buscar pessoa: ' + E.Message);
    end;
  end;
end;

class procedure TPessoaController.CreateLotePessoas(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  JSONBody: TJSONArray;
  i: Integer;
  PessoaData: TJSONObject;
  Success: Boolean;
  BodyContent: string;
begin
  BodyContent := Req.Body;
  try
    JSONBody := TJSONArray(TJSONObject.ParseJSONValue(BodyContent));
    if not Assigned(JSONBody) then
    begin
      Res.Status(400).Send('Erro: Requisição sem body ou inválida');
      Exit;
    end;
  except
    on E: Exception do
    begin
      Res.Status(400).Send('Erro ao processar JSON: ' + E.Message);
      Exit;
    end;
  end;

  Success := True;
  for i := 0 to JSONBody.Count - 1 do
  begin
    PessoaData := JSONBody.Items[i] as TJSONObject;
    try
      if not TPessoaRepositoryFactory.CreateRepository.CreateWithEndereco(PessoaData) then
      begin
        Success := False;
        Break;
      end;
    except
      on E: Exception do
      begin
        Success := False;
        Break;
      end;
    end;
  end;

  if Success then
    Res.Status(201).Send('Lote de pessoas inserido com sucesso')
  else
    Res.Status(400).Send('Erro ao inserir lote de pessoas');
end;

class procedure TPessoaController.CreatePessoaComEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Body, PessoaData, EnderecoData: TJSONObject;
  Repository: IPessoaRepository;
begin
  Body := Req.Body<TJSONObject>;
  PessoaData := Body.GetValue<TJSONObject>('pessoa');
  EnderecoData := Body.GetValue<TJSONObject>('endereco');

  if not Assigned(PessoaData) then
  begin
    Res.Status(400).Send('Erro: Dados da pessoa são obrigatórios.');
    Exit;
  end;

  if not Assigned(EnderecoData) or EnderecoData.GetValue<string>('dscep').IsEmpty then
  begin
    Res.Status(400).Send('Erro: Dados do endereço são obrigatórios e o CEP não pode estar vazio.');
    Exit;
  end;

  try
    Repository := TPessoaRepositoryFactory.CreateRepository;
    if Repository.CreateWithEndereco(Body) then
      Res.Status(201).Send('Pessoa e endereço cadastrados com sucesso.')
    else
      Res.Status(500).Send('Erro ao cadastrar pessoa e endereço.');
  except
    on E: Exception do
    begin
      if E.Message.Contains('connection reset by peer') then
        Res.Status(503).Send('Erro: Conexão interrompida pelo cliente. Por favor, tente novamente.')
      else
        Res.Status(500).Send('Erro interno: ' + E.Message);
    end;
  end;
end;

class procedure TPessoaController.UpdatePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
  Body: TJSONObject;
begin
  Id := Req.Params['id'].ToInteger;
  Body := Req.Body<TJSONObject>;
  try
    if TPessoaRepositoryFactory.CreateRepository.Update(Id, Body) then
      Res.Send('Pessoa atualizada com sucesso')
    else
      Res.Status(400).Send('Erro ao atualizar pessoa');
  except
    on E: Exception do
    begin
      Res.Status(500).Send('Erro ao atualizar os dados: ' + E.Message);
    end;
  end;
end;

class procedure TPessoaController.DeletePessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
begin
  Id := Req.Params['id'].ToInteger;
  try
    if TPessoaRepositoryFactory.CreateRepository.Delete(Id) then
      Res.Send('Pessoa excluída com sucesso')
    else
      Res.Status(400).Send('Erro ao excluir pessoa');
  except
    on E: Exception do
    begin
      Res.Status(500).Send('Erro ao excluir pessoa: ' + E.Message);
    end;
  end;
end;

end.

