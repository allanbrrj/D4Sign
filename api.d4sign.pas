unit api.d4sign;

interface

uses
  System.Generics.Collections, System.Net.HttpClientComponent,
  api.d4sign.cofre, api.d4sign.documento, api.d4sign.documento.signatario,
  api.d4sign.tipos, System.Classes, System.Net.Mime, System.Net.HttpClient;

type
  Td4signAPI = class;

  Id4signAPI = interface
    ['{74A0C02E-3A40-46BE-A2BA-183AA9C073A8}']
    function d4signAPI: Td4signAPI;
  end;

  TListaIterator<T: class, constructor> = class
  private
    FIDX  : Integer;
    FLista: TObjectList<T>;
  public
    constructor Create(pLista: TObjectList<T>);

    procedure Primeiro;
    procedure Proximo;
    procedure Ultimo;
    function Atual: T;
    function Idx(pIDX: Integer = -1): Integer;
    function Fim: Boolean;
  end;

  TDocumentoGerenciado = class
  private
    Fdocumento_idx : Integer;
    Fsignatario_idx: Integer;
    Fcofre_idx     : Integer;
    procedure Setcofre_idx(const Value: Integer);
    procedure Setdocumento_idx(const Value: Integer);
    procedure Setsignatario_idx(const Value: Integer);
  public
    property cofre_idx: Integer
      read   Fcofre_idx
      write  Setcofre_idx;
    property documento_idx: Integer
      read   Fdocumento_idx
      write  Setdocumento_idx;
    property signatario_idx: Integer
      read   Fsignatario_idx
      write  Setsignatario_idx;
  end;

  // URL API
  // http://docapi.d4sign.com.br
  Td4signAPI = class(TInterfacedObject, Id4signAPI)
  private
    FSendCommand                     : TNetHTTPClient;
    FStatusCode                      : Integer;
    FurlAPI                          : string;
    FcryptKey                        : string;
    FtokenAPI                        : string;
    FListaCofres                     : TObjectList<TCofre>;
    FListaCofresIDX                  : TListaIterator<TCofre>;
    FListaDocumentos                 : TObjectList<TDocumento>;
    FListaDocumentosIDX              : TListaIterator<TDocumento>;
    FListaSignatarios                : TObjectList<TSignatario>;
    FListaSignatariosIDX             : TListaIterator<TSignatario>;
    FListaDocumentosSignatariosTMP   : TObjectList<TSignatario>;
    FListaDocumentosSignatariosTMPIDX: TListaIterator<TSignatario>;
    FUltimoDocumentosSignatariosIDX  : Integer;
    FListaDocumentosGerenciados      : TObjectList<TDocumentoGerenciado>;
    FMensagemRetorno                 : string;
    FPathLOGEndpoint                 : string;

    procedure SetcryptKey(const Value: string);
    procedure SettokenAPI(const Value: string);
    function readCofres: TListaIterator<TCofre>;
    function readDocumentos: TListaIterator<TDocumento>;
    function readSignatarios: TListaIterator<TSignatario>;

    function url_validacao: string;
    function url_base: string;
    function command: TNetHTTPClient;
    function DocumentosGerenciados: TObjectList<TDocumentoGerenciado>;
    function DocumentosSignatariosTMP: TObjectList<TSignatario>;
    function ListaSignatarios: TObjectList<TSignatario>;
    function ListaDocumentos: TObjectList<TDocumento>;
    function ListaCofres: TObjectList<TCofre>;
    function IdxCofre(puuid: string): Integer;
    function ArquivoParaStringBase64(pArquivo: string): string;
    function StreamParaBase64(pDado: TMemoryStream): string;
    function RetornaMimeType(pArquivo: string): string;
    function SignatarioSemKey(pEmail: string): TSignatario;

    procedure ValidarUso;
    procedure CopiarObjeto<T: class>(pOrigem: T; var pDestino: T);
    procedure GerarListagemSignatarioTMP;
    procedure ProcessarRetorno(pResposta:TStringStream);
    procedure LogEndpoint(pBody: TObject;
                          pResposta: TStringStream;
                          pEndpoint: string;
                          pCodResposta: Integer);
  public
    constructor Create(purlAPI: string = 'https://secure.d4sign.com.br/api/v1/');
    destructor Destroy; override;

    function d4signAPI: Td4signAPI;

    procedure Limpar;

    function StatusCode: Integer;

    function ObterCofres: Boolean;
    function ObterDocumentos(pDocFase: TDocumentoFase = doc_fase_todos): Boolean;
    function ObterDocumentosCofre: Boolean;
    function ObterSignatarios: Boolean;

    function DocumentoPrincipalAdicionarBin(pArquivo: string; pTitulo: string = ''): Boolean;
    function DocumentoPrincipalAdicionarForm(pArquivo: string): Boolean;
    function DocumentoPrincipalAnexoBin(pArquivo: string; pTitulo: string = ''): Boolean;
    function DocumentoPrincipalAnexoForm(pArquivo: string): Boolean;
    function DocumentoDisponibilizar(skip_email: Integer = 0; workflow: Integer = 0; pMensagem: string = ''): Boolean;
    function DocumentoCancelar(pObsCancelamento: string = ''): Boolean;
    function DocumentosTotal: Integer;

    function SignatarioPreparar: Td4signAPI;
    function SignatarioAdicionar: Boolean;
    function SignatariosAdicionar: Boolean;
    function SignatariosDocumentoAtual: TListaIterator<TSignatario>;

    property tokenAPI: string
      read   FtokenAPI
      write  SettokenAPI;

    property cryptKey: string
      read   FcryptKey
      write  SetcryptKey;

    property Cofres: TListaIterator<TCofre>
      read   readCofres;

    property Documentos: TListaIterator<TDocumento>
      read   readDocumentos;

    property Signatarios: TListaIterator<TSignatario>
      read   readSignatarios;

    property MensagemRetorno: string
      read   FMensagemRetorno;

    property PathLOGEndpoint: string
      read   FPathLOGEndpoint
      write  FPathLOGEndpoint;
  end;

