object AboutForm: TAboutForm
  Height = 330
  Width = 440
  BorderStyle = bsToolWindow
  Caption = 'About Hello World'
  ClientHeight = 255
  ClientWidth = 335
  Font.Height = -12
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  object Panel1: TPanel
    Align = alClient
    object Label1: TLabel
      Left = 60
      Height = 24
      Top = 24
      Alignment = taCenter
      Caption = 'Example plugin'
    end
    object Label2: TLabel
      Left = 38
      Height = 80
      Top = 66
      Alignment = taCenter
      Caption = 'Damjan Zobo Cvetko, zobo@users.sf.net'
    end
    object Label3: TLabel
      Left = 96
      Height = 80
      Top = 128
      Alignment = taCenter
    end
    object Button1: TButton
      Left = 130
      Height = 24
      Top = 216
      Width = 72
      Font.Height = -10
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      ParentFont = false
    end
  end
end
