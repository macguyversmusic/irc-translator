object Form1: TForm1
  Left = 192
  Top = 114
  BorderStyle = bsSingle
  Caption = ':: zonk : Bot ::'
  ClientHeight = 443
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 350
    Width = 462
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 462
    Height = 74
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 88
    Width = 462
    Height = 256
    Lines.Strings = (
      'Memo2')
    TabOrder = 2
  end
  object cs: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = csConnect
    OnDisconnect = csDisconnect
    OnRead = csRead
    OnError = csError
    Left = 8
    Top = 408
  end
  object Timer1: TTimer
    Enabled = False
    Left = 48
    Top = 408
  end
  object MainMenu1: TMainMenu
    Left = 103
    Top = 396
    object Main1: TMenuItem
      Caption = 'Main'
      object Start1: TMenuItem
        Caption = 'Start'
        OnClick = Start1Click
      end
      object Stop1: TMenuItem
        Caption = 'Stop'
        OnClick = Stop1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
    object N2: TMenuItem
      Caption = '?'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
end
