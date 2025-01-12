program Frontend;

uses
  Vcl.Forms,
  View.Menu in 'view\View.Menu.pas' {FormMenu},
  View.Pessoa in 'view\View.Pessoa.pas' {FormPessoa},
  PessoaDTO in 'dto\PessoaDTO.pas',
  EnderecoDTO in 'dto\EnderecoDTO.pas',
  PessoaService in 'service\PessoaService.pas',
  EnderecoService in 'service\EnderecoService.pas',
  PessoaController in 'controller\PessoaController.pas',
  ConfigSingleton in 'util\ConfigSingleton.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMenu, FormMenu);
  Application.Run;
end.
