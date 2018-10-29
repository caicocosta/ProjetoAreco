unit ProdutosItens.CadItens;

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
  Vcl.StdCtrls,
  Vcl.Mask,
  ProdutosItens.Classes, System.ImageList, Vcl.ImgList;

type
  TFCadItens = class(TForm)
    pnNavigation: TPanel;
    btnNovo: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnAtualizar: TSpeedButton;
    btnSalvar: TSpeedButton;
    lb1: TLabel;
    lb2: TLabel;
    lb: TLabel;
    lbVrUnitario: TLabel;
    lb4: TLabel;
    lbPeso: TLabel;
    lbAltura: TLabel;
    lbCodServico: TLabel;
    edtNome: TEdit;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    edtValor: TEdit;
    cbxTipo: TComboBox;
    edtPeso: TEdit;
    edtAltura: TEdit;
    edtCodServico: TEdit;
    lbCategoria: TLabel;
    edtCategoria: TEdit;
    btnBuscar: TButton;
    ImageList1: TImageList;
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxTipoChange(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
  private
    function VerificaCampo(S: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
    FItem: TItem;
  end;

var
  FCadItens: TFCadItens;

implementation

uses
  ProdutosItens.DMConexao, ProdutosItens.CadCategorias;

{$R *.dfm}

procedure TFCadItens.btnBuscarClick(Sender: TObject);
begin
  with TFCadCategorias.Create(Self) do
  try
    if ShowModal = mrOk then
      edtCategoria.Text := FCategoria.ID.ToString;
  finally
    Release;
  end;
end;

procedure TFCadItens.btnAtualizarClick(Sender: TObject);
begin
  if FItem.ID <= 0 then
    Exit;

  if SameText(FItem.Tipo,'PRODUTO') then
    cbxTipo.ItemIndex := 1
  else
    cbxTipo.ItemIndex := 0;

  edtCodigo.Text    := FItem.Codigo;
  edtNome.Text      := FItem.Nome;
  edtDescricao.Text := FItem.Descricao;
  edtValor.Text     := FloatToStr(FItem.ValorUnitario);
  if SameText(FItem.Tipo, 'PRODUTO') then
  begin
    edtPeso.Text   := FloatToStr(TProduto(FItem).Peso);
    edtAltura.Text := FloatToStr(TProduto(FItem).Altura);
  end
  else
  begin
    edtCodServico.Text := TServico(FItem).CodigoServico;
    edtCategoria.Text  := TServico(FItem).IDCategoria.ToString;
  end;
  cbxTipoChange(cbxTipo);
end;

procedure TFCadItens.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja excluir esse item?', 'Excluir', mb_iconquestion +
                            mb_yesno) = idYes then
  begin
    FItem.ExcluirBancoDados(FItem.ID);
    Close;
  end else
    Abort;
end;

procedure TFCadItens.btnNovoClick(Sender: TObject);
begin
  FItem.ID          := -1;
  edtCodigo.Text    := '';
  cbxTipo.ItemIndex := 0;
  edtNome.Text      := '';
  edtDescricao.Text := '';
  edtValor.Text     := '';
  edtPeso.Text      := '';
  edtAltura.Text    := ''
end;

procedure TFCadItens.btnSalvarClick(Sender: TObject);
begin
  if not VerificaCampo(edtValor.Text) then
  begin
    ShowMessage('Preencha corretamente o campo Valor Unitário!');
    Abort;
  end;

  FItem.Codigo        := edtCodigo.Text;
  FItem.Tipo          := cbxTipo.Text;
  FItem.Nome          := edtNome.Text;
  FItem.Descricao     := edtDescricao.Text;
  FItem.ValorUnitario := StrToFloatDef(edtValor.Text,0);

  if cbxTipo.ItemIndex <> 0 then
  begin
    TServico(FItem).IDCategoria := 0;
    TServico(FItem).CodigoServico := '';
  end
  else
  begin
    TProduto(FItem).Peso   := StrToFloatDef(edtPeso.Text,0);
    TProduto(FItem).Altura := StrToFloatDef(edtAltura.Text,0);
  end;

  FItem.SalvarBancoDados;
  ShowMessage('Item Salvo com Sucesso!');
  Close;
end;

procedure TFCadItens.cbxTipoChange(Sender: TObject);
var
  LID: Integer;
begin
  if not SameText(cbxTipo.Text, FItem.Tipo) then
  begin
    LID := FItem.ID;
    FItem.Free;
    if SameText(cbxTipo.Text, 'PRODUTO') then
    begin
      FItem := TProduto.Create(DMConexao.fdConexao);
      FItem.Tipo := 'PRODUTO';
    end
    else
    begin
      FItem := TServico.Create(DMConexao.fdConexao);
      FItem.Tipo := 'SERVIÇO';
    end;
    FItem.ID := LID;
  end;

  edtPeso.Visible       := (cbxTipo.ItemIndex = 1);
  edtAltura.Visible     := (cbxTipo.ItemIndex = 1);
  edtCodServico.Visible := (cbxTipo.ItemIndex = 0);
  edtCategoria.Visible  := (cbxTipo.ItemIndex = 0);
  btnBuscar.Visible     := (cbxTipo.ItemIndex = 0);
  lbPeso.Visible        := (cbxTipo.ItemIndex = 1);
  lbAltura.Visible      := (cbxTipo.ItemIndex = 1);
  lbCodServico.Visible  := (cbxTipo.ItemIndex = 0);
  lbCategoria.Visible   := (cbxTipo.ItemIndex = 0);

  if cbxTipo.ItemIndex = 0 then
  begin
    edtCodServico.Top := edtPeso.Top;
    edtCategoria.Top  := edtAltura.Top;
    lbCodServico.Top  := lbPeso.Top;
    lbCategoria.Top   := lbAltura.Top;
    btnBuscar.Top     := lbAltura.Top - 3;
  end;
end;

procedure TFCadItens.FormDestroy(Sender: TObject);
begin
  inherited;
  FItem.Free;
end;

procedure TFCadItens.FormShow(Sender: TObject);
begin
  btnAtualizar.Click;
  cbxTipoChange(cbxTipo);
end;

function TFCadItens.VerificaCampo(S : String): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(S) do begin
    if not (S[I] in ['0'..'9']) then begin
      Result := False;
      Break;
    end;
  end;
end;

end.
