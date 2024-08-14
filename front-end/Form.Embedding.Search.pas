unit Form.Embedding.Search;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ExtCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Json, System.JSON, Generics.Collections,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Vcl.Imaging.jpeg,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TMovie = class
  private
    FId: string;
    FTitle: string;
    FPlot: string;
    FPoster: string;
  public
    property Id: string read FId write FId;
    property Title: string read FTitle write FTitle;
    property Plot: string read FPlot write FPlot;
    property Poster: string read FPoster write FPoster;
  end;

  TMovies = class(TList<TMovie>)
  end;

  TfrmEmbeddingSearch = class(TForm)
    PanelSearch: TPanel;
    DBGrid1: TDBGrid;
    dtsMovies: TDataSource;
    memMovies: TFDMemTable;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    TimerOpen: TTimer;
    memMovies_id: TStringField;
    memMoviestitle: TStringField;
    memMoviesplot: TStringField;
    memMoviesposter: TStringField;
    CheckBoxMeaning: TCheckBox;
    EditSearch: TEdit;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    Panel1: TPanel;
    Image1: TImage;
    NetHTTPClient1: TNetHTTPClient;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    MemoEmail: TMemo;
    ButtonWriteEmail: TButton;
    RESTClient3: TRESTClient;
    RESTRequest3: TRESTRequest;
    RESTResponse3: TRESTResponse;
    Splitter2: TSplitter;
    procedure TimerOpenTimer(Sender: TObject);
    procedure EditSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memMoviesAfterScroll(DataSet: TDataSet);
    procedure ButtonWriteEmailClick(Sender: TObject);
  private
    { Private declarations }
    procedure SearchMovie;
  public
    { Public declarations }
  end;

var
  frmEmbeddingSearch: TfrmEmbeddingSearch;

implementation

{$R *.dfm}

procedure LoadImageFromURL(const URL: string; Image: TImage);
var
  MemoryStream: TMemoryStream;
  NetHTTPClient: TNetHTTPClient;
begin
  Image.Picture.Graphic := nil;

  MemoryStream := TMemoryStream.Create;
  NetHTTPClient := TNetHTTPClient.Create(nil);
  try
    NetHTTPClient.Get(URL, MemoryStream);
    MemoryStream.Position := 0;
    Image.Picture.Graphic := TJPEGImage.Create;
    Image.Picture.Graphic.LoadFromStream(MemoryStream);
  except
//    on E: Exception do
//      ShowMessage('Error loading image: ' + E.Message);
  end;
  MemoryStream.Free;
  NetHTTPClient.Free;
end;


procedure TfrmEmbeddingSearch.ButtonWriteEmailClick(Sender: TObject);
begin
  RESTRequest3.Params.Items[0].Value := '{ "search": "' + EditSearch.Text + '"}';
  RESTRequest3.Execute;

  MemoEmail.Text := RESTResponse3.Content;
end;

procedure TfrmEmbeddingSearch.EditSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SearchMovie;
  end;
end;

procedure TfrmEmbeddingSearch.memMoviesAfterScroll(DataSet: TDataSet);
begin
  if not memMovies.IsEmpty then
  begin
    if memMoviesposter.AsString <> '' then
    begin
      LoadImageFromURL(memMoviesposter.AsString, Image1);
    end;
  end;
end;

procedure TfrmEmbeddingSearch.SearchMovie;
begin
  memMovies.Filtered := False;
  memMovies.Filter := '';
  if CheckBoxMeaning.Checked then
  begin
    RESTRequest2.Params.Items[0].Value := '{ "search": "' + EditSearch.Text + '"}';
    RESTRequest2.Execute;

    var movs: TMovies := TJson.JsonToObject<TMovies>('{ "listHelper": ' + RESTResponse2.Content + '}');

    memMovies.Close;
    memMovies.Open;

    for var movie: TMovie in movs do
    begin
      memMovies.Append;
      memMovies_id.AsString := movie.Id;
      memMoviestitle.AsString := movie.Title;
      memMoviesplot.AsString := movie.Plot;
      memMoviesposter.AsString := movie.Poster;
      memMovies.Post;
    end;

    memMovies.First;

  end else begin
    if EditSearch.Text <> '' then
    begin
      memMovies.Filter := 'plot like '+ QuotedStr('%'+ EditSearch.Text + '%');
      memMovies.Filtered := True;
    end;
  end;
end;

procedure TfrmEmbeddingSearch.TimerOpenTimer(Sender: TObject);
begin
  TimerOpen.Enabled := False;

  RESTRequest1.Execute;
  var movs: TMovies := TJson.JsonToObject<TMovies>('{ "listHelper": ' + RESTResponse1.Content + '}');

  memMovies.Close;
  memMovies.Open;

  for var movie: TMovie in movs do
  begin
    memMovies.Append;
    memMovies_id.AsString := movie.Id;
    memMoviestitle.AsString := movie.Title;
    memMoviesplot.AsString := movie.Plot;
    memMoviesposter.AsString := movie.Poster;
    memMovies.Post;
  end;

  memMovies.First;
end;

end.
