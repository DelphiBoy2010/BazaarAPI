unit com.Asanyab.BazaarAPI.LoginCheckServiceConnection;

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
  JILoginCheckService = interface;
  JILoginCheckService_Stub = interface;
// ===== Interface declarations =====

  JILoginCheckServiceClass = interface(JObjectClass)
    ['{1B47FC90-0F21-4085-9A9F-745AA4DB3F47}']
  end;

  [JavaSignature('com/farsitel/bazaar/ILoginCheckService')]
  JILoginCheckService = interface(JObject)
    ['{40C9ED67-6731-4305-A29A-B70A00A59A1B}']
    function isLoggedIn : boolean; cdecl;
  end;
  TJILoginCheckService = class(TJavaGenericImport<JILoginCheckServiceClass, JILoginCheckService>) end;



  JILoginCheckService_StubClass = interface(JObjectClass)
    ['{BA3C5453-D7C3-4EAC-A7C7-2328706301EE}']
    function asBinder : JIBinder; cdecl;                                        // ()Landroid/os/IBinder; A: $1
    function asInterface(obj : JIBinder) : JILoginCheckService; cdecl;          // (Landroid/os/IBinder;)Lcom/farsitel/bazaar/ILoginCheckService; A: $9
    function init : JILoginCheckService_Stub; cdecl;                            // ()V A: $1
    function onTransact(code : Integer; data : JParcel; reply : JParcel; flags : Integer) : boolean; cdecl;// (ILandroid/os/Parcel;Landroid/os/Parcel;I)Z A: $1
  end;

  [JavaSignature('com/farsitel/bazaar/ILoginCheckService$Stub')]
  JILoginCheckService_Stub = interface(JObject)
    ['{A1034FFB-5A84-4E76-BF8D-3547AC92E0B4}']
    function asBinder: JIBinder; cdecl;
    function onTransact(code: Integer; data: JParcel; reply: JParcel; flags: Integer): Boolean; cdecl;
  end;
  TJILoginCheckService_Stub = class(TJavaGenericImport<JILoginCheckService_StubClass, JILoginCheckService_Stub>)end;

  TLoginCheckServiceConnection = class(TJavaLocal, JServiceConnection)
  private
    FServiceConn: JServiceConnection;
    FContext: JContext;
    FService: JILoginCheckService;
    FIsConnected: Boolean;
    FOnServiceConnect: TOnServiceConnect;
    FOnServiceDisconnect: TOnServiceDisconnect;

    procedure SetOnServiceConnect(const Value: TOnServiceConnect);
    procedure SetOnServiceDisconnect(const Value: TOnServiceDisconnect);
  public
    constructor Create;
    destructor Destroy; override;

    procedure onServiceConnected(name: JComponentName; service: JIBinder); cdecl;
    procedure onServiceDisconnected(name: JComponentName); cdecl;
    procedure StartSetup;
    procedure Dispose;
    function IsLogin: Boolean;
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

{ TLoginCheckServiceConnection }
procedure RegisterTypes;
begin
  TRegTypes.RegisterType('com.farsitel.bazaar.ILoginCheckService.JILoginCheckService',
    TypeInfo(JILoginCheckService));
  TRegTypes.RegisterType('com.farsitel.bazaar.ILoginCheckService.JILoginCheckService_Stub',
    TypeInfo(JILoginCheckService_Stub));
end;

constructor TLoginCheckServiceConnection.Create;
begin
  inherited Create;
  FContext := TAndroidHelper.Context.getApplicationContext;
  FService := nil;
  FIsConnected := False;
end;

destructor TLoginCheckServiceConnection.Destroy;
begin
  Dispose;
  inherited;
end;

procedure TLoginCheckServiceConnection.Dispose;
begin
  if FServiceConn <> nil then
  begin
    if FContext <> nil then
      FContext.unbindService(FServiceConn);
    FServiceConn := nil;
    FService := nil;
  end;
end;

function TLoginCheckServiceConnection.IsLogin: Boolean;
begin
  Result := False;
  if (FService <> nil) and (FIsConnected)  then
  begin
    Result := FService.isLoggedIn;
  end;
end;

procedure TLoginCheckServiceConnection.onServiceConnected(name: JComponentName;
  service: JIBinder);
begin
  FIsConnected := True;
  FService := TJILoginCheckService_Stub.JavaClass.asInterface(service);
  if Assigned(FOnServiceConnect) then
  begin
    FOnServiceConnect;
  end;
end;

procedure TLoginCheckServiceConnection.onServiceDisconnected(
  name: JComponentName);
begin
  FService := nil;
  FIsConnected := False;
  if Assigned(OnServiceDisconnect) then
  begin
    OnServiceDisconnect;
  end;
end;

procedure TLoginCheckServiceConnection.SetOnServiceConnect(
  const Value: TOnServiceConnect);
begin
  FOnServiceConnect := Value;
end;

procedure TLoginCheckServiceConnection.SetOnServiceDisconnect(
  const Value: TOnServiceDisconnect);
begin
  FOnServiceDisconnect := Value;
end;

procedure TLoginCheckServiceConnection.StartSetup;
var
  ServiceIntent: JIntent;
begin
  FServiceConn := TJServiceConnection.Wrap((Self as ILocalObject).GetObjectID);
  ServiceIntent := TJIntent.JavaClass.init(StringToJString('com.farsitel.bazaar.service.LoginCheckService.BIND'));
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

