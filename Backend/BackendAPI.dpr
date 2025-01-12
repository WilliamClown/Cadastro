program BackendAPI;

uses
  Vcl.SvcMgr,
  Main in 'Main.pas' {MainService: TService},
  PessoaController in 'controller\PessoaController.pas',
  PessoaRepository in 'model\PessoaRepository.pas',
  PessoaService in 'service\PessoaService.pas',
  EnderecoRepository in 'model\EnderecoRepository.pas',
  EnderecoController in 'controller\EnderecoController.pas',
  PessoaRepositoryFactory in 'model\PessoaRepositoryFactory.pas',
  EnderecoRepositoryFactory in 'model\EnderecoRepositoryFactory.pas',
  Data in 'dao\Data.pas' {DataModule1: TDataModule},
  uIPessoaRepository in 'model\uIPessoaRepository.pas',
  uIEnderecoRepository in 'model\uIEnderecoRepository.pas',
  uFrmServidor in 'view\uFrmServidor.pas' {FrmServidor},
  IniUtils in 'util\IniUtils.pas',
  uServiceUtil in 'util\uServiceUtil.pas',
  uUtils in 'util\uUtils.pas',
  WinSvcEx in 'util\WinSvcEx.pas';

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
  if uServiceUtil.IsServiceProcess then
  begin
    if not Application.DelayInitialize or Application.Installing then
      Application.Initialize;

    Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TMainService, MainService);
  Application.Run;
  end
  else
  begin
    ReportMemoryLeaksOnShutdown := True;
    Application.CreateForm(TDataModule1, DataModule1);
    Application.CreateForm(TFrmServidor, FrmServidor);
    FrmServidor.ShowModal;
  end;

end.
