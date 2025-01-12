object DataModule1: TDataModule1
  Height = 480
  Width = 640
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=postgres'
      'Password=12345'
      'Server=192.168.2.7'
      'Database=postgres'
      'DriverID=PG')
    Left = 328
    Top = 264
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 464
    Top = 264
  end
end
