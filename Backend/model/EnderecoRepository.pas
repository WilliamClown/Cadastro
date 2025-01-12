unit EnderecoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  System.SysUtils,
  uIEnderecoRepository,
  FireDAC.Stan.Param,
  Data.DB;

type
  TEnderecoRepository = class(TInterfacedObject, IEnderecoRepository)
  public
    function GetAll: TJSONArray; virtual;
    function GetById(Id: Integer): TJSONObject; virtual;
    function Update(Id: Integer; Data: TJSONObject): Boolean; virtual;
    function UpdateEndereco(IdPessoa: Integer; EnderecoData: TJSONObject): Boolean;
    function UpdateEnderecoIntegracao(IdPessoa: Integer; EnderecoData: TJSONObject): Boolean;
  end;

implementation

uses
  Data;

function TEnderecoRepository.GetAll: TJSONArray;
var
  Query: TFDQuery;
  ResultArray: TJSONArray;
  Item: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'SELECT * FROM endereco';
    Query.Open;
    ResultArray := TJSONArray.Create;

    while not Query.Eof do
    begin
      Item := TJSONObject.Create;
      Item.AddPair('idendereco', TJSONNumber.Create(Query.FieldByName('idendereco').AsLargeInt));
      Item.AddPair('idpessoa', TJSONNumber.Create(Query.FieldByName('idpessoa').AsLargeInt));
      Item.AddPair('dscep', Query.FieldByName('dscep').AsString);
      ResultArray.AddElement(Item);
      Query.Next;
    end;

    Result := ResultArray;
  finally
    Query.Free;
  end;
end;

function TEnderecoRepository.GetById(Id: Integer): TJSONObject;
var
  Query: TFDQuery;
  ResultObj: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'SELECT e.idpessoa, e.dscep, e.idendereco, ei.dscomplemento, ei.dsuf, ei.nmbairro, ei.nmcidade, ei.nmlogradouro '+
                      'FROM endereco e '+
                      'inner join endereco_integracao ei '+
                      'on e.idendereco  = ei.idendereco '+
                      'WHERE e.idendereco = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.Open;

    if not Query.IsEmpty then
    begin
      ResultObj := TJSONObject.Create;
      ResultObj.AddPair('idendereco', TJSONNumber.Create(Query.FieldByName('idendereco').AsLargeInt));
      ResultObj.AddPair('idpessoa', TJSONNumber.Create(Query.FieldByName('idpessoa').AsLargeInt));
      ResultObj.AddPair('dscep', Query.FieldByName('dscep').AsString);
      ResultObj.AddPair('dscomplemento', Query.FieldByName('dscomplemento').AsString);
      ResultObj.AddPair('dsuf', Query.FieldByName('dsuf').AsString);
      ResultObj.AddPair('nmbairro', Query.FieldByName('nmbairro').AsString);
      ResultObj.AddPair('nmcidade', Query.FieldByName('nmcidade').AsString);
      ResultObj.AddPair('nmlogradouro', Query.FieldByName('nmlogradouro').AsString);

      Result := ResultObj;
    end
    else
      Result := nil;
  finally
    Query.Free;
  end;
end;

function TEnderecoRepository.Update(Id: Integer; Data: TJSONObject): Boolean;
var
  Query: TFDQuery;
  PessoaData: TJSONObject;
begin
  PessoaData := Data.GetValue<TJSONObject>('pessoa');
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'UPDATE pessoa SET flnatureza = :flnatureza, dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo, dtregistro = :dtregistro WHERE idpessoa = :id';

    Query.ParamByName('flnatureza').AsInteger := PessoaData.GetValue<integer>('flnatureza');
    Query.ParamByName('dsdocumento').AsString := PessoaData.GetValue<string>('dsdocumento');
    Query.ParamByName('nmprimeiro').AsString := PessoaData.GetValue<string>('nmprimeiro');
    Query.ParamByName('nmsegundo').AsString := PessoaData.GetValue<string>('nmsegundo');
    Query.ParamByName('dtregistro').AsDate := PessoaData.GetValue<TDate>('dtregistro');
    Query.ParamByName('id').AsInteger := Id;
    Query.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
  Query.Free;
end;

function TEnderecoRepository.UpdateEndereco(IdPessoa: Integer;
  EnderecoData: TJSONObject): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'UPDATE endereco SET dscep = :dscep WHERE idpessoa = :idpessoa';

    Query.ParamByName('dscep').AsString := EnderecoData.GetValue<string>('dscep', '');
    Query.ParamByName('idpessoa').AsInteger := IdPessoa;

    Query.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
  Query.Free;
end;

function TEnderecoRepository.UpdateEnderecoIntegracao(IdPessoa: Integer;
  EnderecoData: TJSONObject): Boolean;
var
  Query: TFDQuery;
  EnderecoID: Integer;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DataModule1.FDConnection;
    Query.SQL.Text := 'SELECT idendereco FROM endereco WHERE idpessoa = :idpessoa';
    Query.ParamByName('idpessoa').AsInteger := IdPessoa;
    Query.Open;

    if not Query.IsEmpty then
      EnderecoID := Query.FieldByName('idendereco').AsInteger
    else
    begin
      Result := False;
      Exit;
    end;

    Query.Close;
    Query.SQL.Text := 'UPDATE endereco_integracao SET nmlogradouro = :nmlogradouro, nmbairro = :nmbairro, ' +
                      'nmcidade = :nmcidade, dsuf = :dsuf, dscomplemento = :dscomplemento WHERE idendereco = :idendereco';

    Query.ParamByName('nmlogradouro').AsString := EnderecoData.GetValue<string>('nmlogradouro', '');
    Query.ParamByName('nmbairro').AsString := EnderecoData.GetValue<string>('nmbairro', '');
    Query.ParamByName('nmcidade').AsString := EnderecoData.GetValue<string>('nmcidade', '');
    Query.ParamByName('dsuf').AsString := EnderecoData.GetValue<string>('dsuf', '');
    Query.ParamByName('dscomplemento').AsString := EnderecoData.GetValue<string>('dscomplemento', '');
    Query.ParamByName('idendereco').AsInteger := EnderecoID;

    Query.ExecSQL;
    Result := True;
  except
    Result := False;
  end;
  Query.Free;
end;

end.

