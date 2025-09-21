program D4SignExemplo;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {Form1},
  api.d4sign.cofre in '..\api\api.d4sign.cofre.pas',
  api.d4sign.documento in '..\api\api.d4sign.documento.pas',
  api.d4sign.documento.signatario in '..\api\api.d4sign.documento.signatario.pas',
  api.d4sign in '..\api\api.d4sign.pas',
  api.d4sign.tipos in '..\api\api.d4sign.tipos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
