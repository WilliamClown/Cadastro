unit PessoaRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.SysUtils,
  System.Generics.Collections,
  Data.DB,
  uIPessoaRepository;

type
  TPessoaRepository = class(TInterfacedObject, IPessoaRepository)
  public
    function GetAll: TJSONArray; virtual;
    function GetById(Id: Integer): TJSONObject; virtual;
    function CreateWithEndereco(Data: TJSONObject): Boolean; virtual;
    function Update(Id: Integer; Data: TJSONObject): Boolean; virtual;
    function Delete(Id: Integer): Boolean; virtual;
    function CreateLotePessoas(const BodyArray: TJSONArray): Boolean; virtual;
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
    Query.Connection := DMData.FDConnection;
    Query.SQL.Text := 'SELECT p.idpessoa, p.flnatureza, p.dsdocumento, p.nmprimeiro, p.nmsegundo, p.dtregistro, e.dscep '+
                      'FROM pessoa p '+
                      'inner join endereco e '+
                      'on e.idpessoa = p.idpessoa '+
                      'order by p.idpessoa';
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
      Item.AddPair('dscep', Query.FieldByName('dscep').AsString);

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
    Query.Connection := DMData.FDConnection;
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

function TPessoaRepository.CreateLotePessoas( const BodyArray: TJSONArray): Boolean;
var
  FDQueryPessoa, FDQueryEndereco, FDQueryIntegracao: TFDQuery;
  i: Integer;
  PessoaData, EnderecoData: TJSONObject;
  ArraySize: Integer;
  IdPessoas, IdEnderecos: TArray<Variant>;
begin
  Result := False;
  if BodyArray.Count = 0 then
    Exit;

  ArraySize := BodyArray.Count;
  SetLength(IdPessoas, ArraySize);
  SetLength(IdEnderecos, ArraySize);

  FDQueryPessoa := TFDQuery.Create(nil);
  FDQueryEndereco := TFDQuery.Create(nil);
  FDQueryIntegracao := TFDQuery.Create(nil);
  try
    FDQueryPessoa.Connection := DMData.FDConnection;
    FDQueryPessoa.SQL.Text := 'INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) RETURNING idpessoa';

    FDQueryPessoa.Params.ArraySize := ArraySize;

    for i := 0 to ArraySize - 1 do
    begin
      PessoaData := BodyArray.Items[i].GetValue<TJSONObject>('pessoa');
      EnderecoData := BodyArray.Items[i].GetValue<TJSONObject>('endereco');

      if not Assigned(PessoaData) or not Assigned(EnderecoData) then
        raise Exception.CreateFmt('Dados de pessoa ou endereço ausentes no registro %d', [i + 1]);

      FDQueryPessoa.Params[0].AsIntegers[i] := PessoaData.GetValue<integer>('flnatureza');
      FDQueryPessoa.Params[1].AsStrings[i] := PessoaData.GetValue<string>('dsdocumento');
      FDQueryPessoa.Params[2].AsStrings[i] := PessoaData.GetValue<string>('nmprimeiro');
      FDQueryPessoa.Params[3].AsStrings[i] := PessoaData.GetValue<string>('nmsegundo');
      FDQueryPessoa.Params[4].AsDateTimes[i] := Now;
    end;

    // Executa o ArrayDML sem passar o terceiro parâmetro, pois não é suportado em todas as versões do FireDAC
    FDQueryPessoa.Execute(ArraySize);

    // Coletar IDs manualmente
    for i := 0 to ArraySize - 1 do
    begin
      FDQueryPessoa.NextRecordSet;
      IdPessoas[i] := FDQueryPessoa.FieldByName('idpessoa').Value;
    end;

    FDQueryEndereco.Connection := DMData.FDConnection;
    FDQueryEndereco.SQL.Text := 'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep) RETURNING idendereco';
    FDQueryEndereco.Params.ArraySize := ArraySize;

    for i := 0 to ArraySize - 1 do
    begin
      FDQueryEndereco.Params[0].AsIntegers[i] := IdPessoas[i];
      FDQueryEndereco.Params[1].AsStrings[i] := EnderecoData.GetValue<string>('dscep');
    end;

    FDQueryEndereco.Execute(ArraySize);

    for i := 0 to ArraySize - 1 do
    begin
      FDQueryEndereco.NextRecordSet;
      IdEnderecos[i] := FDQueryEndereco.FieldByName('idendereco').Value;
    end;

    FDQueryIntegracao.Connection := DMData.FDConnection;
    FDQueryIntegracao.SQL.Text := 'INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento)';
    FDQueryIntegracao.Params.ArraySize := ArraySize;

    for i := 0 to ArraySize - 1 do
    begin
      FDQueryIntegracao.Params[0].AsIntegers[i] := IdEnderecos[i];
      FDQueryIntegracao.Params[1].AsStrings[i] := EnderecoData.GetValue<string>('dsuf');
      FDQueryIntegracao.Params[2].AsStrings[i] := EnderecoData.GetValue<string>('nmcidade');
      FDQueryIntegracao.Params[3].AsStrings[i] := EnderecoData.GetValue<string>('nmbairro');
      FDQueryIntegracao.Params[4].AsStrings[i] := EnderecoData.GetValue<string>('nmlogradouro');
      FDQueryIntegracao.Params[5].AsStrings[i] := EnderecoData.GetValue<string>('dscomplemento');
    end;

    FDQueryIntegracao.Execute(ArraySize);

    DMData.FDConnection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      DMData.FDConnection.Rollback;
      raise Exception.Create('Erro ao inserir lote de registros: ' + E.Message);
    end;
  end;
  FDQueryPessoa.Free;
  FDQueryEndereco.Free;
  FDQueryIntegracao.Free;
