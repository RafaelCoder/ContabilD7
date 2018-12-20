unit dmMySQL;

interface

uses
  SysUtils, Classes, ZAbstractConnection, ZConnection, Forms, DB, DBClient,
  Provider, uGeral, ZAbstractTable, ZDataset, ZAbstractRODataset,
  ZAbstractDataset;

type
  Todm_MySQL = class(TDataModule)
    ZConnection: TZConnection;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ZQuery: TZQuery;
    ZTable1: TZTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    
  public
    procedure pInicializa;
  end;

  function ExecSQL(strSQL: string; const oClientDS: TClientDataSet = nil; const vaParams: TSQLParam= nil;
                            const veParTypes: TSQLParType = nil): boolean;
  procedure DBBeginTrans;
  procedure DBCommit;
  procedure DBRollBack;
  function f_GetProxCodigo(vsTabela, vsCampo, vsCondicao:String):Integer;

var
  odm_MySQL: Todm_MySQL;
  vsSQL : String;

implementation

{$R *.dfm}

{ Todm_MySQL }

//******************************************************************************
procedure Todm_MySQL.pInicializa;
begin
  try
    if FileExists(ExtractFilePath(Application.ExeName)+'\libmysql50.dll') then
      ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName)+'\libmysql50.dll';
    ZConnection.Database := 'contabil';
    ZConnection.Password := 'root';
    ZConnection.HostName := '127.0.0.1';
    ZConnection.Connected := True;
  except
    on E : Exception do
    begin
      Raise Exception.Create('Falha ao tentar conexão com banco de dados.'+#13#10+
                             'Erro:'+E.Message);
    end;
  end;
end;

//******************************************************************************
procedure Todm_MySQL.DataModuleCreate(Sender: TObject);
begin
  try
    pInicializa;
  except
    on E : Exception do
    begin
      p_MsgAviso(E.Message);
      Application.Terminate;
    end;
  end;
end;

//******************************************************************************
function ExecSQL(strSQL: string; const oClientDS: TClientDataSet = nil; const vaParams: TSQLParam= nil;
                            const veParTypes: TSQLParType = nil): boolean;
var
  i : integer;
  vs_SQL,
  vsMsgErro : string; //** Comando SQL
  os_Params : TStringList;
begin
  Result := False;

  vs_SQL := Trim( strSQL );

  //** Verifica se o comando SQL possui parametros
  //   Parametros sao usados apenas para o caso de campos MEMO
  //   Cada parametro deve ser precedido pelo caracter '§' (mais um no final).
  os_Params := nil;
  if Length( vaParams ) > 0 then
  begin
    os_Params := TStringList.Create;
    for i := Low( vaParams ) to High( vaParams ) do
      os_Params.Add( vaParams[ i ] );
  end;

  try
    with odm_MySQL.ZQuery do
    begin
      odm_MySQL.ZQuery.Close;
      odm_MySQL.ZQuery.SQL.Clear;
      odm_MySQL.ZQuery.SQL.Add( vs_SQL );
      //SQL.Text := vs_SQL ;
      if Assigned( os_Params ) then
      begin
        for i := 0 to Params.Count - 1 do
        begin
          Params[ i ].DataType := ftMemo;
          Params[ i ].Value := os_Params[ i ];
        end;
        os_Params.Free;
      end;

      //** Verifica se o comando SQL eh um SELECT (ha retorno de dados)
      if ( ( Pos( 'SELECT' , Trim( UpperCase( vs_SQL ) ) ) = 1 ) or
        ( Pos( 'EXEC ' , Trim( UpperCase( vs_SQL ) ) ) = 1 ) ) and
        ( oClientDS <> nil ) then
      begin
        odm_MySQL.ZQuery.Open;

        //            if oClientDS <> nil then
        with oClientDS do
        begin
          oClientDS.Close;
          //** Limpa os campos estaticos declarados no ClientDS
          //   - Necessario para compatibilidade ACCESS e INTERBASE
          //     onde os Fields criados dinamicamente podem ser de
          //     tipos diferentes (Ex: TStringField -> TWideStringField)
          oClientDS.Fields.Clear;
          oClientDS.SetProvider( odm_MySQL.DataSetProvider1 );
          oClientDS.Open;
          oClientDS.ProviderName := '';
        end;
      end else
        //** Executa SQL quando nao ha retorno de dados
        ExecSQL;
    end;
    Result := True;

  except
    on E : Exception do
    begin
      vsMsgErro := '';
      if ((Pos(UpperCase('CONNECT'),UpperCase(E.Message)) > 0) OR (Pos(UpperCase('FALHA'),UpperCase(E.Message)) > 0)) then
        vsMsgErro := 'Não foi possível conectar ao servidor(Falha de conexão)!';
      if ((Pos(UpperCase('SHUTDOWN'),UpperCase(E.Message)) > 0) OR (Pos(UpperCase('DESLIGA'),UpperCase(E.Message)) > 0)) then
        vsMsgErro := 'O servidor MySQL está sendo desligado(SERVER IN SHUTDOWN)!';
      if ((Pos(UpperCase('LOST'),UpperCase(E.Message)) > 0) OR (Pos(UpperCase('PERDIDA'),UpperCase(E.Message)) > 0)) then
        vsMsgErro := 'Comunicação perdida com o servidor(LOST CONNECTION)!';

      if Trim(vsMsgErro) <> '' then
      begin
        p_MsgErro('Erro de comunicação com o servidor! A mensagem de erro foi:' + #13#10 +
                   vsMsgErro  + #13#10 +
                   'O sistema será finalizado!');
        Abort;
      end else
      begin
        E.Message := 'MySQL' + ' (ExecSQL): ' + E.Message + #13#10 + vs_SQL;
      end;
      Raise;
    end;
  end;
end;

//******************************************************************************
procedure DBBeginTrans;
begin
  if not odm_MySQL.ZConnection.InTransaction then
    odm_MySQL.ZConnection.StartTransaction;
end;

//******************************************************************************
procedure DBCommit;
begin
  if odm_MySQL.ZConnection.InTransaction then
    odm_MySQL.ZConnection.Commit;
end;

//******************************************************************************
procedure DBRollBack;
begin
  if not odm_MySQL.ZConnection.InTransaction then
    odm_MySQL.ZConnection.Rollback;
end;

//******************************************************************************
function f_GetProxCodigo(vsTabela, vsCampo, vsCondicao:String):Integer;
var
  oCDS : TClientDataSet;
begin
  Result := 0;
  oCDS := TClientDataSet.Create(nil);
  try
    if Trim(vsCampo) = '' then
      exit;
    if Trim(vsTabela) = '' then
      exit;
    vsSQL := 'SELECT MAX('+vsCampo+') AS RES FROM '+vsTabela + ' WHERE 1=1';
    if Trim(vsCondicao) <> '' then
      vsSQL := vsSQL + vsCondicao;
    ExecSQL(vsSQL, oCDS);
    Result := oCDS.FieldByName('RES').AsInteger + 1;
  finally
    FreeAndNil(oCDS);
  end;
end;

//******************************************************************************
end.
