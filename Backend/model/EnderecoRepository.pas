unit EnderecoRepository;

interface

uses
  System.JSON,
  FireDAC.Comp.Client,
  System.SysUtils,
  uIEnderecoRepository;

type
  TEnderecoRepository = class(TInterfacedObject, IEnderecoRepository)
  public
    function GetAll: TJSONArray; virtual;
    function GetById(Id: Integer): TJSONObject; virtual;
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
    Query.SQL.Text := 'SELECT * FROM endereco WHERE idendereco = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.Open;

    if not Query.IsEmpty then
    begin
      ResultObj := TJSONObject.Create;
      ResultObj.AddPair('idendereco', TJSONNumber.Create(Query.FieldByName('idendereco').AsLargeInt));
      ResultObj.AddPair('idpessoa', TJSONNumber.Create(Query.FieldByName('idpessoa').AsLargeInt));
      ResultObj.AddPair('dscep', Query.FieldByName('dscep').AsString);
      Result := ResultObj;
    end
    else
      Result := nil;
  finally
    Query.Free;
  end;
end;

end.

