unit PessoaService;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  Generics.Collections,
  PessoaDTO,
  System.JSON,
  System.Net.URLClient,
  Data.DB,
  Datasnap.DBClient,
  EnderecoDTO;

type
  IPessoaService = interface
    ['{72E817FF-D64E-434E-814B-FCE346DDB458}']
    function SalvarPessoaComEndereco(const Pessoa: TPessoaDTO): Boolean;
    function SalvarLote(const Pessoas: TArray<TPessoaDTO>): Boolean;
    function GetPessoas: TClientDataSet;
    function AtualizarEndereco(const PessoaID: Integer; const Endereco: TEnderecoDTO): Boolean;
    procedure ExcluirPessoa(ID: Integer);
    function BuscarPessoaPorID(ID: Integer): TPessoaDTO;
    function BuscarEnderecoPorID(ID: Integer): TEnderecoDTO;
  end;

  TPessoaService = class(TInterfacedObject, IPessoaService)
  private
    FBaseURL: string;
  public
    constructor Create(const ABaseURL: string);
    function SalvarPessoaComEndereco(const Pessoa: TPessoaDTO): Boolean;
    function SalvarLote(const Pessoas: TArray<TPessoaDTO>): Boolean;
    function GetPessoas: TClientDataSet;
    function AtualizarEndereco(const PessoaID: Integer; const Endereco: TEnderecoDTO): Boolean;
    procedure ExcluirPessoa(ID: Integer);
    function BuscarPessoaPorID(ID: Integer): TPessoaDTO;
    function BuscarEnderecoPorID(ID: Integer): TEnderecoDTO;
  end;

  TPessoaServiceFactory = class
  public
    class function CreateService(const ABaseURL: string): IPessoaService;
  end;

implementation

function TPessoaService.AtualizarEndereco(const PessoaID: Integer;
  const Endereco: TEnderecoDTO): Boolean;
var
  HttpClient: THttpClient;
  HttpRequest: TJSONObject;
  HttpResponse: IHTTPResponse;
begin
  Result := False;
  HttpClient := THttpClient.Create;
  try
    HttpRequest := TJSONObject.Create;
    try
      HttpRequest.AddPair('dscep', Endereco.CEP);
      HttpRequest.AddPair('nmlogradouro', Endereco.Logradouro);
      HttpRequest.AddPair('nmbairro', Endereco.Bairro);
      HttpRequest.AddPair('nmcidade', Endereco.Cidade);
      HttpRequest.AddPair('dsuf', Endereco.UF);

      HttpResponse := HttpClient.Put(
        FBaseURL + Format('/enderecos/%d', [PessoaID]),
        TStringStream.Create(HttpRequest.ToString, TEncoding.UTF8),
        nil,
        [TNameValuePair.Create('Content-Type', 'application/json; charset=utf-8')]
      );

      Result := HttpResponse.StatusCode in [200, 201];
    finally
      HttpRequest.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

function TPessoaService.BuscarEnderecoPorID(ID: Integer): TEnderecoDTO;
var
  HttpClient: THttpClient;
  HttpResponse: IHTTPResponse;
  JSONResult: TJSONObject;
  CEP,
  Logradouro,
  Bairro,
  Cidade,
  UF,
  Complemento: string;
begin
  HttpClient := THttpClient.Create;
  try
    HttpResponse := HttpClient.Get(FBaseURL + Format('/enderecos/%d', [ID]));

    if HttpResponse.StatusCode = 200 then
    begin
      JSONResult := TJSONObject.ParseJSONValue(HttpResponse.ContentAsString) as TJSONObject;
      try
        if Assigned(JSONResult) then
        begin
          CEP := JSONResult.GetValue<string>('dscep', '');
          Logradouro := JSONResult.GetValue<string>('nmlogradouro', '');
          Bairro := JSONResult.GetValue<string>('nmbairro', '');
          Cidade := JSONResult.GetValue<string>('nmcidade', '');
          UF := JSONResult.GetValue<string>('dsuf', '');
          Complemento := JSONResult.GetValue<string>('dscomplemento', '');

          Result := TEnderecoDTO.Create(Logradouro, Bairro, Cidade, UF, CEP, Complemento);
        end
        else
          raise Exception.Create('Erro: Endereço não encontrado.');
      finally
        JSONResult.Free;
      end;
    end
    else
      raise Exception.Create('Erro ao buscar endereço: ' + HttpResponse.ContentAsString);
  finally
    HttpClient.Free;
  end;
