unit uGeral;

interface

uses Classes, Controls, Dialogs, Windows, Forms, SysUtils, DB, DBClient, MaskUtils, ExtCtrls,
  CurrEdit;

type
  TSQLParam   = array of String;
  TSQLParType = array of String;


  function  f_MsgConfirma( Msg: string ): Boolean;
  procedure p_MsgAviso(Msg: string);
  procedure p_MsgErro(Msg: string);
  function  f_StrToSQL(Str: string): string;
  function  f_IntToSQL( Valor: double ): String;
  function  f_BoolToSQL(Vlr: Boolean): String;
  function f_DateToSQL(Data: TDateTime): String;
  function  VirgulaPorPonto(Vlr: string): string;
  function  f_RoundTwoDec(Value: Double; const vbArred : Boolean = False): Double;
  function  tbKeyIsDown(const Key: integer): boolean;
  procedure pGravaTXT(content, name: String);
  function fExtraisNumeros(s: string): String;
  function fTrataTelefone(str: String): String;
  function fTrataTexto(str: String):String;
  function fGeraSigla(str: String):String;
  function fGetContentFile(caminho:String):String;
  function fGetValues(ovp:TPanel):TStringList;


implementation

function  f_MsgConfirma( Msg: string ): Boolean;
var
  tex: ^PChar;
begin
  tex := @msg;
  Result := ( MessageBox(Application.Handle, tex^,'Pergunta', mb_yesno + mb_iconquestion + MB_TOPMOST ) = 6 );
end;

//******************************************************************************
procedure p_MsgAviso(Msg: string);
var
  tex: ^PChar;
begin
  tex := @msg;
  Screen.Cursor := crDefault;
  MessageBox(Application.Handle, tex^,'Aviso', mb_ok + mb_iconwarning + MB_TOPMOST );
end;

//******************************************************************************
procedure p_MsgErro(Msg: string);
var
  tex: ^PChar;
begin
  tex := @msg;
  Screen.Cursor := crDefault;
  MessageBox(Application.Handle, tex^,'Erro', mb_ok + mb_iconerror + MB_TOPMOST );
end;

//******************************************************************************
function f_StrToSQL( Str: String ): String;
begin
  if Str <> '' then
     Result := #39 + Str + #39
  else
     Result := 'NULL';
end;

//******************************************************************************
function tbKeyIsDown(const Key: integer): boolean;
begin
  Result := GetKeyState(Key) and 128 > 0;
end;

//******************************************************************************
function f_IntToSQL( Valor: double ): String;
begin
  if valor <> 0 then
     Result := FormatFloat('0', valor)
  else
     Result := 'NULL';
end;

//******************************************************************************
function  f_BoolToSQL(Vlr: Boolean): String;
begin
   if Vlr then
      Result := #39'S'#39
   else
      Result := #39'N'#39

end;

//******************************************************************************
function f_DateToSQL(Data: TDateTime): String;
begin
   Result := 'NULL';
   if Data <> 0 then
   begin
     Result := #39 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Data) + #39
   end;
end;
//******************************************************************************

function VirgulaPorPonto(Vlr: string): string;
var
  i : integer;
  str: string;
begin
  str := vlr;

  if ( str = '' ) then
    Result := '0'
  else
  begin
    if Pos(',', str) > 0 then begin
      for i := 1 to 2 do
        if Pos('.', str) > 0 then
          Delete( str, Pos('.', str), 1 );

      if Pos(',', str) > 0 then
         str[Pos(',', str)] := '.';

      Result := str;
    end else
      Result := str;
  end;
end;

//******************************************************************************
function f_RoundTwoDec( Value: Double; const vbArred : Boolean ): Double;
//  Result := StrToFloat( FormatFloat( '0.00', Value ));
var
  Resultado : Double;
