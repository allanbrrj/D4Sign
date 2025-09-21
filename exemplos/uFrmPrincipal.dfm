object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'D4Sign exemplos'
  ClientHeight = 566
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 798
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 
      'Aten'#231#227'o antes de testar, fa'#231'a seu cadastro no site e obtenha seu' +
      ' o token e sua cryptkey.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 503
  end
  object Label5: TLabel
    Left = 8
    Top = 36
    Width = 158
    Height = 13
    Caption = 'Caminho tempor'#225'rio exporta'#231#227'o:'
  end
  object Label6: TLabel
    Left = 6
    Top = 382
    Width = 96
    Height = 13
    Caption = 'Informa'#231#245'es gerais:'
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 163
    Width = 398
    Height = 64
    Caption = 'Salvar documentos em:'
    TabOrder = 0
    object lblCofre: TLabel
      Left = 11
      Top = 17
      Width = 27
      Height = 13
      Caption = 'Cofre'
    end
    object cbxCofre: TComboBox
      Left = 11
      Top = 34
      Width = 222
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object btnCarregarCofre: TButton
      Left = 239
      Top = 34
      Width = 145
      Height = 22
      Caption = 'Carregar cofres da d4sign'
      TabOrder = 1
      OnClick = btnCarregarCofreClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 100
    Width = 783
    Height = 61
    Caption = 'Acesso:'
    TabOrder = 1
    object Label3: TLabel
      Left = 448
      Top = 18
      Width = 83
      Height = 13
      Caption = 'CryptKey d4sign:'
    end
    object Label1: TLabel
      Left = 11
      Top = 18
      Width = 67
      Height = 13
      Caption = 'Token d4sign:'
    end
    object edtCryptKeyd4sign: TEdit
      Left = 448
      Top = 33
      Width = 320
      Height = 21
      Hint = 'Infome sua CryptKey'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TextHint = 'Infome sua CryptKey'
      OnChange = edtCryptKeyd4signChange
    end
    object edtTokend4sign: TEdit
      Left = 11
      Top = 33
      Width = 430
      Height = 21
      Hint = 'Infome seu token'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TextHint = 'Infome seu token'
      OnChange = edtTokend4signChange
    end
  end
  object GroupBox9: TGroupBox
    Left = 6
    Top = 234
    Width = 784
    Height = 128
    Caption = 'Teste de ambiente: '
    TabOrder = 2
    object lblTesteFase: TLabel
      Left = 163
      Top = 14
      Width = 88
      Height = 13
      Caption = 'Somente o status:'
    end
    object btnCarregarDocumentos: TButton
      Left = 8
      Top = 25
      Width = 145
      Height = 25
      Caption = 'Carregar documentos'
      TabOrder = 0
      OnClick = btnCarregarDocumentosClick
    end
    object btnAdicionarDocumentoBin: TButton
      Left = 313
      Top = 10
      Width = 145
      Height = 25
      Caption = 'Adicionar documento Bin'
      TabOrder = 1
      OnClick = btnAdicionarDocumentoBinClick
    end
    object btnCancelarDocumento: TButton
      Left = 313
      Top = 67
      Width = 145
      Height = 25
      Caption = 'Cancelar documento'
      TabOrder = 2
      OnClick = btnCancelarDocumentoClick
    end
    object btnAdicionarSignatario: TButton
      Left = 467
      Top = 56
      Width = 145
      Height = 25
      Caption = 'Adicionar signat'#225'rio'
      TabOrder = 3
      OnClick = btnAdicionarSignatarioClick
    end
    object btnAdicionarAnexo: TButton
      Left = 467
      Top = 25
      Width = 145
      Height = 25
      Caption = 'Adicionar anexo'
      TabOrder = 4
      OnClick = btnAdicionarAnexoClick
    end
    object btnExibirSignatarios: TButton
      Left = 674
      Top = 36
      Width = 106
      Height = 25
      Caption = 'Exibir signat'#225'rios'
      TabOrder = 5
      OnClick = btnExibirSignatariosClick
    end
    object btnExibirDocumentos: TButton
      Left = 674
      Top = 10
      Width = 106
      Height = 25
      Caption = 'Exibir documentos'
      TabOrder = 6
      OnClick = btnExibirDocumentosClick
    end
    object btnCarregarSignatario: TButton
      Left = 8
      Top = 57
      Width = 145
      Height = 25
      Caption = 'Carregar signat'#225'rios'
      TabOrder = 7
      OnClick = btnCarregarSignatarioClick
    end
    object cbxFiltroFaseTeste: TComboBox
      Left = 159
      Top = 29
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 8
      Text = '00 - Todos'
      Items.Strings = (
        '00 - Todos'
        '01 - Processando'
        '02 - Aguardando Signat'#225'rios'
        '03 - Aguardando Assinaturas'
        '04 - Finalizado'
        '05 - Arquivado'
        '06 - Cancelado')
    end
    object btDisponibilizarDocumento: TButton
      Left = 313
      Top = 95
      Width = 145
      Height = 25
      Caption = 'Disponibilizar documento'
      TabOrder = 9
      OnClick = btDisponibilizarDocumentoClick
    end
    object btnCarregarCofres: TButton
      Left = 8
      Top = 89
      Width = 145
      Height = 25
      Caption = 'Carregar cofres'
      TabOrder = 10
      OnClick = btnCarregarCofresClick
    end
    object btnLimparTeste: TButton
      Left = 674
      Top = 62
      Width = 106
      Height = 25
      Caption = 'Limpar'
      TabOrder = 11
      OnClick = btnLimparTesteClick
    end
    object btnAdicionarDocumentoForm: TButton
      Left = 313
      Top = 39
      Width = 145
      Height = 25
      Caption = 'Adicionar documento Form'
      TabOrder = 12
      OnClick = btnAdicionarDocumentoFormClick
    end
  end
  object ckSalvarLogEndpoint: TCheckBox
    Left = 10
    Top = 16
    Width = 117
    Height = 17
    Caption = 'Salvar log endpoint'
    TabOrder = 3
  end
  object edtPathTempExport: TEdit
    Left = 8
    Top = 52
    Width = 240
    Height = 21
    TabOrder = 4
    Text = 'temp'
  end
  object btnAbrirDirTmp: TButton
    Left = 254
    Top = 51
    Width = 75
    Height = 23
    Caption = 'Abrir'
    TabOrder = 5
    OnClick = btnAbrirDirTmpClick
  end
  object memoInformacoes: TMemo
    Left = -1
    Top = 397
    Width = 799
    Height = 169
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object prgsBar: TProgressBar
    Left = -1
    Top = 549
    Width = 799
    Height = 17
    TabOrder = 7
  end
end
