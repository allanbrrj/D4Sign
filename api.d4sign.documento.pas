unit api.d4sign.documento;

interface

uses
  REST.Json.Types;

type
  TDocumento = class
  private
    FstatusId: string;
    FuuidDoc: string;
    FuuidSafe: string;
    [JSONNameAttribute('type')]
    Ftype_file: string;
    FwhoCanceled: string;
    FstatusName: string;
    Fpages: Integer;
    Fsize: Integer;
    FstatusComment: string;
    FnameDoc: string;
    FsafeName: string;
    procedure SetnameDoc(const Value: string);
    procedure Setpages(const Value: Integer);
    procedure SetsafeName(const Value: string);
    procedure Setsize(const Value: Integer);
    procedure SetstatusComment(const Value: string);
    procedure SetstatusId(const Value: string);
    procedure SetstatusName(const Value: string);
    procedure Settype_file(const Value: string);
    procedure SetuuidDoc(const Value: string);
    procedure SetuuidSafe(const Value: string);
    procedure SetwhoCanceled(const Value: string);
  public
    property uuidDoc: string read FuuidDoc write SetuuidDoc;
    property nameDoc: string read FnameDoc write SetnameDoc;
    property type_file: string read Ftype_file write Settype_file;
    property size: Integer read Fsize write Setsize;
    property pages: Integer read Fpages write Setpages;
    property uuidSafe: string read FuuidSafe write SetuuidSafe;
    property safeName: string read FsafeName write SetsafeName;
    property statusId: string read FstatusId write SetstatusId;
    property statusName: string read FstatusName write SetstatusName;
    property statusComment: string read FstatusComment write SetstatusComment;
    property whoCanceled: string read FwhoCanceled write SetwhoCanceled;
  end;


implementation

{ TDocumento }

procedure TDocumento.SetnameDoc(const Value: string);
begin
  FnameDoc := Value;
end;

procedure TDocumento.Setpages(const Value: Integer);
begin
  Fpages := Value;
end;

procedure TDocumento.SetsafeName(const Value: string);
begin
  FsafeName := Value;
end;

procedure TDocumento.Setsize(const Value: Integer);
begin
  Fsize := Value;
end;

procedure TDocumento.SetstatusComment(const Value: string);
begin
  FstatusComment := Value;
end;

procedure TDocumento.SetstatusId(const Value: string);
begin
  FstatusId := Value;
end;

procedure TDocumento.SetstatusName(const Value: string);
begin
  FstatusName := Value;
end;

procedure TDocumento.Settype_file(const Value: string);
begin
  Ftype_file := Value;
end;

procedure TDocumento.SetuuidDoc(const Value: string);
begin
  FuuidDoc := Value;
end;

procedure TDocumento.SetuuidSafe(const Value: string);
begin
  FuuidSafe := Value;
end;

procedure TDocumento.SetwhoCanceled(const Value: string);
begin
  FwhoCanceled := Value;
end;

end.
