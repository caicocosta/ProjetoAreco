unit ProdutosItens.CadCategorias;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Data.DB,
  Vcl.StdCtrls,
  ProdutosItens.Classes, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TFCadCategorias = class(TForm)
    pnNavigation: TPanel;
    btnNovo: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnAtualizar: TSpeedButton;
    btnSalvar: TSpeedButton;
    pn1: TPanel;
    lb1: TLabel;
    lb2: TLabel;
    lb3: TLabel;
    edtID: TEdit;
    edtCodigo: TEdit;
    edtNome: TEdit;
    lvCategoria: TListView;
    pn2: TPanel;
    btnOk: TBitBtn;
    btn1: TBitBtn;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure lvCategoriaClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    FCategoria: TCategoria;
  end;

var
  FCadCategorias: TFCadCategorias;

implementation

uses
  ProdutosItens.DMConexao, System.Generics.Collections;

{$R *.dfm}

procedure TFCadCategorias.btnAtualizarClick(Sender: TObject);
var
  LItens: TObjectList<TCategoria>;
  LItem: TCategoria;
  LListItem: TListItem;
begin
  LItens := DMConexao.GetAllCategorias;

  lvCategoria.Items.Clear;
  for LItem in LItens do
  begin
    LListItem := lvCategoria.Items.Add;
    LListItem.Caption := LItem.ID.ToString;
    LListItem.SubItems.Add(LItem.Codigo);
    LListItem.SubItems.Add(LItem.Nome);
  end;
  LItens.Free;
  if lvCategoria.Items.Count > 0 then
  begin
    lvCategoria.ItemIndex := 0;
    lvCategoriaClick(lvCategoria);
  end;
end;

procedure TFCadCategorias.btnExcluirClick(Sender: TObject);
begin
  FCategoria.ID     := StrToInt(edtID.Text);

  if Application.MessageBox('Tem certeza que deseja excluir essa categoria?', 'Excluir', mb_iconquestion +
                            mb_yesno) = idYes then
  begin
    if FCategoria.ID > 0 then
      FCategoria.ExcluirBancoDados(FCategoria.ID);

    btnAtualizar.Click;
  end else
    Abort;
end;

procedure TFCadCategorias.btnNovoClick(Sender: TObject);
begin
  FCategoria.ID := -1;
  edtID.Text := '-1';
  edtCodigo.Text := '';
  edtNome.TExt := '';
  edtCodigo.SetFocus;
end;

procedure TFCadCategorias.btnOkClick(Sender: TObject);
begin
  btnSalvar.Click;
end;

procedure TFCadCategorias.btnSalvarClick(Sender: TObject);
begin
  inherited;
  FCategoria.ID     := StrToInt(edtID.Text);
  FCategoria.Codigo := edtCodigo.Text;
  FCategoria.Nome   := edtNome.Text;
  FCategoria.SalvarBancoDados;
  btnAtualizar.Click;
  ShowMessage('Categoria Salva com Sucesso!');
end;

procedure TFCadCategorias.FormCreate(Sender: TObject);
begin
  inherited;
  FCategoria := TCategoria.Create(DMConexao.fdConexao);
end;

procedure TFCadCategorias.FormDestroy(Sender: TObject);
begin
  FCategoria.Free;

  inherited;
end;

procedure TFCadCategorias.FormShow(Sender: TObject);
begin
  inherited;

  btnAtualizar.Click;
end;

procedure TFCadCategorias.lvCategoriaClick(Sender: TObject);
begin
  if lvCategoria.SelCount <= 0 then
    Exit;

  edtID.Text     := lvCategoria.Selected.Caption;
  edtCodigo.Text := lvCategoria.Selected.SubItems[0];
  edtNome.Text   := lvCategoria.Selected.SubItems[1];
end;

end.
