unit EnderecoController;

interface

uses
  Horse, System.SysUtils, System.JSON;

type
  TEnderecoController = class
  public
    class procedure GetEnderecos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetEnderecoById(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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

