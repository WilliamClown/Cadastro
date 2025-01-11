object FrmServidor: TFrmServidor
  Left = 0
  Top = 0
  Caption = 'Servidor'
  ClientHeight = 600
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 872
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTitulo: TPanel
      Left = 0
      Top = 0
      Width = 872
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Servidor de Aplica'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object pnConfiguracaoConexao: TPanel
      Left = 0
      Top = 45
      Width = 872
      Height = 154
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object imgBase: TImage
        Left = 10
        Top = 0
        Width = 48
        Height = 48
        AutoSize = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
          003008060000005702F987000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
          C14944415478DAEDD6B10DC2400C05509B25AE08B002D727A246CC014B651268
          490648582142220C814993160A2B677CFABF76F15F637D26E761EB0200581700
          C0BA0000BF0EEEEDEB28F2AE89B948DA4CE421C2A7B80F1715A06B9E0333AF93
          969F0D4443ACC25605E8DB512CCACFD955E16B47000000207780FB37DADDC603
          ADA89E0E37A9CB4FEDCEB10C5715E0DF933F005B4863C01602000000FC03DCBF
          516CA185933F005B4863C01602000000FC03DCBF516CA18503807500B00E00D6
          F90028D5A8312B45DAA20000000049454E44AE426082}
      end
      object lblTituloConexao: TLabel
        Left = 64
        Top = 35
        Width = 112
        Height = 17
        Caption = 'Dados da Conex'#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblServidor: TLabel
        Left = 10
        Top = 63
        Width = 52
        Height = 17
        Caption = 'Servidor:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblPortaBase: TLabel
        Left = 182
        Top = 63
        Width = 34
        Height = 17
        Caption = 'Porta:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblBase: TLabel
        Left = 354
        Top = 63
        Width = 99
        Height = 17
        Caption = 'Banco de Dados:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblusuario: TLabel
        Left = 526
        Top = 63
        Width = 48
        Height = 17
        Caption = 'Usu'#225'rio:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblSenha: TLabel
        Left = 698
        Top = 63
        Width = 38
        Height = 17
        Caption = 'Senha:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtServidor: TEdit
        Left = 10
        Top = 83
        Width = 166
        Height = 21
        TabOrder = 0
      end
      object edtPortaBase: TEdit
        Left = 182
        Top = 83
        Width = 166
        Height = 21
        TabOrder = 1
      end
      object edtBase: TEdit
        Left = 354
        Top = 83
        Width = 166
        Height = 21
        TabOrder = 2
      end
      object edtUsuario: TEdit
        Left = 526
        Top = 83
        Width = 166
        Height = 21
        TabOrder = 3
      end
      object edtSenha: TEdit
        Left = 698
        Top = 83
        Width = 166
        Height = 21
        TabOrder = 4
      end
      object pnBotaoGravarINI: TPanel
        Left = 340
        Top = 123
        Width = 165
        Height = 25
        Caption = 'Gravar INI'
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
        OnClick = pnBotaoGravarINIClick
      end
    end
    object pnlAcoes: TPanel
      Left = 0
      Top = 299
      Width = 872
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      Padding.Left = 10
      Padding.Right = 10
      Padding.Bottom = 10
      TabOrder = 2
      object pnBotaoDesinstalarServico: TPanel
        Left = 658
        Top = 14
        Width = 210
        Height = 25
        Caption = 'Desisntalar Servi'#231'o'
        Color = clSkyBlue
        ParentBackground = False
        TabOrder = 0
        OnClick = pnBotaoDesinstalarServicoClick
      end
      object pnBotaoInstalarServico: TPanel
        Left = 442
        Top = 14
        Width = 210
        Height = 25
        Caption = 'Instalar Servi'#231'o'
        Color = clSkyBlue
        ParentBackground = False
        TabOrder = 1
        OnClick = pnBotaoInstalarServicoClick
      end
      object pnBotaoPararServico: TPanel
        Left = 226
        Top = 14
        Width = 210
        Height = 25
        Caption = 'Parar Servi'#231'o'
        Color = clSkyBlue
        ParentBackground = False
        TabOrder = 2
        OnClick = pnBotaoPararServicoClick
      end
      object pnBotaoIniciarServico: TPanel
        Left = 10
        Top = 14
        Width = 210
        Height = 25
        Caption = 'Iniciar Servi'#231'o'
        Color = clSkyBlue
        ParentBackground = False
        TabOrder = 3
        OnClick = pnBotaoIniciarServicoClick
      end
    end
    object pnConfiguracaoAPI: TPanel
      Left = 0
      Top = 199
      Width = 872
      Height = 100
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object lblPortaAPI: TLabel
        Left = 10
        Top = 40
        Width = 56
        Height = 17
        Caption = 'Porta API:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblTituloAPI: TLabel
        Left = 336
        Top = 6
        Width = 196
        Height = 31
        Caption = 'Inicializa'#231#227'o da API'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtPortaAPI: TEdit
        Left = 10
        Top = 60
        Width = 166
        Height = 21
        TabOrder = 0
      end
      object pnBotaoIniciarAPI: TPanel
        Left = 192
        Top = 60
        Width = 165
        Height = 25
        Caption = 'Iniciar'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnClick = pnBotaoIniciarAPIClick
      end
      object pnBotaoPararAPI: TPanel
        Left = 363
        Top = 60
        Width = 165
        Height = 25
        Caption = 'Parar'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnClick = pnBotaoPararAPIClick
      end
    end
    object pnLog: TPanel
      Left = 0
      Top = 356
      Width = 872
      Height = 244
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      object memLog: TMemo
        Left = 0
        Top = 0
        Width = 872
        Height = 244
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
  end
end
