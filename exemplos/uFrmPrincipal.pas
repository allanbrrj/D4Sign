unit uFrmPrincipal;

interface

uses
  //Inicio - units da API D4sign
  api.d4sign, api.d4sign.tipos,
  //Fim - units da API D4sign

  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    lblCofre: TLabel;
    cbxCofre: TComboBox;
    btnCarregarCofre: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    edtCryptKeyd4sign: TEdit;
    edtTokend4sign: TEdit;
    Label2: TLabel;
    GroupBox9: TGroupBox;
    lblTesteFase: TLabel;
    btnCarregarDocumentos: TButton;
    btnAdicionarDocumentoBin: TButton;
    btnCancelarDocumento: TButton;
    btnAdicionarSignatario: TButton;
    btnAdicionarAnexo: TButton;
    btnExibirSignatarios: TButton;
    btnExibirDocumentos: TButton;
    btnCarregarSignatario: TButton;
    cbxFiltroFaseTeste: TComboBox;
    btDisponibilizarDocumento: TButton;
    btnCarregarCofres: TButton;
    btnLimparTeste: TButton;
    btnAdicionarDocumentoForm: TButton;
    ckSalvarLogEndpoint: TCheckBox;
    Label5: TLabel;
    edtPathTempExport: TEdit;
    btnAbrirDirTmp: TButton;
    Label6: TLabel;
    memoInformacoes: TMemo;
    prgsBar: TProgressBar;
    procedure edtTokend4signChange(Sender: TObject);
    procedure edtCryptKeyd4signChange(Sender: TObject);
    procedure btnCarregarDocumentosClick(Sender: TObject);
    procedure btnAbrirDirTmpClick(Sender: TObject);
    procedure btnCarregarCofreClick(Sender: TObject);
    procedure btnCarregarSignatarioClick(Sender: TObject);
    procedure btnCarregarCofresClick(Sender: TObject);
    procedure btnAdicionarDocumentoBinClick(Sender: TObject);
    procedure btnAdicionarDocumentoFormClick(Sender: TObject);
    procedure btnCancelarDocumentoClick(Sender: TObject);
    procedure btDisponibilizarDocumentoClick(Sender: TObject);
    procedure btnAdicionarAnexoClick(Sender: TObject);
    procedure btnAdicionarSignatarioClick(Sender: TObject);
    procedure btnExibirDocumentosClick(Sender: TObject);
    procedure btnExibirSignatariosClick(Sender: TObject);
    procedure btnLimparTesteClick(Sender: TObject);
  private
    { Private declarations }
    FTokend: string;
    FCryptKey: string;
    FvgAPI: Id4signAPI;

    procedure InformarChavesAcessod4sign;
    procedure ShowFolder(strFolder: string);
    procedure CarregarCofred4sign;
    procedure InformarStatus(pTXT: string; pLimpaMSG: Boolean = False);
    function SelecionarArquivosUPLOAD: string;
  public
    { Public declarations }
    property Token: string
       read FTokend
      write FTokend;

    property CryptKey: string
       read FCryptKey
      write FCryptKey;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.StrUtils,
  Winapi.ShellAPI,
  Vcl.ExtDlgs,
  System.TypInfo;

