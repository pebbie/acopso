object FrmSetting: TFrmSetting
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'FrmSetting'
  ClientHeight = 96
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 200
    Top = 8
    Width = 185
    Height = 81
    Caption = 'Node'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 70
      Height = 13
      Caption = 'Default Radius'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 63
      Height = 13
      Caption = 'Default Prefix'
    end
    object DefRadius: TSpinEdit
      Left = 88
      Top = 16
      Width = 89
      Height = 22
      Increment = 5
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 65
    end
    object DefPrefix: TEdit
      Left = 88
      Top = 48
      Width = 89
      Height = 21
      TabOrder = 1
      Text = 'node'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 81
    Caption = 'General'
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 103
      Height = 13
      Caption = 'Default Num. of Node'
    end
    object DefNumNode: TSpinEdit
      Left = 120
      Top = 16
      Width = 57
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 16
    end
  end
  object Button1: TButton
    Left = 392
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
end
