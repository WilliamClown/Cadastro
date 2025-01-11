unit PessoaRepositoryFactory;

interface

uses
  uIPessoaRepository,
  PessoaRepository;

type
  TPessoaRepositoryFactory = class
  public
    class function CreateRepository: IPessoaRepository;
  end;

implementation

class function TPessoaRepositoryFactory.CreateRepository: IPessoaRepository;
begin
  Result := TPessoaRepository.Create;
end;

end.
