object frmEmbeddingSearch: TfrmEmbeddingSearch
  Left = 0
  Top = 0
  Caption = 'Embedding Search'
  ClientHeight = 524
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 579
    Top = 64
    Height = 330
    Align = alRight
    ExplicitLeft = 392
    ExplicitTop = 232
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 394
    Width = 767
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 64
    ExplicitWidth = 333
  end
  object PanelSearch: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 761
    Height = 58
    Align = alTop
    TabOrder = 0
    object CheckBoxMeaning: TCheckBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 753
      Height = 17
      Align = alTop
      Caption = 'Search by meaning'
      TabOrder = 0
      ExplicitLeft = 336
      ExplicitTop = 32
      ExplicitWidth = 97
    end
    object EditSearch: TEdit
      AlignWithMargins = True
      Left = 6
      Top = 29
      Width = 749
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 1
      TextHint = 'Your search here...'
      OnKeyDown = EditSearchKeyDown
      ExplicitLeft = 320
      ExplicitTop = 24
      ExplicitWidth = 121
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 67
    Width = 573
    Height = 324
    Align = alClient
    DataSource = dtsMovies
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 582
    Top = 64
    Width = 185
    Height = 330
    Align = alRight
    TabOrder = 2
    ExplicitLeft = 296
    ExplicitTop = 264
    ExplicitHeight = 41
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 183
      Height = 328
      Align = alClient
      Proportional = True
      ExplicitLeft = 3
      ExplicitTop = 176
      ExplicitWidth = 142
      ExplicitHeight = 169
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 400
    Width = 761
    Height = 121
    Align = alBottom
    TabOrder = 3
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 759
      Height = 41
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 288
      ExplicitTop = 40
      ExplicitWidth = 185
      object ButtonWriteEmail: TButton
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 93
        Height = 33
        Align = alLeft
        Caption = 'Write Email'
        TabOrder = 0
        OnClick = ButtonWriteEmailClick
      end
    end
    object MemoEmail: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 45
      Width = 753
      Height = 72
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 288
      ExplicitTop = 16
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
  object dtsMovies: TDataSource
    DataSet = memMovies
    Left = 376
    Top = 264
  end
  object memMovies: TFDMemTable
    AfterScroll = memMoviesAfterScroll
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 520
    Top = 264
    object memMovies_id: TStringField
      FieldName = '_id'
      Visible = False
    end
    object memMoviestitle: TStringField
      DisplayWidth = 30
      FieldName = 'title'
      Size = 255
    end
    object memMoviesplot: TStringField
      DisplayWidth = 50
      FieldName = 'plot'
      Size = 255
    end
    object memMoviesposter: TStringField
      DisplayWidth = 30
      FieldName = 'poster'
      Size = 255
    end
  end
  object RESTClient1: TRESTClient
    BaseURL = 'http://localhost:8800/api/movies'
    Params = <>
    SynchronizedEvents = False
    Left = 80
    Top = 184
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmPOST
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 136
    Top = 248
  end
  object RESTResponse1: TRESTResponse
    Left = 184
    Top = 192
  end
  object TimerOpen: TTimer
    OnTimer = TimerOpenTimer
    Left = 472
    Top = 120
  end
  object RESTClient2: TRESTClient
    BaseURL = 'http://localhost:8800/api/embedded_movies'
    Params = <>
    SynchronizedEvents = False
    Left = 376
    Top = 392
  end
  object RESTRequest2: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient2
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body8F124DA82E6E472D8B3FFC7CC2D91D71'
        Value = 
          '{ "search": "A story about a robot learning to understand human ' +
          'emotions" }'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponse2
    SynchronizedEvents = False
    Left = 424
    Top = 456
  end
  object RESTResponse2: TRESTResponse
    Left = 480
    Top = 392
  end
  object NetHTTPClient1: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 368
    Top = 168
  end
  object RESTClient3: TRESTClient
    BaseURL = 'http://localhost:8800/api/movies_email'
    Params = <>
    SynchronizedEvents = False
    Left = 128
    Top = 384
  end
  object RESTRequest3: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient3
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'bodyA44C0F2738444CFF9DD3FBF518058317'
        Value = 
          '{ "search": "A story about a robot learning to understand human ' +
          'emotions" }'
        ContentTypeStr = 'application/json'
      end>
    Response = RESTResponse3
    SynchronizedEvents = False
    Left = 136
    Top = 392
  end
  object RESTResponse3: TRESTResponse
    Left = 144
    Top = 400
  end
end
