object FormPessoa: TFormPessoa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FormPessoa'
  ClientHeight = 547
  ClientWidth = 943
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 943
    Height = 547
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 20
    Padding.Top = 20
    Padding.Right = 20
    Padding.Bottom = 20
    ParentBackground = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 20
      Top = 20
      Width = 903
      Height = 41
      Align = alTop
      Caption = 'Cadastro de Pessoa'
      Color = clMedGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object Panel6: TPanel
      Left = 20
      Top = 61
      Width = 903
      Height = 12
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 20
      Top = 468
      Width = 903
      Height = 59
      Align = alBottom
      BevelOuter = bvNone
      Color = 14605788
      Padding.Left = 10
      Padding.Top = 10
      Padding.Right = 10
      Padding.Bottom = 10
      ParentBackground = False
      TabOrder = 2
      object pnlGerarLoteCadastro: TPanel
        Left = 10
        Top = 10
        Width = 159
        Height = 39
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'GERAR LOTE CADASTRO'
        Color = clGradientActiveCaption
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnlGerarLoteCadastroClick
      end
      object pnlFechar: TPanel
        Left = 766
        Top = 10
        Width = 127
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        Caption = 'FECHAR'
        Color = 5460991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnClick = pnlFecharClick
      end
      object pnlSalvar: TPanel
        Left = 629
        Top = 10
        Width = 127
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        Caption = 'SALVAR'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnClick = pnlSalvarClick
      end
      object Panel13: TPanel
        Left = 756
        Top = 10
        Width = 10
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 3
      end
      object Panel14: TPanel
        Left = 619
        Top = 10
        Width = 10
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 4
      end
    end
    object Panel5: TPanel
      Left = 20
      Top = 201
      Width = 903
      Height = 12
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
    end
    object Panel3: TPanel
      Left = 20
      Top = 73
      Width = 903
      Height = 128
      Align = alTop
      BevelOuter = bvNone
      Color = 14605788
      ParentBackground = False
      TabOrder = 4
      object Label1: TLabel
        Left = 16
        Top = 47
        Width = 46
        Height = 21
        Caption = 'Nome:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 231
        Top = 47
        Width = 84
        Height = 21
        Caption = 'Sobrenome:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 439
        Top = 47
        Width = 84
        Height = 21
        Caption = 'Documento:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtNome: TEdit
        Left = 16
        Top = 74
        Width = 209
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtSobrenome: TEdit
        Left = 231
        Top = 74
        Width = 202
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edtDocumento: TEdit
        Left = 439
        Top = 74
        Width = 202
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object Panel11: TPanel
        Left = 0
        Top = 0
        Width = 903
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'DADOS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object Panel7: TPanel
      Left = 20
      Top = 213
      Width = 903
      Height = 248
      Align = alTop
      BevelOuter = bvNone
      Color = 14605788
      ParentBackground = False
      TabOrder = 5
      object Label6: TLabel
        Left = 16
        Top = 47
        Width = 30
        Height = 21
        Caption = 'Cep:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 231
        Top = 47
        Width = 85
        Height = 21
        Caption = 'Logradouro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 439
        Top = 47
        Width = 45
        Height = 21
        Caption = 'Bairro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 647
        Top = 47
        Width = 51
        Height = 21
        Caption = 'Cidade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 16
        Top = 106
        Width = 22
        Height = 21
        Caption = 'UF:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 231
        Top = 106
        Width = 102
        Height = 21
        Caption = 'Complemento:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtCep: TEdit
        Left = 16
        Top = 74
        Width = 209
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnExit = edtCepExit
      end
      object edtLogradouro: TEdit
        Left = 231
        Top = 74
        Width = 202
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edtBairro: TEdit
        Left = 439
        Top = 74
        Width = 202
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edtCidade: TEdit
        Left = 647
        Top = 74
        Width = 202
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object edtUf: TEdit
        Left = 16
        Top = 132
        Width = 209
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object Panel12: TPanel
        Left = 0
        Top = 0
        Width = 903
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'ENDERE'#199'O'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
      object edtComplemento: TEdit
        Left = 231
        Top = 132
        Width = 209
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
    end
  end
end
