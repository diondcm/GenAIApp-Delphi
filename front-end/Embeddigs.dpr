program Embeddigs;

uses
  Vcl.Forms,
  Form.Embedding.Search in 'Form.Embedding.Search.pas' {frmEmbeddingSearch};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmEmbeddingSearch, frmEmbeddingSearch);
  Application.Run;
end.
