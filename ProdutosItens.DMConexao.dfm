object DMConexao: TDMConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 347
  Width = 531
  object fdConexao: TFDConnection
    Params.Strings = (
      'Database=produtositens'
      'Password=root'
      'Server=localhost'
      'User_Name=root'
      'DriverID=MySQL')
    ConnectedStoredUsage = []
    LoginPrompt = False
    BeforeConnect = fdConexaoBeforeConnect
    Left = 88
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 176
    Top = 32
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 304
    Top = 40
  end
end
