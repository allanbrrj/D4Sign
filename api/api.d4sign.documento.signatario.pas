unit api.d4sign.documento.signatario;

interface

uses api.d4sign.tipos;

type
  TSignatario = class
  private
    Fforeign              : Integer;
    Femail                : string;
    Fact                  : Integer;
    Fforeign_lang         : string;
    Fcertificadoicpbr     : Integer;
    Fassinatura_presencial: Integer;
    Fdocauth              : Integer;
    Fdocauthandselfie     : Integer;
    Fembed_methodauth     : string;
    Fafter_position       : Integer;
    Fupload_obs           : string;
    Fembed_smsnumber      : string;
    Fskipemail            : Integer;
    Fuuid_grupo           : string;
    Fwhatsapp_number      : string;
    Fupload_allow         : Integer;
    Fcertificadoicpbr_tipo: Integer;
    Fauth_pix_cpf         : string;
    Fauth_pix             : string;
    Fpassword_code        : string;
    Fcertificadoicpbr_cnpj: string;
    Fauth_pix_nome        : string;
    Fcertificadoicpbr_cpf : string;
    Fkey_signer           : string;
    Fsigned               : Integer;
    Fuser_name            : string;
    Fuser_document        : string;

    function read_act: TSignatario_act;
    procedure Setact(const Value: TSignatario_act);
    procedure Setemail(const Value: string);
    procedure Setforeign(const Value: TSignatario_foreign);
    function readforeign: TSignatario_foreign;
    function readforeign_lang: TSignatario_foreign_lang;
    procedure Setforeign_lang(const Value: TSignatario_foreign_lang);
    function readcertificadoicpbr: TSignatario_certificadoicpbr;
    procedure Setcertificadoicpbr(const Value: TSignatario_certificadoicpbr);
    function readassinatura_presencial: TSignatario_assinatura_presencial;
    procedure Setassinatura_presencial(const Value: TSignatario_assinatura_presencial);
    function readdocauth: TSignatario_docauth;
    procedure Setdocauth(const Value: TSignatario_docauth);
    function readdocauthandselfie: TSignatario_docauthandselfie;
    procedure Setdocauthandselfie(const Value: TSignatario_docauthandselfie);
    function readembed_methodauth: TSignatario_embed_methodauth;
    procedure Setembed_methodauth(const Value: TSignatario_embed_methodauth);
    function readcertificadoicpbr_tipo: TSignatario_certificadoicpbr_tipo;
    procedure Setafter_position(const Value: Integer);
    procedure Setcertificadoicpbr_tipo(const Value: TSignatario_certificadoicpbr_tipo);
    procedure Setembed_smsnumber(const Value: string);
    procedure Setskipemail(const Value: Integer);
    procedure Setupload_allow(const Value: Integer);
    procedure Setupload_obs(const Value: string);
    procedure Setuuid_grupo(const Value: string);
    procedure Setwhatsapp_number(const Value: string);
    procedure Setauth_pix(const Value: string);
    procedure Setauth_pix_cpf(const Value: string);
    procedure Setauth_pix_nome(const Value: string);
    procedure Setcertificadoicpbr_cnpj(const Value: string);
    procedure Setcertificadoicpbr_cpf(const Value: string);
    procedure Setpassword_code(const Value: string);
    procedure Setkey_signer(const Value: string);
    procedure Setsigned(const Value: Integer);
    procedure Setuser_document(const Value: string);
    procedure Setuser_name(const Value: string);

  public
    property email: string
      read   Femail
      write  Setemail;

    property key_signer: string //
      read   Fkey_signer
      write  Setkey_signer;

    property user_name: string //
      read   Fuser_name
      write  Setuser_name;

    property user_document: string //
      read   Fuser_document
      write  Setuser_document;

    property signed: Integer //
      read   Fsigned
      write  Setsigned;

    property act: TSignatario_act
      read   read_act
      write  Setact;

    property foreign: TSignatario_foreign
      read   readforeign
      write  Setforeign;

    property foreign_lang: TSignatario_foreign_lang
      read   readforeign_lang
      write  Setforeign_lang;

    property certificadoicpbr: TSignatario_certificadoicpbr
      read   readcertificadoicpbr
      write  Setcertificadoicpbr;

    property assinatura_presencial: TSignatario_assinatura_presencial
      read   readassinatura_presencial
      write  Setassinatura_presencial;

    property docauth: TSignatario_docauth
      read   readdocauth
      write  Setdocauth;

    property embed_methodauth: TSignatario_embed_methodauth
      read   readembed_methodauth
      write  Setembed_methodauth;

    property embed_smsnumber: string
      read   Fembed_smsnumber
      write  Setembed_smsnumber;

    property upload_allow: Integer
      read   Fupload_allow
      write  Setupload_allow;

    property upload_obs: string
      read   Fupload_obs
      write  Setupload_obs;

    property after_position: Integer //
      read   Fafter_position
      write  Setafter_position;

    property skipemail: Integer
      read   Fskipemail
      write  Setskipemail;

    property whatsapp_number: string
      read   Fwhatsapp_number
      write  Setwhatsapp_number;

    property uuid_grupo: string
      read   Fuuid_grupo
      write  Setuuid_grupo;

    property certificadoicpbr_tipo: TSignatario_certificadoicpbr_tipo
      read   readcertificadoicpbr_tipo
      write  Setcertificadoicpbr_tipo;

    property certificadoicpbr_cpf: string
      read   Fcertificadoicpbr_cpf
      write  Setcertificadoicpbr_cpf;

    property certificadoicpbr_cnpj: string
      read   Fcertificadoicpbr_cnpj
      write  Setcertificadoicpbr_cnpj;

    property password_code: string
      read   Fpassword_code
      write  Setpassword_code;

    property auth_pix: string
      read   Fauth_pix
      write  Setauth_pix;

    property auth_pix_nome: string
      read   Fauth_pix_nome
      write  Setauth_pix_nome;

    property auth_pix_cpf: string
      read   Fauth_pix_cpf
      write  Setauth_pix_cpf;
  end;

