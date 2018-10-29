unit ProdutosItens.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls;

type
  TFPrincipal = class(TForm)
    lvItens: TListView;
    pnNavigation: TPanel;
    btnNovo: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnAtualizar: TSpeedButton;
    btn1: TSpeedButton;
    procedure lvItensDblClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

uses
  ProdutosItens.DMConexao,
  ProdutosItens.CadItens,
  ProdutosItens.Classes,
  System.Generics.Collections;

{$R *.dfm}

procedure TFPrincipal.btnAtualizarClick(Sender: TObject);
var
  LItens: TObjectList<TItem>;
  LItem: TItem;
  LListItem: TListItem;
begin
  LItens := DMConexao.GetAllItens;

  lvItens.Items.Clear;
  for LItem in LItens do
  begin
    LListItem := lvItens.Items.Add;
    LListItem.Caption := LItem.ID.ToString;
    LListItem.SubItems.Add(LItem.Tipo);
    LListItem.SubItems.Add(LItem.Codigo);
    LListItem.SubItems.Add(LItem.Nome);
    LListItem.SubItems.Add(LItem.Descricao);
    LListItem.SubItems.Add(FloatToStr(LItem.ValorUnitario));
  end;
  LItens.Free;
end;

procedure TFPrincipal.btnExcluirClick(Sender: TObject);
var
  LItem: TItem;
begin
  if lvItens.SelCount <= 0 then
    Exit;


  LItem := TItem.Create(DMConexao.fdConexao);
  try
    LItem.ExcluirBancoDados(lvItens.Selected.Caption.ToInteger);
    btnAtualizar.Click;
  finally
    LItem.Free;
  end;
end;

procedure TFPrincipal.btnNovoClick(Sender: TObject);
begin
  with TFCadItens.Create(Self) do
  try
    FItem := TProduto.Create(DMConexao.fdConexao);
    FItem.ID := -1;
    FItem.Tipo := 'PRODUTO';

    ShowModal;
    btnAtualizar.Click;
  finally
    Release;
  end;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  btnAtualizar.Click;
end;

procedure TFPrincipal.lvItensDblClick(Sender: TObject);
begin
  if lvItens.SelCount <= 0 then
    Exit;

  with TFCadItens.Create(Self) do
  try
    if SameText(lvItens.Selected.SubItems[0], 'PRODUTO') then
      FItem := TProduto.Create(DMConexao.fdConexao)
    else
      FItem := TServico.Create(DMConexao.fdConexao);

    FItem.CarregarBancoDados(lvItens.Selected.Caption.ToInteger);
    ShowModal;
    btnAtualizar.Click;
  finally

    Release;
  end;

end;

end.
