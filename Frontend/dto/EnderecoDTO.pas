unit EnderecoDTO;

interface

uses
  System.SysUtils;

type
  TEnderecoDTO = record
  public
    Logradouro: string;
    Bairro: string;
    Cidade: string;
    UF: string;
    CEP: string;
    Complemento: string;
    constructor Create(const ALogradouro, ABairro, ACidade, AUF, ACEP, AComplemento: string);
  end;

implementation

constructor TEnderecoDTO.Create(const ALogradouro, ABairro, ACidade, AUF, ACEP, AComplemento: string);
begin
  Logradouro := ALogradouro;
  Bairro := ABairro;
  Cidade := ACidade;
  UF := AUF;
  CEP := ACEP;
  Complemento := AComplemento;
end;

end.