const
  vg_foreign_lang: array of string     = ['en', 'es', 'ptBR'];
  vg_embed_methodauth: array of string = ['email', 'password', 'sms', 'whats'];

implementation

uses
  System.StrUtils, System.SysUtils;

{ TSignatario }

function TSignatario.readforeign_lang: TSignatario_foreign_lang;
begin
  if Fforeign_lang.Trim.Length > 0 then
    Result := TSignatario_foreign_lang(AnsiIndexText(Fforeign_lang, vg_foreign_lang))
  else
    Result := sig_foreign_lang_pt_BR;
end;

function TSignatario.read_act: TSignatario_act;
begin
  Result := TSignatario_act(Fact);
end;

function TSignatario.readassinatura_presencial: TSignatario_assinatura_presencial;
begin
  Result := TSignatario_assinatura_presencial(Fassinatura_presencial);
end;

function TSignatario.readcertificadoicpbr: TSignatario_certificadoicpbr;
begin
  Result := TSignatario_certificadoicpbr(Fcertificadoicpbr);
end;

function TSignatario.readcertificadoicpbr_tipo: TSignatario_certificadoicpbr_tipo;
begin
  Result := TSignatario_certificadoicpbr_tipo(Fcertificadoicpbr_tipo);
end;

function TSignatario.readdocauth: TSignatario_docauth;
begin
  Result := TSignatario_docauth(Fdocauth);
end;

function TSignatario.readdocauthandselfie: TSignatario_docauthandselfie;
begin
  Result := TSignatario_docauthandselfie(Fdocauthandselfie);
end;

