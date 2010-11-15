object FrmTabel: TFrmTabel
  Left = 192
  Top = 107
  Width = 870
  Height = 500
  Caption = 'FrmTabel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sg: TStringGrid
    Left = 0
    Top = 41
    Width = 862
    Height = 432
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object od: TOpenDialog
    Left = 96
    Top = 8
  end
end
