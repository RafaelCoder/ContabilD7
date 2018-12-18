program Contabil;

uses
  Forms,
  fPrincipal in 'fPrincipal.pas' {ovF_Principal},
  odmMySQL in 'odmMySQL.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TovF_Principal, ovF_Principal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
