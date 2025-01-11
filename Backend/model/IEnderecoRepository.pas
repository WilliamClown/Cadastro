unit IEnderecoRepository;

interface

uses
  System.JSON;

type
  IEnderecoRepository = interface
    ['{682ECC49-7281-4ECC-AD36-A51699098D75}']
    function GetAll: TJSONArray;
    function GetById(Id: Integer): TJSONObject;
  end;

implementation

end.
