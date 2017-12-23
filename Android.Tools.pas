unit Android.Tools;

interface
{$IFDEF Android}
uses
  Androidapi.JNI.Widget, Androidapi.Helpers, FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText;

type
  TToastDuration = (tdShort, tdLong);

  TAndroidTools = class(TObject)
  private
  public
    constructor Create;
    destructor Destroy; override;

    procedure ShowToast(aMessage: string; aDuration: TToastDuration);
    function GetPackageVersion: string;
    function GetPackageVersionCode: Integer;
    procedure OpenURL(aURL: string);
  end;

var
  AndroidTools: TAndroidTools = nil;
{$ENDIF}
implementation

{$IFDEF Android}
uses
  Androidapi.JNI.Net, System.SysUtils;

{ TAndroidTools }

constructor TAndroidTools.Create;
begin

end;

destructor TAndroidTools.Destroy;
begin

  inherited;
end;

function TAndroidTools.GetPackageVersion: string;
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
begin
  //Check next line late
  //Result := TOSVersion.ToString;

  PackageManager := SharedActivity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result := JStringToString(PackageInfo.versionName);
end;

function TAndroidTools.GetPackageVersionCode: Integer;
var
  PackageManager: JPackageManager;
  PackageInfo : JPackageInfo;
begin
  PackageManager := SharedActivity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName(), TJPackageManager.JavaClass.GET_ACTIVITIES);
  Result := PackageInfo.versionCode;

end;

procedure TAndroidTools.OpenURL(aURL: string);
const
  MethodName = 'OpenURL';
var
  Intent: JIntent;
  Command: string;
begin
  try
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
      TJnet_Uri.JavaClass.parse(StringToJString(aURL)));
    SharedActivity.startActivity(Intent);
  except
    on E: Exception do
    begin
      {$IFDEF UseLogger}
      Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
      {$ENDIF}
      raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TAndroidTools.ShowToast(aMessage: string; aDuration: TToastDuration);
var
  ToastLength: Integer;
begin
  if aDuration = tdShort then
    ToastLength := TJToast.JavaClass.LENGTH_SHORT
  else
    ToastLength := TJToast.JavaClass.LENGTH_LONG;
  CallInUiThread(
    procedure
    begin
      TJToast.JavaClass.makeText(SharedActivityContext, StrToJCharSequence(aMessage),
        ToastLength).show
    end);

end;
{$ENDIF}
end.
