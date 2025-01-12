unit EnderecoService;

interface

uses
  System.SysUtils,
  System.Net.HttpClient,
  EnderecoDTO,
  System.JSON;

type
  IEnderecoService = interface
    ['{782FF28B-462A-44AC-BB3A-CA9BF25B446C}']
    function BuscarEnderecoViaCep(const CEP: string): TEnderecoDTO;
  end;

  TEnderecoService = class(TInterfacedObject, IEnderecoService)
  public
    function BuscarEnderecoViaCep(const CEP: string): TEnderecoDTO;
  end;

  TEnderecoServiceFactory = class
  public
    class function CreateService: IEnderecoService;
  end;

implementation

function TEnderecoService.BuscarEnderecoViaCep(const CEP: string): TEnderecoDTO;
var
  HttpClient: THttpClient;
  HttpResponse: IHTTPResponse;
  JSONRetorno: TJSONObject;
begin
  Result := Default(TEnderecoDTO);
  HttpClient := THttpClient.Create;
  try
    HttpResponse := HttpClient.Get(Format('https://opencep.com/v1/%s', [CEP]));

    if HttpResponse.StatusCode = 200 then
    begin
      JSONRetorno := TJSONObject.ParseJSONValue(HttpResponse.ContentAsString) as TJSONObject;
      try
        if Assigned(JSONRetorno) and (JSONRetorno.GetValue('erro') = nil) then
        begin
          Result := TEnderecoDTO.Create(
            JSONRetorno.GetValue<string>('logradouro'),
            JSONRetorno.GetValue<string>('bairro'),
            JSONRetorno.GetValue<string>('localidade'),
            JSONRetorno.GetValue<string>('uf'),
            CEP,
            JSONRetorno.GetValue<string>('complemento'));
        end;
      finally
        JSONRetorno.Free;
      end;
    end;
  finally
    HttpClient.Free;
  end;
end;

class function TEnderecoServiceFactory.CreateService: IEnderecoService;
begin
  Result := TEnderecoService.Create;
end;

end.
