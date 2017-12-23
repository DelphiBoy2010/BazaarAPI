unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation;

type
  TForm3 = class(TForm)
    DetailPanel: TPanel;
    Layout3: TLayout;
    btnAboutUs: TButton;
    Layout5: TLayout;
    btnOtherApps: TButton;
    Layout7: TLayout;
    btnHelp: TButton;
    Layout8: TLayout;
    btnVote: TButton;
    procedure btnVoteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.btnVoteClick(Sender: TObject);
begin
  //BazaarAPI.VoteApp;   1
end;

end.