end;

function TPessoaService.BuscarPessoaPorID(ID: Integer): TPessoaDTO;
var
  HttpClient: THttpClient;
  HttpResponse: IHTTPResponse;
  JSONResult: TJSONObject;
  Nome, Sobrenome, Documento: string;
  PessoaID: Integer;
begin
  HttpClient := THttpClient.Create;
  try
    HttpResponse := HttpClient.Get(FBaseURL + Format('/pessoas/%d', [ID]));

    if HttpResponse.StatusCode = 200 then
    begin
      JSONResult := TJSONObject.ParseJSONValue(HttpResponse.ContentAsString) as TJSONObject;
      try
        if Assigned(JSONResult) then
        begin
          PessoaID := JSONResult.GetValue<Integer>('idpessoa', 0);
          Nome := JSONResult.GetValue<string>('nmprimeiro', '');
          Sobrenome := JSONResult.GetValue<string>('nmsegundo', '');
          Documento := JSONResult.GetValue<string>('dsdocumento', '');

          // Atribui apenas dados de pessoa
          Result := TPessoaDTO.Create(PessoaID, Nome, Sobrenome, Documento, '', '', '', '', '');
        end
        else
          raise Exception.Create('Erro: Pessoa não encontrada.');
      finally
        JSONResult.Free;
      end;
    end
    else
      raise Exception.Create('Erro ao buscar pessoa: ' + HttpResponse.ContentAsString);
  finally
    HttpClient.Free;
  end;
end;

constructor TPessoaService.Create(const ABaseURL: string);
begin
  FBaseURL := ABaseURL;
end;

function TPessoaService.SalvarPessoaComEndereco(const Pessoa: TPessoaDTO): Boolean;
var
  HttpClient: THttpClient;
  HttpRequest: TJSONObject;
  HttpResponse: IHTTPResponse;
  StringStream: TStringStream;
begin
  HttpClient := THttpClient.Create;
  try
    HttpRequest := TJSONObject.Create;
    try
      HttpRequest.AddPair('pessoa', TJSONObject.Create
        .AddPair('nmprimeiro', Pessoa.Nome)
        .AddPair('nmsegundo', Pessoa.Sobrenome)
        .AddPair('dsdocumento', Pessoa.Documento)
        .AddPair('flnatureza', '1'));
      HttpRequest.AddPair('endereco', TJSONObject.Create
        .AddPair('dscep', Pessoa.CEP)
        .AddPair('nmlogradouro', Pessoa.Logradouro)
        .AddPair('nmbairro', Pessoa.Bairro)
        .AddPair('nmcidade', Pessoa.Cidade)
        .AddPair('dsuf', Pessoa.UF));

      StringStream := TStringStream.Create(HttpRequest.ToString, TEncoding.UTF8);

      try
        if Pessoa.Id > 0 then
        begin
          HttpResponse := HttpClient.Put(FBaseURL + Format('/pessoas/%d', [Pessoa.Id]), TStringStream.Create(HttpRequest.ToString, TEncoding.UTF8), nil, [TNameValuePair.Create('Content-Type', 'application/json; charset=utf-8')]);

          if HttpResponse.StatusCode in [200, 201] then
          begin
            HttpResponse := HttpClient.Put(FBaseURL + Format('/enderecos/%d', [Pessoa.Id]), TStringStream.Create(HttpRequest.GetValue<TJSONObject>('endereco').ToString, TEncoding.UTF8), nil, [TNameValuePair.Create('Content-Type', 'application/json; charset=utf-8')]);
            Result := HttpResponse.StatusCode in [200, 201];
          end;
        end
        else
          HttpResponse := HttpClient.Post(FBaseURL + '/pessoas', TStringStream.Create(HttpRequest.ToString, TEncoding.UTF8), nil, [TNameValuePair.Create('Content-Type', 'application/json; charset=utf-8')]);

        Result := HttpResponse.StatusCode in [200, 201];
      finally
        StringStream.Free;
      end;
    finally
      HttpRequest.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

procedure TPessoaService.ExcluirPessoa(ID: Integer);
var
  HttpClient: THttpClient;
  HttpResponse: IHTTPResponse;
