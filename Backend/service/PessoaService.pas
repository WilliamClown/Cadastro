unit PessoaService;

interface

uses
  System.SysUtils,
  System.Classes,
  Horse,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Param,
  System.JSON,
  REST.Json;

procedure RegisterRoutes;

implementation

uses
  PessoaController, EnderecoController;

procedure RegisterRoutes;
begin
  // Rotas para Pessoa
  THorse.Get('/pessoas', TPessoaController.GetPessoas);
  THorse.Get('/pessoas/:id', TPessoaController.GetPessoaById);
  THorse.Post('/pessoas', TPessoaController.CreatePessoaComEndereco);
  THorse.Put('/pessoas/:id', TPessoaController.UpdatePessoa);
  THorse.Delete('/pessoas/:id', TPessoaController.DeletePessoa);

  // Rotas para Endereço
  THorse.Get('/enderecos', TEnderecoController.GetEnderecos);
  THorse.Get('/enderecos/:id', TEnderecoController.GetEnderecoById);
end;

end.

