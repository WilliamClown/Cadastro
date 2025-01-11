unit PessoaRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  System.SysUtils,
  uIPessoaRepository;

type
  TPessoaRepository = class(TInterfacedObject, IPessoaRepository)
  public
    function GetAll: TJSONArray; virtual;
    function GetById(Id: Integer): TJSONObject; virtual;
    function CreateWithEndereco(Data: TJSONObject): Boolean; virtual;
    function Update(Id: Integer; Data: TJSONObject): Boolean; virtual;
    function Delete(Id: Integer): Boolean; virtual;
  end;

implementation

uses
  Data;

function TPessoaRepository.GetAll: TJSONArray;
var
  Query: TFDQuery;
  ResultArray: TJSONArray;
  Item: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'SELECT * FROM pessoa';
    Query.Open;
    ResultArray := TJSONArray.Create;

    while not Query.Eof do
    begin
      Item := TJSONObject.Create;
      Item.AddPair('idpessoa', TJSONNumber.Create(Query.FieldByName('idpessoa').AsLargeInt));
      Item.AddPair('flnatureza', TJSONNumber.Create(Query.FieldByName('flnatureza').AsInteger));
      Item.AddPair('dsdocumento', Query.FieldByName('dsdocumento').AsString);
      Item.AddPair('nmprimeiro', Query.FieldByName('nmprimeiro').AsString);
      Item.AddPair('nmsegundo', Query.FieldByName('nmsegundo').AsString);
      Item.AddPair('dtregistro', Query.FieldByName('dtregistro').AsString);
      ResultArray.AddElement(Item);
      Query.Next;
    end;

    Result := ResultArray;
  finally
    Query.Free;
  end;
end;

function TPessoaRepository.GetById(Id: Integer): TJSONObject;
var
  Query: TFDQuery;
  ResultObj: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'SELECT * FROM pessoa WHERE idpessoa = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.Open;

    if not Query.IsEmpty then
    begin
      ResultObj := TJSONObject.Create;
      ResultObj.AddPair('idpessoa', TJSONNumber.Create(Query.FieldByName('idpessoa').AsLargeInt));
      ResultObj.AddPair('flnatureza', TJSONNumber.Create(Query.FieldByName('flnatureza').AsInteger));
      ResultObj.AddPair('dsdocumento', Query.FieldByName('dsdocumento').AsString);
      ResultObj.AddPair('nmprimeiro', Query.FieldByName('nmprimeiro').AsString);
      ResultObj.AddPair('nmsegundo', Query.FieldByName('nmsegundo').AsString);
      ResultObj.AddPair('dtregistro', Query.FieldByName('dtregistro').AsString);
      Result := ResultObj;
    end
    else
      Result := nil;
  finally
    Query.Free;
  end;
end;

function TPessoaRepository.CreateWithEndereco(Data: TJSONObject): Boolean;
var
  Query: TFDQuery;
  PessoaData, EnderecoData: TJSONObject;
  IdPessoa: Integer;
begin
  Result := False;
  PessoaData := Data.GetValue<TJSONObject>('pessoa');
  EnderecoData := Data.GetValue<TJSONObject>('endereco');
  if not Assigned(PessoaData) or not Assigned(EnderecoData) then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.Connection.StartTransaction;
    try
      Query.SQL.Text := 'INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) RETURNING idpessoa';
      Query.ParamByName('flnatureza').AsInteger := PessoaData.GetValue<integer>('flnatureza');
      Query.ParamByName('dsdocumento').AsString := PessoaData.GetValue<string>('dsdocumento');
      Query.ParamByName('nmprimeiro').AsString := PessoaData.GetValue<string>('nmprimeiro');
      Query.ParamByName('nmsegundo').AsString := PessoaData.GetValue<string>('nmsegundo');
      Query.ParamByName('dtregistro').AsDate := PessoaData.GetValue<TDate>('dtregistro');
      Query.Open;
      IdPessoa := Query.FieldByName('idpessoa').AsInteger;

      Query.SQL.Text := 'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';
      Query.ParamByName('idpessoa').AsInteger := IdPessoa;
      Query.ParamByName('dscep').AsString := EnderecoData.GetValue<string>('dscep');
      Query.ExecSQL;

      Query.Connection.Commit;
      Result := True;
    except
      Query.Connection.Rollback;
      raise;
    end;
  finally
    Query.Free;
  end;
end;

function TPessoaRepository.Update(Id: Integer; Data: TJSONObject): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'UPDATE pessoa SET flnatureza = :flnatureza, dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo, dtregistro = :dtregistro WHERE idpessoa = :id';
    Query.ParamByName('flnatureza').AsInteger := Data.GetValue<integer>('flnatureza');
    Query.ParamByName('dsdocumento').AsString := Data.GetValue<string>('dsdocumento');
    Query.ParamByName('nmprimeiro').AsString := Data.GetValue<string>('nmprimeiro');
    Query.ParamByName('nmsegundo').AsString := Data.GetValue<string>('nmsegundo');
    Query.ParamByName('dtregistro').AsDate := Data.GetValue<TDate>('dtregistro');
    Query.ParamByName('id').AsInteger := Id;
    Query.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
  Query.Free;
end;

function TPessoaRepository.Delete(Id: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'DELETE FROM pessoa WHERE idpessoa = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
  Query.Free;
end;

end.