begin
  HttpClient := THttpClient.Create;
  try
    HttpResponse := HttpClient.Delete(FBaseURL + Format('/pessoas/%d', [ID]));

    if HttpResponse.StatusCode <> 200 then
      raise Exception.Create('Erro ao excluir registro: ' + HttpResponse.ContentAsString);
  finally
    HttpClient.Free;
  end;
end;

function TPessoaService.GetPessoas: TClientDataSet;
var
  HttpClient: THttpClient;
  HttpResponse: IHTTPResponse;
  JSONArray: TJSONArray;
  JSONValue: TJSONValue;
  ClientDataSet: TClientDataSet;
begin
  HttpClient := THttpClient.Create;
  try
    HttpResponse := HttpClient.Get(FBaseURL + '/pessoas');

    if HttpResponse.StatusCode = 200 then
    begin
      JSONArray := TJSONObject.ParseJSONValue(HttpResponse.ContentAsString) as TJSONArray;
      ClientDataSet := TClientDataSet.Create(nil);
      ClientDataSet.FieldDefs.Add('ID', ftInteger);
      ClientDataSet.FieldDefs.Add('Natureza', ftInteger);
      ClientDataSet.FieldDefs.Add('Documento', ftString, 20);
      ClientDataSet.FieldDefs.Add('Nome', ftString, 100);
      ClientDataSet.FieldDefs.Add('Sobrenome', ftString, 100);
      ClientDataSet.FieldDefs.Add('Data Registro', ftDateTime);
      ClientDataSet.FieldDefs.Add('Cep', ftString, 15);
      ClientDataSet.CreateDataSet;

      for JSONValue in JSONArray do
        ClientDataSet.AppendRecord([
          JSONValue.GetValue<Integer>('idpessoa'),
          JSONValue.GetValue<Integer>('flnatureza'),
          JSONValue.GetValue<string>('dsdocumento'),
          JSONValue.GetValue<string>('nmprimeiro'),
          JSONValue.GetValue<string>('nmsegundo'),
          JSONValue.GetValue<string>('dtregistro'),
          JSONValue.GetValue<string>('dscep')
        ]);

      Result := ClientDataSet;
    end
    else
      raise Exception.Create('Erro ao buscar pessoas: ' + HttpResponse.ContentAsString);
  finally
    HttpClient.Free;
  end;
end;

function TPessoaService.SalvarLote(const Pessoas: TArray<TPessoaDTO>): Boolean;
var
  HttpClient: THttpClient;
  HttpArray: TJSONArray;
  HttpResponse: IHTTPResponse;
  StringStream: TStringStream;
  Pessoa: TPessoaDTO;
begin
  HttpClient := THttpClient.Create;
  HttpClient.ConnectionTimeout := 60000;
  HttpClient.ResponseTimeout := 60000;
  try
    HttpArray := TJSONArray.Create;
    try
      for Pessoa in Pessoas do
      begin
        HttpArray.AddElement(TJSONObject.Create
          .AddPair('pessoa', TJSONObject.Create
            .AddPair('nmprimeiro', Pessoa.Nome)
            .AddPair('nmsegundo', Pessoa.Sobrenome)
            .AddPair('dsdocumento', Pessoa.Documento)
            .AddPair('flnatureza', '1'))
          .AddPair('endereco', TJSONObject.Create
            .AddPair('dscep', Pessoa.CEP)
            .AddPair('nmlogradouro', Pessoa.Logradouro)
            .AddPair('nmbairro', Pessoa.Bairro)
            .AddPair('nmcidade', Pessoa.Cidade)
            .AddPair('dsuf', Pessoa.UF))
          );
      end;

      // Utiliza TStringStream com TEncoding.UTF8 para garantir suporte a caracteres Unicode
      StringStream := TStringStream.Create(HttpArray.ToString, TEncoding.UTF8);
      try
        HttpResponse := HttpClient.Post(FBaseURL + '/pessoas/lote', StringStream, nil, [TNameValuePair.Create('Content-Type', 'application/json; charset=utf-8')]);

        Result := True;

        if HttpResponse.StatusCode <> 201 then
          raise Exception.Create('Erro ao inserir lote: ' + HttpResponse.ContentAsString);
      finally
        StringStream.Free;
      end;
    finally
      HttpArray.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

class function TPessoaServiceFactory.CreateService(const ABaseURL: string): IPessoaService;
begin
  Result := TPessoaService.Create(ABaseURL);
end;

end.
