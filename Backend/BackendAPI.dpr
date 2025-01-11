program BackendAPI;

uses
  Vcl.SvcMgr,
  Main in 'Main.pas' {Service1: TService},
  PessoaController in 'controller\PessoaController.pas',
  PessoaModel in 'model\PessoaModel.pas',
  PessoaRepository in 'model\PessoaRepository.pas',
  PessoaService in 'service\PessoaService.pas',
  EnderecoRepository in 'model\EnderecoRepository.pas',
  EnderecoController in 'controller\EnderecoController.pas',
  PessoaRepositoryFactory in 'model\PessoaRepositoryFactory.pas',
  EnderecoRepositoryFactory in 'model\EnderecoRepositoryFactory.pas',
  Data in 'dao\Data.pas' {DataModule1: TDataModule},
  uIPessoaRepository in 'model\uIPessoaRepository.pas',
  uIEnderecoRepository in 'model\uIEnderecoRepository.pas',
  uFrmServidor in 'view\uFrmServidor.pas' {FrmServidor};

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  //Application.CreateForm(TService1, Service1);
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.Run;
end.
