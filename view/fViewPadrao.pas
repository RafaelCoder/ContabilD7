unit fViewPadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TovF_ViewPadrao = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VisibleChanging; override;
  private
    { Private declarations }
  protected

  public
    { Public declarations }
  end;

var
  ovF_ViewPadrao: TovF_ViewPadrao;

implementation

{$R *.dfm}

procedure TovF_ViewPadrao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
  Release;
  ovF_ViewPadrao := nil;
end;

procedure TovF_ViewPadrao.VisibleChanging;
begin
  if Visible then
    FormStyle := fsNormal
  else
    FormStyle := fsMDIChild;
end;

end.
