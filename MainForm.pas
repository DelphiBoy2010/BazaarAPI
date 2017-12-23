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
    btnCheckUpdate: TButton;
    Layout8: TLayout;
    btnVote: TButton;
    procedure btnVoteClick(Sender: TObject);
    procedure btnCheckUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOtherAppsClick(Sender: TObject);
    procedure btnAboutUsClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateComfirmResult(const AResult: TModalResult);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses com.Asanyab.BazaarAPI, FMX.DialogService, Android.Tools;

procedure TForm3.btnAboutUsClick(Sender: TObject);
begin
  AndroidTools.OpenURL('http://asanyab.org/');
end;

procedure TForm3.btnCheckUpdateClick(Sender: TObject);
const
  Mess_UpdateComfirm= 'آیا می خواهید برنامه را به روزرسانی نمایید؟';
var
  CurrentVersion: Integer;
  NewVersion: Integer;
begin
  {$IFDEF Android}
  CurrentVersion := AndroidTools.GetPackageVersionCode;
  NewVersion := BazaarAPI.GetAppVersion;
  {$ENDIF}
  if NewVersion > CurrentVersion then
  begin
    TDialogService.MessageDialog(Mess_UpdateComfirm, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbYes, 0, UpdateComfirmResult);
  end
  else
  begin
    ShowMessage('نسخه جدیدی وجود ندارد');
  end;

end;

procedure TForm3.btnOtherAppsClick(Sender: TObject);
begin
  BazaarAPI.GoDeveloperPage;
end;

procedure TForm3.btnVoteClick(Sender: TObject);
begin
  BazaarAPI.VoteApp;
end;

procedure TForm3.FormCreate(Sender: TObject);
const
  MainPackageName = 'com.asanyab.MQL_Capital';//Your package name
  DeveloperID = '1762474857';//Your developer id in cafebazaar
  //http://developers.cafebazaar.ir/fa/docs/
begin
  BazaarAPI := TBazaarAPI.Create(MainPackageName, DeveloperID);
  BazaarAPI.InitUserIsLogin;
  BazaarAPI.InitCheckUpdate;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FreeAndNil(BazaarAPI);
end;

procedure TForm3.UpdateComfirmResult(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    BazaarAPI.VoteApp;
  end;
end;

end.
