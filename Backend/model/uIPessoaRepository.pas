unit uIPessoaRepository;

interface

uses
  System.JSON;

type
  IPessoaRepository = interface
    ['{63F8AB44-6B2E-43EE-A755-E48883735CBE}']
    function GetAll: TJSONArray;
    function GetById(Id: Integer): TJSONObject;
    function CreateWithEndereco(Data: TJSONObject): Boolean;
    function Update(Id: Integer; Data: TJSONObject): Boolean;
    function Delete(Id: Integer): Boolean;
  end;

implementation

end.
