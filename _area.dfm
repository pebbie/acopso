object FrmArea: TFrmArea
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'FrmArea'
  ClientHeight = 73
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 27
    Top = 16
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Width'
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = 'Height'
  end
  object spWidth: TSpinEdit
    Left = 64
    Top = 8
    Width = 121
    Height = 22
    Increment = 5
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 385
  end
  object spHeight: TSpinEdit
    Left = 64
    Top = 40
    Width = 121
    Height = 22
    Increment = 5
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 500
  end
  object Button1: TButton
    Left = 192
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
end