procedure TForm1.btDisponibilizarDocumentoClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vgAPI.d4signAPI.Documentos.Primeiro;
  vSucesso := vgAPI.d4signAPI.DocumentoDisponibilizar;

  if vSucesso then
    ShowMessage('Documento disponibilizado com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnAbrirDirTmpClick(Sender: TObject);
begin
  if not DirectoryExists(ExtractFilePath(Application.ExeName) + edtPathTempExport.Text) then
    CreateDir(ExtractFilePath(Application.ExeName) + edtPathTempExport.Text);

  ShowFolder(ExtractFilePath(Application.ExeName) + edtPathTempExport.Text);
end;

procedure TForm1.btnAdicionarAnexoClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;

  vgAPI.d4signAPI.Documentos.Primeiro;

  vSucesso := vgAPI.d4signAPI.DocumentoPrincipalAnexoBin(SelecionarArquivosUPLOAD);

  if vSucesso then
    ShowMessage('Salvo anexo adicionado com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnAdicionarDocumentoBinClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vSucesso := vgAPI.d4signAPI.DocumentoPrincipalAdicionarBin(SelecionarArquivosUPLOAD);

  if vSucesso then
    ShowMessage('Salvo com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnAdicionarDocumentoFormClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vSucesso := vgAPI.d4signAPI.DocumentoPrincipalAdicionarForm(SelecionarArquivosUPLOAD);

  if vSucesso then
    ShowMessage('Salvo com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnAdicionarSignatarioClick(Sender: TObject);
var
  vSucesso: Boolean;
  vQtnSignatarios: Integer;
  vI: Integer;
begin
  InformarChavesAcessod4sign;

  vQtnSignatarios := StrToIntDef(InputBox('Signatários','Informe a quantide','1'),1);

  for vI := 1 to vQtnSignatarios do
  begin
    vgAPI.d4signAPI.Documentos.Primeiro;
    vgAPI.d4signAPI.SignatarioPreparar;
    vgAPI.d4signAPI.Signatarios.Atual.email                 := InputBox('Signatário','email','seuusuario@outlook.com');
    vgAPI.d4signAPI.Signatarios.Atual.act                   := sig_act_assinar;
    vgAPI.d4signAPI.Signatarios.Atual.foreign               := sig_foreign_possui_CPF;
    vgAPI.d4signAPI.Signatarios.Atual.certificadoicpbr      := sig_certificadoicpbr_padrao_d4sign;
    vgAPI.d4signAPI.Signatarios.Atual.assinatura_presencial := sig_assinatura_presencial_nao;
  // email                 (obrigatório)
  // act                   (obrigatório)
  // foreign               (obrigatório)
  // certificadoicpbr      (obrigatório)
  // assinatura_presencial (obrigatório)
  end;

  if vQtnSignatarios=1 then
    vSucesso := vgAPI.d4signAPI.SignatarioAdicionar
  else
    vSucesso := vgAPI.d4signAPI.SignatariosAdicionar;

  if vSucesso then
    ShowMessage('Signatário cadastrado com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnCancelarDocumentoClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vgAPI.d4signAPI.Documentos.Primeiro;
  vSucesso := vgAPI.d4signAPI.DocumentoCancelar('cancelamento teste');

  if vSucesso then
    ShowMessage('Cancelado com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnCarregarCofreClick(Sender: TObject);
begin
  CarregarCofred4sign;
end;

procedure TForm1.btnCarregarCofresClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vSucesso := vgAPI.d4signAPI.ObterCofres;

  if vSucesso then
    ShowMessage('Cofres carregados com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnCarregarDocumentosClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;

  if cbxFiltroFaseTeste.ItemIndex <= 0 then
    vSucesso := vgAPI.d4signAPI.ObterDocumentos
  else
    vSucesso := vgAPI.d4signAPI.ObterDocumentos(TDocumentoFase(LeftStr(cbxFiltroFaseTeste.Text, 2).ToInteger));

  //A listagem de documntos está em vgAPI.d4signAPI.Documentos

  if vSucesso then
    ShowMessage('Documentos carregados com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnCarregarSignatarioClick(Sender: TObject);
var
  vSucesso: Boolean;
begin
  InformarChavesAcessod4sign;
  vSucesso := vgAPI.d4signAPI.ObterSignatarios;

  if vSucesso then
    ShowMessage('Salvo com sucesso.')
  else
    ShowMessage('Ocorreu um erro ('+vgAPI.d4signAPI.MensagemRetorno+').');
end;

procedure TForm1.btnExibirDocumentosClick(Sender: TObject);
begin
  InformarChavesAcessod4sign;

  InformarStatus('Documento ----- INICIO -----', True);
  InformarStatus('');
  vgAPI.d4signAPI.Documentos.Primeiro;
  while not vgAPI.d4signAPI.Documentos.Fim do
  begin
    InformarStatus('uuidDoc:' + vgAPI.d4signAPI.Documentos.Atual.uuidDoc);
    InformarStatus('nameDoc:' + vgAPI.d4signAPI.Documentos.Atual.nameDoc);
    InformarStatus('type_file:' + vgAPI.d4signAPI.Documentos.Atual.type_file);
    InformarStatus('size:' + vgAPI.d4signAPI.Documentos.Atual.size.ToString);
    InformarStatus('safeName:' + vgAPI.d4signAPI.Documentos.Atual.safeName);
    InformarStatus('statusId:' + vgAPI.d4signAPI.Documentos.Atual.statusId);
    InformarStatus('statusName:' + vgAPI.d4signAPI.Documentos.Atual.statusName);
    InformarStatus('');

    vgAPI.d4signAPI.Documentos.Proximo;
  end;
  InformarStatus('Documento ----- FIM -----');
  InformarStatus('');
end;

procedure TForm1.btnExibirSignatariosClick(Sender: TObject);
begin
  InformarStatus('Signatários ----- INICIO -----', True);
  InformarStatus('');

  vgAPI.d4signAPI.Signatarios.Primeiro;
  while not vgAPI.d4signAPI.Signatarios.Fim do
  begin
    InformarStatus('key_signer:' + vgAPI.d4signAPI.Signatarios.Atual.key_signer);
    InformarStatus('email:' + vgAPI.d4signAPI.Signatarios.Atual.email);
    InformarStatus('user_name:' + vgAPI.d4signAPI.Signatarios.Atual.user_name);
    InformarStatus('user_document:' + vgAPI.d4signAPI.Signatarios.Atual.user_document);
    InformarStatus('act:' + GetEnumName(TypeInfo(TSignatario_act), Integer(vgAPI.d4signAPI.Signatarios.Atual.act)));
    InformarStatus('');

    vgAPI.d4signAPI.Signatarios.Proximo;
  end;

  InformarStatus('Signatários ----- FIM -----');
  InformarStatus('');
end;

procedure TForm1.btnLimparTesteClick(Sender: TObject);
begin
  vgAPI.d4signAPI.Limpar;
end;

procedure TForm1.CarregarCofred4sign;
var
  vSucesso   : Boolean;
  vCofreAtual: string;
  vPosicaoAtual: Integer;
begin
  InformarChavesAcessod4sign;
  vSucesso := vgAPI.d4signAPI.ObterCofres;

  if vSucesso then
  begin
    if cbxCofre.ItemIndex > -1 then
      vCofreAtual := vgAPI.d4signAPI.Cofres.Atual.uuid_safe
    else
      vCofreAtual := '';

    cbxCofre.Items.Clear;
    vgAPI.d4signAPI.Cofres.Primeiro;
    while not vgAPI.d4signAPI.Cofres.Fim do
    begin
      cbxCofre.Items.Add(vgAPI.d4signAPI.Cofres.Atual.name_safe);

      if SameText(vCofreAtual,vgAPI.d4signAPI.Cofres.Atual.uuid_safe) then
        vPosicaoAtual := vgAPI.d4signAPI.Cofres.Idx;

      vgAPI.d4signAPI.Cofres.Proximo;
    end;

    if not string.IsNullOrEmpty(vCofreAtual) then
    begin
      vgAPI.d4signAPI.Cofres.Idx(vPosicaoAtual);
      cbxCofre.ItemIndex := vPosicaoAtual;
    end;
  end
  else
  begin
    MessageDlg('Erro ao obter os cofres da d4sign.', mtError, [mbOK], 0);
  end;
end;

procedure TForm1.edtCryptKeyd4signChange(Sender: TObject);
begin
  FCryptKey:= edtCryptKeyd4sign.Text
end;

procedure TForm1.edtTokend4signChange(Sender: TObject);
begin
  Token:= edtTokend4sign.Text;
end;

procedure TForm1.InformarChavesAcessod4sign;
begin
  vgAPI.d4signAPI.tokenAPI := edtTokend4sign.Text;
  vgAPI.d4signAPI.cryptKey := edtCryptKeyd4sign.Text;

  if ckSalvarLogEndpoint.Checked then
    vgAPI.d4signAPI.PathLOGEndpoint := ExtractFilePath(Application.ExeName) + edtPathTempExport.Text
  else
    vgAPI.d4signAPI.PathLOGEndpoint := '';
end;

procedure TForm1.InformarStatus(pTXT: string; pLimpaMSG: Boolean);
begin
  if pLimpaMSG then
  begin
    memoInformacoes.Clear;

    if pTXT.Trim.Length > 0 then
      memoInformacoes.Lines.Add(pTXT);
  end
  else
  begin
    memoInformacoes.Lines.Add(pTXT);
  end;

  Application.ProcessMessages;
end;

function TForm1.SelecionarArquivosUPLOAD: string;
var
  vSelFile: TOpenPictureDialog;
  vArquivo: string;
begin
  vArquivo := '';

  vSelFile := TOpenPictureDialog.Create(Self);
  try
    vSelFile.Filter     := 'Arquivos d4sign |*.pdf;*.doc;*.docx;*.jpg;*.png;*.bmp';
    vSelFile.InitialDir := ExtractFilePath(Application.ExeName);
    vSelFile.Title      := 'Arquivos d4sign';
    vSelFile.Execute();

    if vSelFile.FileName <> '' then
    begin
      vArquivo := vSelFile.FileName;
    end;

  finally
    FreeAndNil(vSelFile);
  end;

  Result := vArquivo;
end;

procedure TForm1.ShowFolder(strFolder: string);
begin
  ShellExecute(Application.Handle, PChar('explore'), PChar(strFolder), nil, nil, SW_SHOWNORMAL);
end;

end.