function TSignatario.readembed_methodauth: TSignatario_embed_methodauth;
begin
  if Fembed_methodauth.Trim.Length > 0 then
    Result := TSignatario_embed_methodauth(AnsiIndexText(Fembed_methodauth, vg_embed_methodauth))
  else
    Result := sig_embed_methodauth_email;
end;

function TSignatario.readforeign: TSignatario_foreign;
begin
  Result := TSignatario_foreign(Fforeign);
end;

procedure TSignatario.Setact(const Value: TSignatario_act);
begin
  Fact := Integer(Value);
end;

procedure TSignatario.Setafter_position(const Value: Integer);
begin
  Fafter_position := Value;
end;

procedure TSignatario.Setassinatura_presencial(const Value: TSignatario_assinatura_presencial);
begin
  Fassinatura_presencial := Integer(Value);
end;

procedure TSignatario.Setauth_pix(const Value: string);
begin
  Fauth_pix := Value;
end;

procedure TSignatario.Setauth_pix_cpf(const Value: string);
begin
  Fauth_pix_cpf := Value;
end;

procedure TSignatario.Setauth_pix_nome(const Value: string);
begin
  Fauth_pix_nome := Value;
end;

procedure TSignatario.Setcertificadoicpbr(const Value: TSignatario_certificadoicpbr);
begin
  Fcertificadoicpbr := Integer(Value);
end;

procedure TSignatario.Setcertificadoicpbr_cnpj(const Value: string);
begin
  Fcertificadoicpbr_cnpj := Value;
end;

procedure TSignatario.Setcertificadoicpbr_cpf(const Value: string);
begin
  Fcertificadoicpbr_cpf := Value;
end;

procedure TSignatario.Setcertificadoicpbr_tipo(const Value: TSignatario_certificadoicpbr_tipo);
begin
  Fcertificadoicpbr_tipo := Integer(Value);
end;

procedure TSignatario.Setdocauth(const Value: TSignatario_docauth);
begin
  Fdocauth := Integer(Value);
end;

procedure TSignatario.Setdocauthandselfie(const Value: TSignatario_docauthandselfie);
begin
  Fdocauthandselfie := Integer(Value);
end;

procedure TSignatario.Setemail(const Value: string);
begin
  Femail := Value;
end;

procedure TSignatario.Setembed_methodauth(const Value: TSignatario_embed_methodauth);
begin
  Fembed_methodauth := vg_embed_methodauth[Integer(Value)];
end;

procedure TSignatario.Setembed_smsnumber(const Value: string);
begin
  Fembed_smsnumber := Value;
end;

procedure TSignatario.Setforeign(const Value: TSignatario_foreign);
begin
  Fforeign := Integer(Value);
end;

procedure TSignatario.Setforeign_lang(const Value: TSignatario_foreign_lang);
begin
  Fforeign_lang := vg_foreign_lang[Integer(Value)];
end;

procedure TSignatario.Setkey_signer(const Value: string);
begin
  Fkey_signer := Value;
end;

procedure TSignatario.Setpassword_code(const Value: string);
begin
  Fpassword_code := Value;
end;

procedure TSignatario.Setsigned(const Value: Integer);
begin
  Fsigned := Value;
end;

procedure TSignatario.Setskipemail(const Value: Integer);
begin
  Fskipemail := Value;
end;

procedure TSignatario.Setupload_allow(const Value: Integer);
begin
  Fupload_allow := Value;
end;

procedure TSignatario.Setupload_obs(const Value: string);
begin
  Fupload_obs := Value;
end;

procedure TSignatario.Setuser_document(const Value: string);
begin
  Fuser_document := Value;
end;

procedure TSignatario.Setuser_name(const Value: string);
begin
  Fuser_name := Value;
end;

procedure TSignatario.Setuuid_grupo(const Value: string);
begin
  Fuuid_grupo := Value;
end;

procedure TSignatario.Setwhatsapp_number(const Value: string);
begin
  Fwhatsapp_number := Value;
end;

end.
