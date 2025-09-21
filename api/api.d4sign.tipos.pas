unit api.d4sign.tipos;

interface

type
  TSignatario_act = (
    // 0 = INVALIDO
    sig_act_invalido,
    // 1 = Assinar
    sig_act_assinar,
    // 2 = Aprovar
    sig_act_aprovar,
    // 3 = Reconhecer
    sig_act_reconhecer,
    // 4 = Assinar como parte
    sig_act_assinar_parte,
    // 5 = Assinar como testemunha
    sig_act_assinar_testemunha,
    // 6 = Assinar como interveniente
    sig_act_assinar_interveniente,
    // 7 = Acusar recebimento
    sig_act_acusar_recebimento,
    // 8 = Assinar como Emissor, Endossante e Avalista
    sig_act_assinar_emissor_endossante_avalista,
    // 9 = Assinar como Emissor, Endossante, Avalista, Fiador
    sig_act_assinar_emissor_endossante_avalista_fiador,
    // 10 = Assinar como fiador
    sig_act_assinar_fiador,
    // 11 = Assinar como parte e fiador
    sig_act_assinar_parte_fiador,
    // 12 = Assinar como respons�vel solid�rio
    sig_act_assinar_responsavel_solidario,
    // 13 = Assinar como parte e respons�vel solid�rio
    sig_act_assinar_parte_responsavel_solidario);

  TSignatario_foreign = (
    // 0 = Possui CPF (Brasileiro).
    sig_foreign_possui_CPF,
    // 1 = N�o possui CPF (Estrangeiro).
    sig_foreign_nao_possui_CPF);

  TSignatario_foreign_lang = (
    // en = Ingl�s (US)
    sig_foreign_lang_en,
    // es = Espanhol
    sig_foreign_lang_es,
    // ptBR = Portugu�s
    sig_foreign_lang_pt_BR);

  TSignatario_certificadoicpbr = (
    // 0 = Ser� efetuada a assinatura padr�o da D4Sign.
    sig_certificadoicpbr_padrao_d4sign,
    // 1 = Ser� efetuada a assinatura com um Certificado Digital ICP-Brasil.
    sig_certificadoicpbr_ICP_Brasil);

  TSignatario_assinatura_presencial = (
    // 0 = N�o ser� efetuada a assinatura presencial.
    sig_assinatura_presencial_nao,
    // 1 = Ser� efetuada a assinatura presencial.
    sig_assinatura_presencial_sim);

  TSignatario_docauth = (
    // 1 = Ser� efetuada a assinatura exigindo um documento com foto.
    sig_docauth_documento_foto,
    // 0 = N�o ser� efetuada a assinatura exigindo um documento com foto.
    sig_docauth_sem_documento_foto);

  TSignatario_docauthandselfie = (
    // 1 = Ser� efetuada a assinatura exigindo um documento com foto e uma selfie segurando o documento.
    sig_docauthandselfie_documento_foto_selfie,
    // 0 = N�o ser� efetuada a assinatura exigindo um documento com foto e uma selfie segurando o documento.
    sig_docauthandselfie_sem_documento_foto_selfie);

  TSignatario_embed_methodauth = (
    // email = O token ser� enviado por e-mail
    sig_embed_methodauth_email,
    // password = Caso o signat�rio j� possua uma conta D4Sign, ser� exigida a senha da conta.
    sig_embed_methodauth_password,
    // sms = O token ser� enviado por SMS (para utilizar essa op��o entre em contato com a equipe comercial da D4Sign)
    sig_embed_methodauth_sms,
    // whats = O token ser� enviado por WhatsApp (para utilizar essa op��o entre em contato com a equipe comercial da D4Sign)
    sig_embed_methodauth_whats);

  TSignatario_certificadoicpbr_tipo = (
    // 0 = Nenhum
    sig_certificadoicpbr_tipo_nenhum,
    // 1 = Qualquer certificado
    sig_certificadoicpbr_tipo_qualquer,
    // 2 = e-CPF
    sig_certificadoicpbr_tipo_cpf,
    // 3 = e-CNPJ
    sig_certificadoicpbr_tipo_cnpj);

  TDocumentoFase = (doc_fase_todos,
    // ID 1 - Processando
    doc_fase_processando,
    // ID 2 - Aguardando Signat�rios
    doc_aguardando_signatarios,
    // ID 3 - Aguardando Assinaturas
    doc_fase_aguardando_assinatura,
    // ID 4 - Finalizado
    doc_fase_finalizado,
    // ID 5 - Arquivado
    doc_fase_arquivado,
    // ID 6 - Cancelado
    doc_fase_cancelado);

implementation

end.