var
  vgAPI: Id4signAPI;

implementation

uses
  System.SysUtils, System.JSON, REST.JSON, System.Rtti,
  System.NetEncoding, System.StrUtils, System.Net.URLClient;

{ Td4signAPI }

function Td4signAPI.ArquivoParaStringBase64(pArquivo: string): string;
var
  vFile: TMemoryStream;
  vStringBase64:string;
begin
  vStringBase64 := '';
  if pArquivo<>'' then
  begin
    vFile := TMemoryStream.Create;
    try
      vFile.LoadFromFile(pArquivo);
      vFile.Position := 0;
      vStringBase64 := StreamParaBase64(vFile);
    finally
      vFile.Clear;
      FreeAndNil(vFile);
    end;
  end;

  Result := vStringBase64;
end;

function Td4signAPI.command: TNetHTTPClient;
begin
  if not Assigned(FSendCommand) then
  begin
    FSendCommand := TNetHTTPClient.Create(nil);
  end;

  Result := FSendCommand;
end;

procedure Td4signAPI.CopiarObjeto<T>(pOrigem: T; var pDestino: T);
var
  ctx        : TRttiContext;
  FromObjType: TRttiType;
  ToObjType  : TRttiType;
  FromField  : TRttiProperty;
  ToField    : TRttiProperty;
  vCampo     : string;
begin
  try
    // NAO PEGAR PROPRIEDADE PRIVADA  FromObjType := Ctx.GetType(FromObj.ClassInfo);
    FromObjType := ctx.GetType(pOrigem.ClassType);
    ToObjType   := ctx.GetType(pDestino.ClassType);

    // NAO PEGAR PROPRIEDADE PRIVADA  for FromField in FromObjType.GetFields do
    for FromField in FromObjType.GetProperties do
    begin
      // NAO PEGAR PROPRIEDADE PRIVADA   ToField := ToObjType.GetField(FromField.Name);
      ToField := ToObjType.GetProperty(FromField.Name);
      vCampo  := FromField.Name;
      if Assigned(ToField) then
      begin
        // NAO PEGAR PROPRIEDADE PRIVADA       if ToField.FieldType = FromField.FieldType then
        if ToField.IsWritable then
          if ToField.PropertyType = FromField.PropertyType then
            ToField.SetValue(Pointer(pDestino), FromField.GetValue(Pointer(pOrigem)));
        // NAO TOCAR       ToField.SetValue(ToObj, FromField.GetValue(FromObj));
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro copia objeto, campo "' + vCampo + '"');
  end;
end;

constructor Td4signAPI.Create(purlAPI: string);
begin
  FurlAPI                         := purlAPI;
  FUltimoDocumentosSignatariosIDX := -1;
end;

function Td4signAPI.d4signAPI: Td4signAPI;
begin
  Result := Self;
end;

destructor Td4signAPI.Destroy;
begin
  if Assigned(FListaCofres) then
  begin
    FListaCofres.Clear;
    FreeAndNil(FListaCofres);
    FreeAndNil(FListaCofresIDX);
  end;

  if Assigned(FListaDocumentos) then
  begin
    FListaDocumentos.Clear;
    FreeAndNil(FListaDocumentos);
    FreeAndNil(FListaDocumentosIDX);
  end;

  if Assigned(FListaDocumentosGerenciados) then
  begin
    FListaDocumentosGerenciados.Clear;
    FreeAndNil(FListaDocumentosGerenciados);
  end;

  if Assigned(FListaSignatarios) then
  begin
    FListaSignatarios.Clear;
    FreeAndNil(FListaSignatarios);
    FreeAndNil(FListaSignatariosIDX);
  end;

  if Assigned(FListaDocumentosSignatariosTMP) then
  begin
    FListaDocumentosSignatariosTMP.Clear;
    FreeAndNil(FListaDocumentosSignatariosTMP);
    FreeAndNil(FListaDocumentosSignatariosTMPIDX);
  end;

  if Assigned(FSendCommand) then
    FreeAndNil(FSendCommand);

  inherited;
end;

function Td4signAPI.DocumentoDisponibilizar(skip_email: Integer = 0; workflow: Integer = 0; pMensagem: string = ''): Boolean;
var
  vURL     : string;
  vSucesso : Boolean;
  vBody    : TStringStream;
  vObjJson : TJSONObject;
  vResposta: TStringStream;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  // if DocumentosSignatariosTMP.Count = 0 then
  // raise Exception.Create('É necessário cadastrar o sinatário.');

  vURL := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/sendtosigner?' + url_validacao;

  try
    vObjJson := TJSONObject.Create;
    vObjJson.AddPair('message', pMensagem);
    vObjJson.AddPair('skip_email', skip_email.ToString);
    vObjJson.AddPair('workflow', workflow.ToString);
    vObjJson.AddPair('tokenAPI', tokenAPI);

    vBody := TStringStream.Create(vObjJson.ToJSON, TEncoding.UTF8);
  finally
    FreeAndNil(vObjJson);
  end;

  vResposta := TStringStream.Create;

  try
    command.ContentType := 'application/json';
    FStatusCode         := command.Post(vURL,vBody,vResposta).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  command.ContentType := '';
  vBody.Clear;
  FreeAndNil(vBody);

  vResposta.Clear;
  FreeAndNil(vResposta);

  Result := vSucesso;
end;

