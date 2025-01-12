object MainService: TMainService
  OnCreate = ServiceCreate
  DisplayName = 'Service1'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 480
  Width = 640
end