end;

function TPessoaRepository.CreateWithEndereco(Data: TJSONObject): Boolean;
var
  Query: TFDQuery;
  PessoaData, EnderecoData: TJSONObject;
  IdPessoa, IdEndereco: Integer;
begin
  Result := False;
  PessoaData := Data.GetValue<TJSONObject>('pessoa');
  EnderecoData := Data.GetValue<TJSONObject>('endereco');
  if not Assigned(PessoaData) or not Assigned(EnderecoData) then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMData.FDConnection;
    Query.Connection.StartTransaction;
    try
      Query.SQL.Text := 'INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro) RETURNING idpessoa';
      Query.ParamByName('flnatureza').AsInteger := PessoaData.GetValue<integer>('flnatureza');
      Query.ParamByName('dsdocumento').AsString := PessoaData.GetValue<string>('dsdocumento');
      Query.ParamByName('nmprimeiro').AsString := PessoaData.GetValue<string>('nmprimeiro');
      Query.ParamByName('nmsegundo').AsString := PessoaData.GetValue<string>('nmsegundo');
      Query.ParamByName('dtregistro').AsDate := Now;
      Query.Open;
      IdPessoa := Query.FieldByName('idpessoa').AsInteger;

      Query.SQL.Text := 'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep) RETURNING idendereco';
      Query.ParamByName('idpessoa').AsInteger := IdPessoa;
      Query.ParamByName('dscep').AsString := EnderecoData.GetValue<string>('dscep');
      Query.Open;
      IdEndereco := Query.FieldByName('idendereco').AsInteger;

      Query.SQL.Text := 'INSERT INTO endereco_integracao  (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento)';
       Query.ParamByName('idendereco').AsInteger := IdEndereco;
       Query.ParamByName('dsuf').AsString := EnderecoData.GetValue<string>('dsuf');
       Query.ParamByName('nmcidade').AsString := EnderecoData.GetValue<string>('nmcidade');
       Query.ParamByName('nmbairro').AsString := EnderecoData.GetValue<string>('nmbairro');
       Query.ParamByName('nmlogradouro').AsString := EnderecoData.GetValue<string>('nmlogradouro');
       Query.ParamByName('dscomplemento').AsString := EnderecoData.GetValue<string>('dscomplemento');
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
  PessoaData: TJSONObject;
begin
  PessoaData := Data.GetValue<TJSONObject>('pessoa');
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMData.FDConnection;
    Query.SQL.Text := 'UPDATE pessoa SET flnatureza = :flnatureza, dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo WHERE idpessoa = :id';
    Query.ParamByName('flnatureza').AsInteger := PessoaData.GetValue<integer>('flnatureza');
    Query.ParamByName('dsdocumento').AsString := PessoaData.GetValue<string>('dsdocumento');
    Query.ParamByName('nmprimeiro').AsString := PessoaData.GetValue<string>('nmprimeiro');
    Query.ParamByName('nmsegundo').AsString := PessoaData.GetValue<string>('nmsegundo');
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
    Query.Connection := DMData.FDConnection;
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