function Td4signAPI.DocumentoPrincipalAdicionarBin(pArquivo: string; pTitulo: string = ''): Boolean;
var
  vURL         : string;
  vBody        : TMultipartFormData;
  vResposta    : TStringStream;
  vSucesso     : Boolean;
  vRespostaJson: TJSONValue;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if ListaCofres.Count = 0 then
    raise Exception.Create('É necessário existir ao menos um cofre.');

  if pArquivo.Trim.Length = 0 then
    raise Exception.Create('Infome o arquivo.');

  vURL := url_base + 'documents/' + Cofres.Atual.uuid_safe + '/uploadbinary?' + url_validacao;

  vBody     := TMultipartFormData.Create;
  vResposta := TStringStream.Create;

  vBody.AddField('base64_binary_file', ArquivoParaStringBase64(pArquivo));
  vBody.AddField('mime_type', RetornaMimeType(pArquivo));
  vBody.AddField('name', IfThen(pTitulo.Trim.Length > 0,
                                pTitulo,
                                ExtractFileName(pArquivo).Replace(ExtractFileExt(pArquivo),'')));
  vBody.AddField('tokenAPI', tokenAPI);
  vBody.AddField('uuid_folder', '');

  try
    FStatusCode := command.Post(vURL, vBody, vResposta).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;

        ListaDocumentos.Add(TDocumento.Create);
        Documentos.Ultimo;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  if vSucesso then
  begin
    try
      vRespostaJson               := TJSONObject.ParseJSONValue(vResposta.DataString);
      Documentos.Atual.uuidDoc    := vRespostaJson.GetValue<string>('uuid');
      Documentos.Atual.uuidSafe   := Cofres.Atual.uuid_safe;
      Documentos.Atual.statusId   := '2';
      Documentos.Atual.statusName := 'Aguardando Signatários';
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;

  FreeAndNil(vBody);
  vResposta.Clear;
  FreeAndNil(vResposta);

  Result := vSucesso;
end;

function Td4signAPI.DocumentoPrincipalAdicionarForm(pArquivo: string): Boolean;
var
  vURL         : string;
  vBody        : TMultipartFormData;
  //vHeader      : TNetHeaders;
  vResposta    : TStringStream;
  vSucesso     : Boolean;
  vRespostaJson: TJSONValue;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if ListaCofres.Count = 0 then
    raise Exception.Create('É necessário existir ao menos um cofre.');

  if pArquivo.Trim.Length = 0 then
    raise Exception.Create('Infome o arquivo.');

  vURL := url_base + 'documents/' + Cofres.Atual.uuid_safe + '/upload?' + url_validacao;

  vBody     := TMultipartFormData.Create;
  vResposta := TStringStream.Create;

  //vHeader := [TNetHeader.Create('tokenAPI', tokenAPI)];

  //command.CustomHeaders['tokenAPI'] := tokenAPI;

  vBody.AddFile('file', pArquivo);
  vBody.AddField('uuid_folder', '');

  try
    command.ContentType := 'multipart/form-data;';
    FStatusCode := command.Post(vURL, vBody, vResposta,[TNetHeader.Create('tokenAPI', tokenAPI)]).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;

        ListaDocumentos.Add(TDocumento.Create);
        Documentos.Ultimo;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  if vSucesso then
  begin
    try
      vRespostaJson               := TJSONObject.ParseJSONValue(vResposta.DataString);
      Documentos.Atual.uuidDoc    := vRespostaJson.GetValue<string>('uuid');
      Documentos.Atual.statusId   := '2';
      Documentos.Atual.statusName := 'Aguardando Signatários';
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;

  FreeAndNil(vBody);
  vResposta.Clear;
  FreeAndNil(vResposta);
  //command.CustomHeaders.Empty;

  Result := vSucesso;
end;

function Td4signAPI.DocumentoPrincipalAnexoBin(pArquivo: string; pTitulo: string = ''): Boolean;
var
  vURL     : string;
  vBody    : TMultipartFormData;
  vSucesso : Boolean;
  vResposta: TStringStream;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  if pArquivo.Trim.Length = 0 then
    raise Exception.Create('Infome o arquivo.');

  vURL := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/uploadslavebinary?' + url_validacao;

  vBody     := TMultipartFormData.Create;
  vResposta := TStringStream.Create;

  vBody.AddField('base64_binary_file', ArquivoParaStringBase64(pArquivo));
  vBody.AddField('mime_type', RetornaMimeType(pArquivo));
  vBody.AddField('name', IfThen(pTitulo.Trim.Length > 0,
                                pTitulo,
                                ExtractFileName(pArquivo).Replace(ExtractFileExt(pArquivo), '')));
  vBody.AddField('tokenAPI', tokenAPI);
  vBody.AddField('uuid_folder', '');

  try
    FStatusCode := command.Post(vURL,vBody,vResposta).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  vResposta.Clear;
  FreeAndNil(vResposta);

  FreeAndNil(vBody);

  Result := vSucesso;
end;

function Td4signAPI.DocumentoPrincipalAnexoForm(pArquivo: string): Boolean;
var
  vURL         : string;
  vBody        : TMultipartFormData;
  //vHeader      : TNetHeaders;
  vResposta    : TStringStream;
  vSucesso     : Boolean;
  vRespostaJson: TJSONValue;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  if pArquivo.Trim.Length = 0 then
    raise Exception.Create('Infome o arquivo.');

  vURL := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/uploadslave?' + url_validacao;

  vBody     := TMultipartFormData.Create;
  vResposta := TStringStream.Create;

  //vHeader := [TNetHeader.Create('tokenAPI', tokenAPI)];

  //command.CustomHeaders['tokenAPI'] := tokenAPI;

  vBody.AddFile('file', pArquivo);
  vBody.AddField('uuid_folder', '');

  try
    command.ContentType := 'multipart/form-data;';
    FStatusCode := command.Post(vURL, vBody, vResposta,[TNetHeader.Create('tokenAPI', tokenAPI)]).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  FreeAndNil(vBody);
  vResposta.Clear;
  FreeAndNil(vResposta);
  //command.CustomHeaders.Empty;

  Result := vSucesso;
end;

