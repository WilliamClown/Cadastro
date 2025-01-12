unit PessoaDTO;

interface

uses
  System.SysUtils;

type
  TPessoaDTO = record
  public
    Id: Integer;
    Nome: string;
    Sobrenome: String;
    Documento: string;
    CEP: string;
    Logradouro: string;
    Bairro: string;
    Cidade: string;
    UF: string;
    constructor Create(const AId: Integer; ANome, ASobrenome, ADocumento, ACEP, ALogradouro, ABairro, ACidade, AUF: string);
  end;

implementation

constructor TPessoaDTO.Create(const AId: Integer; ANome, ASobrenome, ADocumento, ACEP, ALogradouro, ABairro, ACidade, AUF: string);
begin
  Id := AId;
  Nome := ANome;
  Sobrenome := ASobrenome;
  Documento := ADocumento;
  CEP := ACEP;
  Logradouro := ALogradouro;
  Bairro := ABairro;
  Cidade := ACidade;
  UF := AUF;
end;

end.
