program CafeBazaarAPI;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {Form3},
  com.Asanyab.BazaarAPI.LoginCheckServiceConnection in 'BazaarAPI\com.Asanyab.BazaarAPI.LoginCheckServiceConnection.pas',
  com.Asanyab.BazaarAPI in 'BazaarAPI\com.Asanyab.BazaarAPI.pas',
  com.Asanyab.BazaarAPI.UpdateCheckService in 'BazaarAPI\com.Asanyab.BazaarAPI.UpdateCheckService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
