unit uIEnderecoRepository;

interface

uses
  System.JSON;

type
  IEnderecoRepository = interface
    ['{682ECC49-7281-4ECC-AD36-A51699098D75}']
    function GetAll: TJSONArray;
    function GetById(Id: Integer): TJSONObject;
    function Update(Id: Integer; Data: TJSONObject): Boolean;
    function UpdateEndereco(IdPessoa: Integer; EnderecoData: TJSONObject): Boolean;
    function UpdateEnderecoIntegracao(IdPessoa: Integer; EnderecoData: TJSONObject): Boolean;
  end;

implementation

end.