begin
  try
    if (vbArred) then
    begin
      Resultado := StrToFloat( FormatFloat( '0.00000' , Value ));
      Resultado := StrToFloat( FormatFloat( '0.0000' , Resultado ));
      Resultado := StrToFloat( FormatFloat( '0.000' , Resultado ));
      if StrToFloat(Copy(FloatToStr(Resultado), Length(FloatToStr(Resultado)), Length(FloatToStr(Resultado)))) >= 5 then
      begin
        Resultado := StrToFloat( FormatFloat( '0.00' , Resultado + 0.001 ));
      end else
        Resultado := StrToFloat( FormatFloat( '0.00' , Resultado ));
    end else
    begin
      Resultado := StrToFloat( FormatFloat( '0.00' , Value * 100 ));
      Resultado := Trunc( Resultado ) / 100;
    end;

  except
    Resultado := StrToFloat( FormatFloat( '0.00000' , Value ));
    Resultado := StrToFloat( FormatFloat( '0.0000' , Resultado ));
    Resultado := StrToFloat( FormatFloat( '0.000' , Resultado ));
    if StrToFloat(Copy(FloatToStr(Resultado), Length(FloatToStr(Resultado)), Length(FloatToStr(Resultado)))) >= 5 then
    begin
      Resultado := StrToFloat( FormatFloat( '0.00' , Resultado + 0.001 ));
    end else
      Resultado := StrToFloat( FormatFloat( '0.00' , Resultado ));
  end;


  Result := Resultado;
end;

//******************************************************************************
procedure pGravaTXT(content, name: String);
var arq: TextFile;
begin
  AssignFile(arq, name);
  Rewrite(arq);
  Write(arq, content);
  CloseFile(arq);
end;

//******************************************************************************
function fExtraisNumeros(s: string): String;
var
  i : Integer;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    if (i<=length(s)) and (s[i] in ['0'..'9']) then
      Result := Result +s[i];
  end;
end;

//******************************************************************************
function fTrataTelefone(str: String): String;
begin
  str  := fExtraisNumeros(str);
  str  := Trim(Copy(str,length(str)-7,length(str)));
  Result := '';
  if length(str) = 8 then
    Result := FormatMaskText('00000000;0;_',str);
end;

//******************************************************************************
function fTrataTexto(str: String):String;
begin
  Result := str;
  Result := StringReplace(Result, #39, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

//******************************************************************************
function fGeraSigla(str: String):String;
var
  i : Integer;
  vbFW : Boolean;
begin
  str := trim(str);
  Result := '';
  vbFW := true;
  for i := 0 to length(str) do
  begin
    if vbFW then
      Result := Result + Trim(str[i]);
    vbFW := str[i] = ' ';
  end;
end;

//******************************************************************************
function fGetContentFile(caminho:String):String;
var arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  linha: string;
begin
  Result := '';
  AssignFile(arq, caminho);
  {$I-}
  Reset(arq);
  {$I+}
  if (IOResult = 0) then
  begin
    try
      while (not eof(arq)) do
      begin
        readln(arq, linha);
        Result := Result + linha +#13#10;
      end;
    finally
      CloseFile(arq);
    end;
  end;

  Result := StringReplace(Result, #39+'ï»¿', '', [rfReplaceAll]);
  Result := StringReplace(Result, #39+'#$D#$A'+#39, '', [rfReplaceAll]);
  Result := StringReplace(Result, '#$D#$A', '', [rfReplaceAll]);
  Result := StringReplace(Result, #39#$D#$A#39, '', [rfReplaceAll]);
end;

//******************************************************************************
function fGetValues(ovp:TPanel):TStringList;
var
  viQtde, i : Integer;
  c : TComponent;
  res : TStringList;
  vsKey, vsValue : String;
begin
  res := TStringList.Create;
  viQtde := ovp.ComponentCount;
  for i := 0 to viQtde -1 do
  begin
    c := ovp.Components[i];
    if c.ClassType = TRxCalcEdit then
    begin
      vsKey   := TRxCalcEdit(c).Name;
      vsValue := TRxCalcEdit(c).Text;
    end;
    res.Values[vsKey] := vsValue;
  end;

  Result := res;
end;

//******************************************************************************
end.
