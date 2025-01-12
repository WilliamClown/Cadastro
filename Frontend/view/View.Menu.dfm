object FormMenu: TFormMenu
  Left = 0
  Top = 0
  Caption = 'Pessoas'
  ClientHeight = 690
  ClientWidth = 1208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 1208
    Height = 690
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 1128
    object pnlTitulo: TPanel
      Left = 0
      Top = 0
      Width = 1208
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Projeto Cadastro de Pessoas'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowFrame
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 1128
    end
    object pnlBotoes: TPanel
      Left = 0
      Top = 57
      Width = 1208
      Height = 72
      Align = alTop
      BevelOuter = bvNone
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Padding.Left = 10
      Padding.Top = 10
      Padding.Right = 10
      Padding.Bottom = 10
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      ExplicitWidth = 1128
      object pnlBotaoNovo: TPanel
        Left = 634
        Top = 22
        Width = 135
        Height = 41
        BevelOuter = bvNone
        Caption = 'NOVO'
        Color = 9240460
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = pnlBotaoNovoClick
      end
      object pnlBotaoEditar: TPanel
        Left = 775
        Top = 22
        Width = 135
        Height = 41
        BevelOuter = bvNone
        Caption = 'EDITAR'
        Color = 7733247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnClick = pnlBotaoEditarClick
      end
      object pnlBotaoExcluir: TPanel
        Left = 916
        Top = 22
        Width = 135
        Height = 41
        BevelOuter = bvNone
        Caption = 'EXCLUIR'
        Color = 5460991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnClick = pnlBotaoExcluirClick
      end
      object pnlBotaoAtualizarCEP: TPanel
        Left = 1057
        Top = 22
        Width = 135
        Height = 41
        BevelOuter = bvNone
        Caption = 'ATUALIZAR CEP LOTE'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        Padding.Left = 5
        Padding.Top = 5
        Padding.Right = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        OnClick = pnlBotaoAtualizarCEPClick
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 672
      Width = 1208
      Height = 18
      Align = alBottom
      BevelOuter = bvNone
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      ExplicitWidth = 1128
    end
    object pnlRight: TPanel
      Left = 1192
      Top = 129
      Width = 16
      Height = 543
      Align = alRight
      BevelOuter = bvNone
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Padding.Left = 10
      Padding.Top = 10
      Padding.Right = 10
      Padding.Bottom = 10
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      ExplicitLeft = 1112
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 129
      Width = 16
      Height = 543
      Align = alLeft
      BevelOuter = bvNone
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Padding.Left = 10
      Padding.Top = 10
      Padding.Right = 10
      Padding.Bottom = 10
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
    end
    object pnlSeparador: TPanel
      Left = 0
      Top = 49
      Width = 1208
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
      ExplicitWidth = 1128
    end
    object DBGDados: TDBGrid
      Left = 16
      Top = 129
      Width = 1176
      Height = 543
      Align = alClient
      TabOrder = 6
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object pnlStatusAtualizacao: TPanel
      Left = 400
      Top = 324
      Width = 433
      Height = 93
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      TabOrder = 7
      Visible = False
      object lblTituloStatus: TLabel
        Left = 0
        Top = 8
        Width = 433
        Height = 21
        Alignment = taCenter
        Caption = 'Realizando atualiza'#231#227'o em lote de endere'#231'os'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblStatus: TLabel
        Left = 0
        Top = 48
        Width = 433
        Height = 21
        Alignment = taCenter
        Caption = 'quantidade'
      end
    end
  end
  object dsDados: TDataSource
    Left = 576
    Top = 440
  end
end
