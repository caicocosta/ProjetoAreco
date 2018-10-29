program ProdutosItens;

uses
  Vcl.Forms,
  ProdutosItens.Principal in 'ProdutosItens.Principal.pas' {FPrincipal},
  ProdutosItens.CadCategorias in 'ProdutosItens.CadCategorias.pas' {FCadCategorias},
  ProdutosItens.DMConexao in 'ProdutosItens.DMConexao.pas' {DMConexao: TDataModule},
  ProdutosItens.CadItens in 'ProdutosItens.CadItens.pas' {FCadItens},
  ProdutosItens.Classes in 'ProdutosItens.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.CreateForm(TDMConexao, DMConexao);
  Application.CreateForm(TFCadItens, FCadItens);
  Application.Run;
end.
