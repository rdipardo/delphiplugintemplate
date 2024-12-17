object HelloWorldModelessForm: TModelessForm
  BorderStyle = bsDialog
  Caption = 'Modeless Dialog'
  ClientHeight = 188
  ClientWidth = 204
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  ExplicitWidth = 226
  ExplicitHeight = 244
  TextHeight = 13
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  object Button1: TButton
    Left = 64
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Learn More'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 185
    Height = 89
    Lines.Strings = (
      '1. CTRL+A'
      '2. CTRL+X'
      '3. CTRL+V'
      ''
      'All working?'
    )
    TabOrder = 0
  end
end
