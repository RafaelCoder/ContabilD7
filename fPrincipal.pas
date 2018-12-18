unit fPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ovF_Principal: TovF_Principal;

implementation

{$R *.dfm}

end.
