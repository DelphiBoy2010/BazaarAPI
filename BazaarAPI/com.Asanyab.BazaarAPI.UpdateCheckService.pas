unit com.Asanyab.BazaarAPI.UpdateCheckService;

interface
{$IFDEF Android}
uses
  System.Android.Service, Androidapi.JNIBridge,
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net, Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers;
type
  TOnServiceConnect = procedure of object;
  TOnServiceDisconnect = procedure of object;

// ===== Forward declarations =====
  JIUpdateCheckService = interface;
  JIUpdateCheckService_Stub = interface;
// ===== Interface declarations =====

  JIUpdateCheckServiceClass = interface(JObjectClass)
    ['{DB53F9A8-CE06-4614-B5AC-5A3C1046884E}']
  end;

  [JavaSignature('com/farsitel/bazaar/IUpdateCheckService')]
  JIUpdateCheckService = interface(JObject)
    ['{C8CAC1AC-430A-421B-BC16-D0B9671DFCF6}']
    function getVersionCode(packageName : JString) : Int64; cdecl;            // (Ljava/lang/String;)J A: $401
  end;
  TJIUpdateCheckService = class(TJavaGenericImport<JIUpdateCheckServiceClass, JIUpdateCheckService>) end;



  JIUpdateCheckService_StubClass = interface(JObjectClass)
    ['{FD253979-0D64-4914-A2F2-97A9D1E04BF3}']
    function asBinder : JIBinder; cdecl;                                        // ()Landroid/os/IBinder; A: $1
    function asInterface(obj : JIBinder) : JIUpdateCheckService; cdecl;          // (Landroid/os/IBinder;)Lcom/farsitel/bazaar/ILoginCheckService; A: $9
    function init : JIUpdateCheckService_Stub; cdecl;                            // ()V A: $1
    function onTransact(code : Integer; data : JParcel; reply : JParcel; flags : Integer) : boolean; cdecl;// (ILandroid/os/Parcel;Landroid/os/Parcel;I)Z A: $1
  end;

  [JavaSignature('com/farsitel/bazaar/IUpdateCheckService$Stub')]
  JIUpdateCheckService_Stub = interface(JObject)
    ['{75D6BB12-B4BB-40FD-B3D1-47D226252A81}']
    function asBinder: JIBinder; cdecl;
    function onTransact(code: Integer; data: JParcel; reply: JParcel; flags: Integer): Boolean; cdecl;
  end;
  TJIUpdateCheckService_Stub = class(TJavaGenericImport<JIUpdateCheckService_StubClass, JIUpdateCheckService_Stub>)end;

  TUpdateCheckServiceConnection = class(TJavaLocal, JServiceConnection)
  private
    FServiceConn: JServiceConnection;
    FContext: JContext;
    FService: JIUpdateCheckService;
    FIsConnected: Boolean;
    FOnServiceConnect: TOnServiceConnect;
    FOnServiceDisconnect: TOnServiceDisconnect;

    FPackageName: string;

    procedure SetOnServiceConnect(const Value: TOnServiceConnect);
    procedure SetOnServiceDisconnect(const Value: TOnServiceDisconnect);
  public
    constructor Create(aPackageName: string);
    destructor Destroy; override;

    procedure onServiceConnected(name: JComponentName; service: JIBinder); cdecl;
    procedure onServiceDisconnected(name: JComponentName); cdecl;
    procedure StartSetup;
    procedure Dispose;
    function GetVersion: Integer;
    //Properties
    property IsConnected: Boolean read FIsConnected;
    //Events
    property OnServiceConnect: TOnServiceConnect read FOnServiceConnect write SetOnServiceConnect;
    property OnServiceDisconnect: TOnServiceDisconnect read FOnServiceDisconnect write SetOnServiceDisconnect;
  end;
{$ENDIF}
implementation

{$IFDEF Android}
uses
  System.SysUtils;

{ TUpdateCheckServiceConnection }
procedure RegisterTypes;
begin
  TRegTypes.RegisterType('com.farsitel.bazaar.ILoginCheckService.JIUpdateCheckService',
    TypeInfo(JIUpdateCheckService));
  TRegTypes.RegisterType('com.farsitel.bazaar.ILoginCheckService.JIUpdateCheckService_Stub',
    TypeInfo(JIUpdateCheckService_Stub));
end;

constructor TUpdateCheckServiceConnection.Create(aPackageName: string);
begin
  inherited Create;
  FContext := TAndroidHelper.Context.getApplicationContext;
  FService := nil;
  FIsConnected := False;
  FPackageName := aPackageName;
end;

destructor TUpdateCheckServiceConnection.Destroy;
begin
  Dispose;
  inherited;
end;

procedure TUpdateCheckServiceConnection.Dispose;
begin
  if FServiceConn <> nil then
  begin
    if FContext <> nil then
      FContext.unbindService(FServiceConn);
    FServiceConn := nil;
    FService := nil;
  end;
end;

function TUpdateCheckServiceConnection.GetVersion: Integer;
begin
  Result := -1000;
  if (FService <> nil) and (FIsConnected)  then
  begin
    Result := FService.getVersionCode(StringToJString(FPackageName));
  end;
end;

procedure TUpdateCheckServiceConnection.onServiceConnected(name: JComponentName;
  service: JIBinder);
begin
  FIsConnected := True;
  FService := TJIUpdateCheckService_Stub.JavaClass.asInterface(service);
  if Assigned(FOnServiceConnect) then
  begin
    FOnServiceConnect;
  end;
end;

procedure TUpdateCheckServiceConnection.onServiceDisconnected(
  name: JComponentName);
begin
  FService := nil;
  FIsConnected := False;
  if Assigned(OnServiceDisconnect) then
  begin
    OnServiceDisconnect;
  end;
end;

procedure TUpdateCheckServiceConnection.SetOnServiceConnect(
  const Value: TOnServiceConnect);
begin
  FOnServiceConnect := Value;
end;

procedure TUpdateCheckServiceConnection.SetOnServiceDisconnect(
  const Value: TOnServiceDisconnect);
begin
  FOnServiceDisconnect := Value;
end;

procedure TUpdateCheckServiceConnection.StartSetup;
var
  ServiceIntent: JIntent;
begin
  FServiceConn := TJServiceConnection.Wrap((Self as ILocalObject).GetObjectID);
  ServiceIntent := TJIntent.JavaClass.init(StringToJString('com.farsitel.bazaar.service.UpdateCheckService.BIND'));
  ServiceIntent.setPackage(StringToJString('com.farsitel.bazaar'));

  if not FContext.getPackageManager.queryIntentServices(serviceIntent, 0).isEmpty then
  begin
    // service available to handle that Intent
    FContext.bindService(serviceIntent, FServiceConn, TJContext.JavaClass.BIND_AUTO_CREATE);
  end;
end;

initialization
  RegisterTypes;
{$ENDIF}
end.
