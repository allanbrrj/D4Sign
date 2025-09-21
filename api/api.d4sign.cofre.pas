unit api.d4sign.cofre;

interface

uses
  REST.Json.Types;

type
  TCofre = class
  private
   [JSONNameAttribute('name-safe')]
    Fname_safe: string;
    Fuuid_safe: string;
    procedure Setname_safe(const Value: string);
    procedure Setuuid_safe(const Value: string);
  public
    property uuid_safe: string read Fuuid_safe write Setuuid_safe;
    property name_safe: string read Fname_safe write Setname_safe;
  end;

implementation

{ TCofre }

procedure TCofre.Setname_safe(const Value: string);
begin
  Fname_safe := Value;
end;

procedure TCofre.Setuuid_safe(const Value: string);
begin
  Fuuid_safe := Value;
end;

end.