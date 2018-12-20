program Contabil;

uses
  Forms,
  fPrincipal in 'fPrincipal.pas' {ovF_Principal},
  dmMySQL in 'dmMySQL.pas' {odm_MySQL: TDataModule},
  uGeral in 'uGeral.pas',
  fViewPadrao in 'view\fViewPadrao.pas' {ovF_ViewPadrao},
  fViewPadraoCadastro in 'view\fViewPadraoCadastro.pas' {ovF_ViewPadraoCadastro};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Contabil (Y)';
  Application.CreateForm(TovF_Principal, ovF_Principal);
  Application.CreateForm(Todm_MySQL, odm_MySQL);
  Application.Run;
end.
