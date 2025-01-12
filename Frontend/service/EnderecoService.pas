unit EnderecoService;

interface

uses
  System.SysUtils,
  System.Net.HttpClient,
  System.JSON,
  EnderecoDTO,
  System.Classes;

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
  StringStream: TStringStream;
begin
  Result := Default(TEnderecoDTO);
  HttpClient := THttpClient.Create;
  StringStream := nil;
  try
    try
      HttpResponse := HttpClient.Get(Format('https://opencep.com/v1/%s', [CEP]));

      if HttpResponse.StatusCode = 200 then
      begin
        JSONRetorno := TJSONObject.ParseJSONValue(HttpResponse.ContentAsString) as TJSONObject;
        try
          if Assigned(JSONRetorno) and (JSONRetorno.GetValue('erro') = nil) then
          begin
            Result := TEnderecoDTO.Create(
              JSONRetorno.GetValue<string>('logradouro', ''),
              JSONRetorno.GetValue<string>('bairro', ''),
              JSONRetorno.GetValue<string>('localidade', ''),
              JSONRetorno.GetValue<string>('uf', ''),
              CEP,
              JSONRetorno.GetValue<string>('complemento', '')
            );
          end
          else
            raise Exception.Create('Erro: CEP não encontrado ou inválido.');
        finally
          JSONRetorno.Free;
        end;
      end
      else
        raise Exception.Create('Erro ao buscar endereço: ' + IntToStr(HttpResponse.StatusCode));
    except
      on E: Exception do
        raise Exception.CreateFmt('Erro ao buscar endereço pelo CEP %s: %s', [CEP, E.Message]);
    end;
  finally
    HttpClient.Free;
    if Assigned(StringStream) then
      StringStream.Free;
  end;
end;

class function TEnderecoServiceFactory.CreateService: IEnderecoService;
begin
  Result := TEnderecoService.Create;
end;

end.

