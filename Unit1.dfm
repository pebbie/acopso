object Form1: TForm1
  Left = 192
  Top = 107
  Width = 870
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 0
    Top = 331
    Width = 862
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object sga: TStringGrid
    Left = 0
    Top = 334
    Width = 862
    Height = 120
    Align = alBottom
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnSetEditText = sgaSetEditText
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 862
    Height = 290
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 365
      Top = 1
      Height = 288
      Align = alRight
    end
    object ScrollBox1: TScrollBox
      Left = 1
      Top = 1
      Width = 364
      Height = 288
      Align = alClient
      TabOrder = 0
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 105
        Height = 105
        AutoSize = True
        OnMouseDown = Image1MouseDown
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
      end
    end
    object Panel3: TPanel
      Left = 368
      Top = 1
      Width = 493
      Height = 288
      Align = alRight
      Caption = 'Panel3'
      TabOrder = 1
      object Memo1: TMemo
        Left = 1
        Top = 42
        Width = 491
        Height = 245
        Align = alClient
        TabOrder = 0
        WordWrap = False
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 491
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Button5: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Save Log'
          TabOrder = 0
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 104
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Clear Log'
          TabOrder = 1
          OnClick = Button6Click
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 41
    Top = 162
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Impor1: TMenuItem
        Caption = 'Impor'
        object sensorPSO2: TMenuItem
          Caption = 'sensorPSO'
          OnClick = sensorPSO2Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
    object Config1: TMenuItem
      Caption = 'Config'
      object argetArea1: TMenuItem
        Caption = 'Target Area'
        OnClick = argetArea1Click
      end
      object Settings1: TMenuItem
        Caption = 'Settings'
        OnClick = Settings1Click
      end
    end
    object Placement1: TMenuItem
      Caption = 'Placement'
      object PSO1: TMenuItem
        Caption = 'PSO'
        OnClick = PSO1Click
      end
      object sensorPSO1: TMenuItem
        Caption = 'sensorPSO'
        Visible = False
      end
    end
    object Routing1: TMenuItem
      Caption = 'Routing'
      object ACO1: TMenuItem
        Caption = 'ACO'
        OnClick = ACO1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 400
    object Add1: TMenuItem
      Caption = 'Add'
      OnClick = Add1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object sd: TSaveDialog
    Left = 73
    Top = 162
  end
  object od: TOpenDialog
    Left = 105
    Top = 162
  end
end
