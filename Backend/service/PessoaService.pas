unit PessoaService;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Param,
  System.JSON,
  REST.Json,
  Horse,
  Horse.CORS,
  Horse.JWT,
  Horse.Jhonson,
  Horse.Compression,
  Data;

procedure RegisterRoutes;

implementation

uses
  PessoaController, EnderecoController;

//const
  //SECRET_KEY = 'Ii7NSJL4AxKvP0BBu3tbv8OcQt99d6';

procedure RegisterRoutes;
begin
  //THorse.Use(HorseJWT(SECRET_KEY));  // Middleware para autenticação JWT
  THorse.Use(compression());
  THorse.Use(jhonson);
  THorse.Use(CORS);

  // Rotas para Pessoa
  THorse.Get('/pessoas', TPessoaController.GetPessoas);
  THorse.Get('/pessoas/:id', TPessoaController.GetPessoaById);
  THorse.Post('/pessoas', TPessoaController.CreatePessoaComEndereco);
  THorse.Put('/pessoas/:id', TPessoaController.UpdatePessoa);
  THorse.Delete('/pessoas/:id', TPessoaController.DeletePessoa);
  THorse.Post('/pessoas/lote', TPessoaController.CreateLotePessoas);

  // Rotas para Endereço
  THorse.Get('/enderecos', TEnderecoController.GetEnderecos);
  THorse.Get('/enderecos/:id', TEnderecoController.GetEnderecoById);
  THorse.Put('/enderecos/:id', TEnderecoController.UpdateEndereco);
end;

end.

