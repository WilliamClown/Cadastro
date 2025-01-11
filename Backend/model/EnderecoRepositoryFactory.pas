unit EnderecoRepositoryFactory;

interface

uses
  uIEnderecoRepository,
  EnderecoRepository;

type
  TEnderecoRepositoryFactory = class
  public
    class function CreateRepository: IEnderecoRepository;
  end;

implementation

class function TEnderecoRepositoryFactory.CreateRepository: IEnderecoRepository;
begin
  Result := TEnderecoRepository.Create;
end;

end.