function Td4signAPI.DocumentoCancelar(pObsCancelamento: string = ''): Boolean;
var
  vSucesso : Boolean;
  vURL     : string;
  vBody    : TMultipartFormData;
  vResposta: TStringStream;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  vURL      := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/cancel?' + url_validacao;
  vResposta := TStringStream.Create;
  vBody     := TMultipartFormData.Create;
  vBody.AddField('comment', pObsCancelamento);

  try
    FStatusCode := command.Post(vURL,vBody,vResposta).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso                    := True;
        Documentos.Atual.statusId   := '6';
        Documentos.Atual.statusName := 'Cancelado';
      end;
    else
    begin
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso := False;
    end;
  end;

  FreeAndNil(vBody);

  vResposta.Clear;
  FreeAndNil(vResposta);

  Result := vSucesso;
end;

function Td4signAPI.DocumentosGerenciados: TObjectList<TDocumentoGerenciado>;
begin
  if not Assigned(FListaDocumentosGerenciados) then
    FListaDocumentosGerenciados := TObjectList<TDocumentoGerenciado>.Create;

  Result := FListaDocumentosGerenciados;
end;

function Td4signAPI.DocumentosSignatariosTMP: TObjectList<TSignatario>;
begin
  if not Assigned(FListaDocumentosSignatariosTMP) then
  begin
    FListaDocumentosSignatariosTMP    := TObjectList<TSignatario>.Create;
    FListaDocumentosSignatariosTMPIDX := TListaIterator<TSignatario>.Create(FListaDocumentosSignatariosTMP);
  end;

  Result := FListaDocumentosSignatariosTMP;
end;

function Td4signAPI.DocumentosTotal: Integer;
begin
  Result := ListaDocumentos.Count;
end;

procedure Td4signAPI.GerarListagemSignatarioTMP;
var
  vSignatario         : TSignatario;
  vDocumentoGerenciado: TDocumentoGerenciado;
begin

  DocumentosSignatariosTMP.Clear;
  FUltimoDocumentosSignatariosIDX := Documentos.Idx;

  for vDocumentoGerenciado in DocumentosGerenciados do
  begin
    if vDocumentoGerenciado.documento_idx = Documentos.Idx then
    begin
      DocumentosSignatariosTMP.Add(TSignatario.Create);
      vSignatario := DocumentosSignatariosTMP.Last;
      CopiarObjeto<TSignatario>(ListaSignatarios[vDocumentoGerenciado.signatario_idx], vSignatario);
    end;
  end;
end;

function Td4signAPI.IdxCofre(puuid: string): Integer;
var
  vID: Integer;
begin
  vID := -1;

  Cofres.Primeiro;
  while not Cofres.Fim do
  begin
    if AnsiSameText(puuid, Cofres.Atual.uuid_safe) then
    begin
      vID := Cofres.Idx;
      Break
    end;
    Cofres.Proximo;
  end;

  Result := vID;
end;

procedure Td4signAPI.Limpar;
begin
  ListaDocumentos.Clear;
  ListaSignatarios.Clear;
  DocumentosGerenciados.Clear;
end;

function Td4signAPI.ListaCofres: TObjectList<TCofre>;
begin
  if not Assigned(FListaCofres) then
  begin
    FListaCofres    := TObjectList<TCofre>.Create;
    FListaCofresIDX := TListaIterator<TCofre>.Create(FListaCofres);
  end;

  Result := FListaCofres;
end;

function Td4signAPI.ListaDocumentos: TObjectList<TDocumento>;
begin
  if not Assigned(FListaDocumentos) then
  begin
    FListaDocumentos    := TObjectList<TDocumento>.Create;
    FListaDocumentosIDX := TListaIterator<TDocumento>.Create(FListaDocumentos);
  end;

  Result := FListaDocumentos;
end;

function Td4signAPI.ListaSignatarios: TObjectList<TSignatario>;
begin
  if not Assigned(FListaSignatarios) then
  begin
    FListaSignatarios    := TObjectList<TSignatario>.Create;
    FListaSignatariosIDX := TListaIterator<TSignatario>.Create(FListaSignatarios);
  end;

  Result := FListaSignatarios;
end;

procedure Td4signAPI.LogEndpoint(pBody: TObject;
                                 pResposta: TStringStream;
                                 pEndpoint: string;
                                 pCodResposta: Integer);
var
  vLOG: TStrings;
  vVALOR: string;
