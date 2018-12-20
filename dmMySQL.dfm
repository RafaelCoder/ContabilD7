object odm_MySQL: Todm_MySQL
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 265
  Top = 173
  Height = 274
  Width = 424
  object ZConnection: TZConnection
    ControlsCodePage = cGET_ACP
    UTF8StringsAsWideField = False
    AutoEncodeStrings = False
    HostName = 'localhost'
    Port = 0
    Database = 'test'
    User = 'root'
    Password = 'root'
    Protocol = 'mysql-5'
    LibraryLocation = 'C:\Projetos\Padrao\Exec\libmysql50.dll'
    Left = 64
    Top = 32
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ZQuery
    Left = 56
    Top = 88
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 168
  end
  object DataSource1: TDataSource
    Left = 64
    Top = 176
  end
  object ZQuery: TZQuery
    Connection = ZConnection
    Params = <>
    Left = 128
    Top = 24
  end
  object ZTable1: TZTable
    Connection = ZConnection
    Left = 136
    Top = 88
  end
end
