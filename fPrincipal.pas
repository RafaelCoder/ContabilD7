unit fPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, fViewPadraoCadastro;

type
  TovF_Principal = class(TForm)
    ovMM: TMainMenu;
    Cadastros1: TMenuItem;
    Contas1: TMenuItem;
    Lanamentos1: TMenuItem;
    LivroDirio1: TMenuItem;
    Relatrios1: TMenuItem;
    LivroRazao1: TMenuItem;
    BalancetedeVerificao1: TMenuItem;
    LivroDirio2: TMenuItem;
    DemonstrativodeResultadodoPerodo1: TMenuItem;
    Balanopatrimonial1: TMenuItem;
    procedure Contas1Click(Sender: TObject);
  private
    procedure CriarJanela(const FClass: TFormClass; var Instance);
  public
    { Public declarations }
  end;

var
  ovF_Principal: TovF_Principal;

implementation

{$R *.dfm}

procedure TovF_Principal.Contas1Click(Sender: TObject);
var
  tela: TovF_ViewPadraoCadastro;
begin
   CriarJanela(TovF_ViewPadraoCadastro, tela);
  {
  if ovF_ViewPadrao = nil then
    ovF_ViewPadrao := TovF_ViewPadrao.Create(Self);
  ovF_ViewPadrao.Show;}
end;

procedure TovF_Principal.CriarJanela(const FClass: TFormClass;
  var Instance);
var
  Cont: Integer;
begin
  Cont := 0;
  while Cont < MDIChildCount do
  begin
    if MDIChildren[Cont].ClassName = FClass.ClassName  then
    begin
      if MDIChildren[Cont].WindowState = wsMinimized then
        ShowWindow(MDIChildren[Cont].Handle, SW_RESTORE)
      else
        MDIChildren[Cont].BringToFront;
      Cont := MDIChildCount+1;
    end;
    if Cont<MDIChildCount then
      Inc(Cont);
  end;
  if Cont=MDIChildCount then
    Application.CreateForm(FClass, Instance);
end;

end.