begin
  if not string.IsNullOrWhiteSpace(PathLOGEndpoint) then
  begin
    vLOG := TStringList.Create;
    try
      if pBody<>nil then
      begin
        if pBody is TStringStream then
        begin
          vLOG.Text := TStringStream(pBody).DataString;
          vLOG.Insert(0,'Body enviado:');
          vLOG.Insert(0,'Endpoint: '+pEndpoint);
          vLOG.SaveToFile(PathLOGEndpoint+'\'+'log_body.txt');
          vLOG.Clear;
        end;

        if pBody is TMultipartFormData then
        begin
          TMultipartFormData(pBody).Stream.SaveToFile(PathLOGEndpoint+'\'+'log_body_temp.txt');
          vLOG.LoadFromFile(PathLOGEndpoint+'\'+'log_body_temp.txt');
          DeleteFile(PathLOGEndpoint+'\'+'log_body_temp.txt');
          vLOG.Insert(0,'Body enviado:');
          vLOG.Insert(0,'Endpoint: '+pEndpoint);
          vLOG.SaveToFile(PathLOGEndpoint+'\'+'log_body.txt');
          vLOG.Clear;
        end;
      end;

      if pResposta<>nil then
      begin
        vLOG.Text := pResposta.DataString;
        vLOG.Insert(0,'Resposta recebida:');
        vLOG.Insert(0,'Código resposta: ' + pCodResposta.ToString);
        vLOG.Insert(0,'Endpoint: '+pEndpoint);
        vLOG.SaveToFile(PathLOGEndpoint+'\'+'log_resposta.txt');
      end;
    finally
     vLOG.Clear;
     FreeAndNil(vLOG);
    end;
  end;
end;

function Td4signAPI.SignatariosAdicionar: Boolean;
var
  vSucesso         : Boolean;
  vURL             : string;
  vBody            : TStringStream;
  vResposta        : TStringStream;
  vObjJson         : TJSONObject;
  vJsonArray       : TJSONArray;
  vRespostaJson    : TJSONObject;
  vRespostaArray   : TJSONArray;
  vRespostaItem    : TJSONValue;
  vSignatario      : TSignatario;
  vQtnRecebidos    : Integer;
  vQtnEnviados     : Integer;
  vValidEmail      : string;
  vValidkey_signer : string;
  vValidStatus     : string;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  GerarListagemSignatarioTMP;
  SignatariosDocumentoAtual.Primeiro;
  while not SignatariosDocumentoAtual.Fim do
  begin
// 20240711 - Essa validação não é mais necessária.
//    if SignatariosDocumentoAtual.Atual.key_signer.Trim.Length <> 0 then
//      raise Exception.Create('O signatário já está vinculado.');

    if (SignatariosDocumentoAtual.Atual.email.Trim.Length = 0) or (SignatariosDocumentoAtual.Atual.act = sig_act_invalido) then
    begin
      FStatusCode := 3;
      raise Exception.Create('Os campos email, act, foreign, certificadoicpbr, assinatura_presencial são obrigatórios.');
    end;

    SignatariosDocumentoAtual.Proximo;
  end;

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  vURL := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/createlist?' + url_validacao;

  try
    vObjJson   := TJSONObject.Create;
    vJsonArray := TJSONArray.Create;

    SignatariosDocumentoAtual.Primeiro;
    vQtnEnviados := 0;
    while not SignatariosDocumentoAtual.Fim do
    begin
      vJsonArray.Add(TJson.ObjectToJsonObject(SignatariosDocumentoAtual.Atual));
      SignatariosDocumentoAtual.Proximo;
      Inc(vQtnEnviados);
    end;

    vObjJson.AddPair('signers', vJsonArray);

    vBody     := TStringStream.Create(vObjJson.ToString, TEncoding.UTF8);
    vResposta := TStringStream.Create;
  finally
    FreeAndNil(vObjJson);
  end;

  try
    command.ContentType := 'application/json';
    FStatusCode         := command.Post(vURL,vBody,vResposta).StatusCode;
    LogEndpoint(vBody,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  if vSucesso then
  begin
    try
      vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString) as TJSONObject;

      if not vRespostaJson.GetValue('message').Null then
      begin
        if vRespostaJson.GetValue('message') is TJSONArray then
        begin
          vRespostaArray := vRespostaJson.GetValue('message') as TJSONArray;
          vQtnRecebidos := 0;
          for vRespostaItem in vRespostaArray do
          begin
            try
              vValidEmail := '';
              vRespostaItem.TryGetValue<string>('email',vValidEmail);

              vValidkey_signer := '';
              vRespostaItem.TryGetValue<string>('key_signer',vValidkey_signer);

              vValidStatus := '';
              vRespostaItem.TryGetValue<string>('status',vValidStatus);

              if (not string.IsNullOrWhiteSpace(vValidEmail)) and
                 (not string.IsNullOrWhiteSpace(vValidkey_signer))
              then
              begin
                vSignatario := SignatarioSemKey(vValidEmail);
                if vSignatario<>nil then
                begin
                  vSignatario.key_signer := vValidkey_signer;
                  Inc(vQtnRecebidos);
                end;
              end
              else
              begin
                raise Exception.Create('valores (email="'+vValidEmail+
                                       '",key_signer="'+vValidkey_signer+
                                       '",status="'+vValidStatus+'"), estão em branco.');
              end;
            except on E: Exception do
            begin
              vQtnRecebidos    := vRespostaArray.Count;
              vSucesso         := False;
              FMensagemRetorno := 'A resposta do enpoint ' + vURL +
                                  ' é inválida (' + e.Message + ').'
            end;
            end;
          end;
        end
        else
        begin
          vSucesso         := False;
          ProcessarRetorno(vResposta);
        end;
      end;
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;

  command.ContentType := '';
  vBody.Clear;
  FreeAndNil(vBody);
  vResposta.Clear;
  FreeAndNil(vResposta);
  GerarListagemSignatarioTMP;

  if vQtnRecebidos<>vQtnEnviados then
  begin
    FStatusCode := 2;
    vSucesso    := False;
  end;

  Result := vSucesso;
end;

function Td4signAPI.SignatariosDocumentoAtual: TListaIterator<TSignatario>;
var
  vSignatario         : TSignatario;
  vDocumentoGerenciado: TDocumentoGerenciado;
begin
  if not Assigned(FListaDocumentosSignatariosTMP) then
  begin
    FListaDocumentosSignatariosTMP    := TObjectList<TSignatario>.Create;
    FListaDocumentosSignatariosTMPIDX := TListaIterator<TSignatario>.Create(FListaDocumentosSignatariosTMP);
  end;

  if (Documentos.Idx <> FUltimoDocumentosSignatariosIDX) then
  begin
    GerarListagemSignatarioTMP;
  end;

  Result := FListaDocumentosSignatariosTMPIDX;
end;

function Td4signAPI.StatusCode: Integer;
begin
  Result := FStatusCode;
end;

function Td4signAPI.StreamParaBase64(pDado: TMemoryStream): string;
var
  vFoto    : TBytes;
  vStrFinal: string;
begin
  try
    // pDado.SaveToFile(ExtractFilePath(Application.ExeName)+'foto_tmp.jpg');
    SetLength(vFoto, pDado.Size);
    pDado.Read(vFoto[0], Length(vFoto));

    vStrFinal := TNetEncoding.Base64.EncodeBytesToString(vFoto);
  finally
    Finalize(vFoto);
    //vFoto := nil;
  end;

  Result := vStrFinal;
end;

function Td4signAPI.SignatarioPreparar: Td4signAPI;
var
  teste: Integer;
begin
  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  ListaSignatarios.Add(TSignatario.Create);

  DocumentosGerenciados.Add(TDocumentoGerenciado.Create);
  DocumentosGerenciados.Last.cofre_idx      := IdxCofre(Documentos.Atual.uuidSafe);
  DocumentosGerenciados.Last.documento_idx  := Documentos.Idx;
  DocumentosGerenciados.Last.signatario_idx := ListaSignatarios.Count - 1;
  GerarListagemSignatarioTMP;

  Signatarios.Ultimo;

  Result := Self;
end;

function Td4signAPI.ObterCofres: Boolean;
var
  vURL         : string;
  vResposta    : TStringStream;
  vRespostaJson: TJSONValue;
  ArrayElement : TJSONValue;
  vCofreLocal  : TCofre;
  vCofreNovo   : TCofre;
  vSucesso     : Boolean;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  vURL      := url_base + 'safes?' + url_validacao;
  vResposta := TStringStream.Create;

  try
    FStatusCode := command.Get(vURL, vResposta).StatusCode;
    LogEndpoint(nil,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  if vSucesso then
  begin
    try
      vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString);

      ListaCofres.Clear;
      for ArrayElement in (vRespostaJson as TJSONArray) do
      begin
        try
          ListaCofres.Add(TCofre.Create);
          vCofreLocal := ListaCofres.Last;
          vCofreNovo  := TJson.JsonToObject<TCofre>(ArrayElement.ToString);
          CopiarObjeto<TCofre>(vCofreNovo, vCofreLocal);
        finally
          FreeAndNil(vCofreNovo);
        end;
      end;
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;

  vResposta.Clear;
  FreeAndNil(vResposta);

  Result := vSucesso;
end;

function Td4signAPI.ObterDocumentos(pDocFase: TDocumentoFase = doc_fase_todos): Boolean;
var
  vURL               : string;
  vQtnPG, vQtnPGatual: Integer;
  vQtnAtual          : Integer;
  vResposta          : TStringStream;
  vRespostaJson      : TJSONValue;
  vRespostaArray     : TJSONArray;
  vDocumentoLocal    : TDocumento;
  vDocumentoNovo     : TDocumento;
  vSucesso           : Boolean;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  ListaDocumentos.Clear;

  vQtnPGatual := 1;
  vQtnPG      := 1;
  repeat
    if pDocFase = doc_fase_todos then
      vURL := url_base + 'documents?' + url_validacao + '&pg=' + vQtnPGatual.ToString
    else
      vURL := url_base + 'documents/' + Integer(pDocFase).ToString + '/status?' + url_validacao + '&pg=' + vQtnPGatual.ToString;

    vResposta := TStringStream.Create;

    try
      FStatusCode := command.Get(vURL, vResposta).StatusCode;
      LogEndpoint(nil,vResposta,vURL,FStatusCode);
      case FStatusCode of
        200:
        begin
          vSucesso := True;
        end;
      else
      begin
        ProcessarRetorno(vResposta);
        vSucesso := False;
      end;
      end;
    except
      on E: Exception do
      begin
        FStatusCode := 1;
        vSucesso    := False;
      end;
    end;

    if vSucesso then
    begin
      try
        vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString);

        if vQtnPGatual = 1 then
        begin
          vRespostaArray := vRespostaJson as TJSONArray;
          vQtnPG         := vRespostaArray.Items[0].GetValue<Integer>('total_pages');
        end;

        for vQtnAtual := 1 to vRespostaArray.Count - 1 do
        begin
          try
            // O primeiro item sempre carrega formacoes sobre paginacao,
            // tem que ignorar
            ListaDocumentos.Add(TDocumento.Create);
            vDocumentoLocal := ListaDocumentos.Last;
            vDocumentoNovo  := TJson.JsonToObject<TDocumento>(vRespostaArray.Items[vQtnAtual].ToString);
            CopiarObjeto<TDocumento>(vDocumentoNovo, vDocumentoLocal);
          finally
            FreeAndNil(vDocumentoNovo);
          end;

        end;
      finally
        FreeAndNil(vRespostaJson);
      end;

    end;

    Inc(vQtnPGatual);
    vResposta.Clear;
    FreeAndNil(vResposta);

    if not vSucesso then
      Break;

  until (vQtnPGatual >= vQtnPG);

  Result := vSucesso;
end;

function Td4signAPI.ObterDocumentosCofre: Boolean;
var
  vURL               : string;
  vQtnPG, vQtnPGatual: Integer;
  vQtnAtual          : Integer;
  vResposta          : TStringStream;
  vRespostaJson      : TJSONValue;
  vRespostaArray     : TJSONArray;
  vDocumentoLocal    : TDocumento;
  vDocumentoNovo     : TDocumento;
  vSucesso           : Boolean;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  ListaDocumentos.Clear;

  vQtnPGatual := 1;
  vQtnPG      := 1;
  repeat
    vURL := url_base + 'documents/' + Cofres.Atual.uuid_safe + '/safe?' + url_validacao + '&pg=' + vQtnPGatual.ToString;

    vResposta := TStringStream.Create;

    try
      FStatusCode := command.Get(vURL, vResposta).StatusCode;
      LogEndpoint(nil,vResposta,vURL,FStatusCode);
      case FStatusCode of
        200:
        begin
          vSucesso := True;
        end;
      else
      begin
        ProcessarRetorno(vResposta);
        vSucesso := False;
      end;
      end;
    except
      on E: Exception do
      begin
        FStatusCode := 1;
        vSucesso    := False;
      end;
    end;

    if vSucesso then
    begin
      try
        vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString);

        if vQtnPGatual = 1 then
        begin
          vRespostaArray := vRespostaJson as TJSONArray;
          vQtnPG         := vRespostaArray.Items[0].GetValue<Integer>('total_pages');
        end;

        for vQtnAtual := 1 to vRespostaArray.Count - 1 do
        begin
          try
            // O primeiro item sempre carrega formacoes sobre paginacao,
            // tem que ignorar
            ListaDocumentos.Add(TDocumento.Create);
            vDocumentoLocal := ListaDocumentos.Last;
            vDocumentoNovo  := TJson.JsonToObject<TDocumento>(vRespostaArray.Items[vQtnAtual].ToString);
            CopiarObjeto<TDocumento>(vDocumentoNovo, vDocumentoLocal);
          finally
            FreeAndNil(vDocumentoNovo);
          end;

        end;
      finally
        FreeAndNil(vRespostaJson);
      end;

    end;

    Inc(vQtnPGatual);
    vResposta.Clear;
    FreeAndNil(vResposta);

    if not vSucesso then
      Break;

  until (vQtnPGatual >= vQtnPG);

  Result := vSucesso;
end;

function Td4signAPI.ObterSignatarios: Boolean;
var
  vURL            : string;
  vResposta       : TStringStream;
  vRespostaJson   : TJSONValue;
  vRespostaArray  : TJSONArray;
  ArrayElement    : TJSONValue;
  vSignatarioLocal: TSignatario;
  vSignatarioNovo : TSignatario;
  vSucesso        : Boolean;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  // Adicionar codigo para obter signatarios
  ValidarUso;

  DocumentosGerenciados.Clear;
  Signatarios.Primeiro;
  ListaSignatarios.Clear;

  Documentos.Primeiro;
  while not Documentos.Fim do
  begin
    vURL      := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/list?' + url_validacao;
    vResposta := TStringStream.Create;

    try
      FStatusCode := command.Get(vURL, vResposta).StatusCode;
      LogEndpoint(nil,vResposta,vURL,FStatusCode);
      case FStatusCode of
        200:
        begin
          vSucesso := True;
        end;
      else
      begin
        ProcessarRetorno(vResposta);
        vSucesso := False;
      end;
      end;
    except
      on E: Exception do
      begin
        FStatusCode := 1;
        vSucesso    := False;
      end;
    end;

    if vSucesso then
    begin
      try
        vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString);
        if not((vRespostaJson as TJSONArray).Items[0] as TJSONObject).GetValue('list').Null then
        begin

          vRespostaArray := ((vRespostaJson as TJSONArray).Items[0] as TJSONObject).GetValue('list') as TJSONArray;

          Signatarios.Primeiro;
          for ArrayElement in vRespostaArray do
          begin
            try
              ListaSignatarios.Add(TSignatario.Create);
              vSignatarioLocal := ListaSignatarios.Last;
              vSignatarioNovo  := TJson.JsonToObject<TSignatario>(ArrayElement.ToString);

              CopiarObjeto<TSignatario>(vSignatarioNovo, vSignatarioLocal);

              DocumentosGerenciados.Add(TDocumentoGerenciado.Create);
              DocumentosGerenciados.Last.cofre_idx      := IdxCofre(Documentos.Atual.uuidSafe);
              DocumentosGerenciados.Last.documento_idx  := Documentos.Idx;
              DocumentosGerenciados.Last.signatario_idx := ListaSignatarios.Count - 1;
            finally
              FreeAndNil(vSignatarioNovo);
            end;
          end;

        end;
      finally
        FreeAndNil(vRespostaJson);
      end;

    end;

    vResposta.Clear;
    FreeAndNil(vResposta);
    Documentos.Proximo;

    if not vSucesso then
      Break;
  end;

  Result := vSucesso;
end;

procedure Td4signAPI.ProcessarRetorno(pResposta: TStringStream);
var
  vRespostaJson: TJSONValue;
begin
  FMensagemRetorno := '';
  if pResposta.DataString<>'' then
  begin
    try
      vRespostaJson := TJSONObject.ParseJSONValue(pResposta.DataString);
      vRespostaJson.TryGetValue<string>('message',FMensagemRetorno);
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;
end;

function Td4signAPI.readCofres: TListaIterator<TCofre>;
begin
  if not Assigned(FListaCofres) then
  begin
    FListaCofres    := TObjectList<TCofre>.Create;
    FListaCofresIDX := TListaIterator<TCofre>.Create(FListaCofres);
  end;

  Result := FListaCofresIDX;
end;

function Td4signAPI.readDocumentos: TListaIterator<TDocumento>;
begin
  if not Assigned(FListaDocumentos) then
  begin
    FListaDocumentos    := TObjectList<TDocumento>.Create;
    FListaDocumentosIDX := TListaIterator<TDocumento>.Create(FListaDocumentos);
  end;

  Result := FListaDocumentosIDX;
end;

function Td4signAPI.readSignatarios: TListaIterator<TSignatario>;
begin
  if not Assigned(FListaSignatarios) then
  begin
    FListaSignatarios    := TObjectList<TSignatario>.Create;
    FListaSignatariosIDX := TListaIterator<TSignatario>.Create(FListaSignatarios);
  end;

  Result := FListaSignatariosIDX;
end;

function Td4signAPI.RetornaMimeType(pArquivo: string): string;
const
  vTiposAceitos: array of string = ['.pdf', '.doc', '.docx', '.jpg', '.png', '.bmp'];
var
  vMimeType: string;
begin
  case AnsiIndexText(ExtractFileExt(pArquivo), vTiposAceitos) of
    0: // pdf
    begin
      vMimeType := 'application/pdf';
    end;
    1: // doc
    begin
      vMimeType := 'application/msword';
    end;
    2: // docx
    begin
      vMimeType := 'application/msword';
    end;
    3: // jpg
    begin
      vMimeType := 'image/jpeg';
    end;
    4: // png
    begin
      vMimeType := 'image/png';
    end;
    5: // bmp
    begin
      vMimeType := 'image/bmp';
    end;
  end;

  Result := vMimeType
end;

procedure Td4signAPI.SetcryptKey(const Value: string);
begin
  FcryptKey := Value;
end;

procedure Td4signAPI.SettokenAPI(const Value: string);
begin
  FtokenAPI := Value;
end;

function Td4signAPI.SignatarioSemKey(pEmail: string): TSignatario;
var
  vSignatario: TSignatario;
  vDocumentoGerenciado: TDocumentoGerenciado;
begin
  vSignatario := nil;

  for vDocumentoGerenciado in DocumentosGerenciados do
  begin
    if Documentos.Atual.uuidDoc = ListaDocumentos[vDocumentoGerenciado.documento_idx].uuidDoc then
    begin
      if (AnsiSameText(ListaSignatarios[vDocumentoGerenciado.signatario_idx].email,pEmail) and (ListaSignatarios[vDocumentoGerenciado.signatario_idx].key_signer.Trim='')) then
      begin
        vSignatario := ListaSignatarios[vDocumentoGerenciado.signatario_idx];
      end;
    end;
  end;

  Result := vSignatario
end;

function Td4signAPI.SignatarioAdicionar: Boolean;
var
  vSucesso      : Boolean;
  vURL          : string;
  vBody         : TStringStream;
  vResposta     : TStringStream;
  vObjJson      : TJSONObject;
  vJsonArray    : TJSONArray;
  vRespostaJson : TJSONObject;
  vRespostaArray: TJSONArray;
begin
  vSucesso         := False;
  FMensagemRetorno := '';
  ValidarUso;

  if Signatarios.Atual.key_signer.Trim.Length <> 0 then
    raise Exception.Create('O signatário já está vinculado.');

  if Documentos.Atual.uuidDoc.Trim.Length = 0 then
    raise Exception.Create('É necessário o documento principal existir.');

  if (Signatarios.Atual.email.Trim.Length = 0) or (Signatarios.Atual.act = sig_act_invalido) then
  begin
    FStatusCode := 3;
    raise Exception.Create('Os campos email, act, foreign, certificadoicpbr, assinatura_presencial são obrigatórios.');
  end;

  vURL := url_base + 'documents/' + Documentos.Atual.uuidDoc + '/createlist?' + url_validacao;

  try
    vObjJson   := TJSONObject.Create;
    vJsonArray := TJSONArray.Create;
    vObjJson.AddPair('signers', vJsonArray.Add(TJson.ObjectToJsonObject(Signatarios.Atual)));

    vBody     := TStringStream.Create(vObjJson.ToString, TEncoding.UTF8);
    vResposta := TStringStream.Create;
  finally
    FreeAndNil(vObjJson);
  end;

  try
    command.ContentType := 'application/json';
    FStatusCode         := command.Post(vURL, vBody, vResposta).StatusCode;
    LogEndpoint(nil,vResposta,vURL,FStatusCode);
    case FStatusCode of
      200:
      begin
        vSucesso := True;
      end;
    else
    begin
      ProcessarRetorno(vResposta);
      vSucesso := False;
    end;
    end;
  except
    on E: Exception do
    begin
      FStatusCode := 1;
      vSucesso    := False;
    end;
  end;

  if vSucesso then
  begin
    try
      vRespostaJson := TJSONObject.ParseJSONValue(vResposta.DataString) as TJSONObject;

      if not vRespostaJson.GetValue('message').Null then
      begin
        vRespostaArray := vRespostaJson.GetValue('message') as TJSONArray;
        if vRespostaArray.Count = 1 then
        begin
          Signatarios.Atual.key_signer := vRespostaArray.Items[0].GetValue<string>('key_signer');
        end;
      end;
    finally
      FreeAndNil(vRespostaJson);
    end;
  end;

  command.ContentType := '';
  vBody.Clear;
  FreeAndNil(vBody);
  vResposta.Clear;
  FreeAndNil(vResposta);
  GerarListagemSignatarioTMP;

  Result := vSucesso;
end;

function Td4signAPI.url_base: string;
begin
  Result := FurlAPI;
end;

function Td4signAPI.url_validacao: string;
begin
  Result := 'tokenAPI=' + tokenAPI + '&cryptKey=' + cryptKey;
end;

procedure Td4signAPI.ValidarUso;
begin
  if tokenAPI.Trim.Length = 0 then
    raise Exception.Create('Informe o token');

  if cryptKey.Trim.Length = 0 then
    raise Exception.Create('Informe o chave');
end;

{ TListaIterator<T> }

function TListaIterator<T>.Atual: T;
begin
  if Fim then
    Result := FLista.Last
  else
    Result := FLista[FIDX];
end;

constructor TListaIterator<T>.Create(pLista: TObjectList<T>);
begin
  FLista := pLista;
end;

function TListaIterator<T>.Fim: Boolean;
begin
  Result := FIDX = FLista.Count;
end;

function TListaIterator<T>.Idx(pIDX: Integer = -1): Integer;
begin
  if pIDX <> -1 then
    FIDX := pIDX;

  Result := FIDX;
end;

procedure TListaIterator<T>.Primeiro;
begin
  FIDX := 0;
end;

procedure TListaIterator<T>.Proximo;
begin
  if FIDX < FLista.Count then
    Inc(FIDX);
end;

procedure TListaIterator<T>.Ultimo;
begin
  FIDX := FLista.Count - 1;
end;

{ TDocumentoGerenciado }

procedure TDocumentoGerenciado.Setcofre_idx(const Value: Integer);
begin
  Fcofre_idx := Value;
end;

procedure TDocumentoGerenciado.Setdocumento_idx(const Value: Integer);
begin
  Fdocumento_idx := Value;
end;

procedure TDocumentoGerenciado.Setsignatario_idx(const Value: Integer);
begin
  Fsignatario_idx := Value;
end;

initialization

vgAPI := Td4signAPI.Create();

end.
