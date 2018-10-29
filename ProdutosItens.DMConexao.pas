unit ProdutosItens.DMConexao;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  System.Generics.Collections,
  ProdutosItens.Classes;

type
  TDMConexao = class(TDataModule)
    fdConexao: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure fdConexaoBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetAllItens: TObjectList<TItem>;
    function GetAllCategorias: TObjectList<TCategoria>;
  end;

var
  DMConexao: TDMConexao;

implementation

uses
  System.IniFIles,
  Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  fdConexao.Connected := True;
end;

procedure TDMConexao.DataModuleDestroy(Sender: TObject);
begin
  fdConexao.Connected := False;
end;

procedure TDMConexao.fdConexaoBeforeConnect(Sender: TObject);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    fdConexao.Params.Clear;
    fdConexao.DriverName                 := 'MySQL';
    fdConexao.Params.Values['database']  := IniFile.ReadString('Configurações', 'Database', 'produtositens');
    fdConexao.Params.Values['server']    := IniFile.ReadString('Configurações', 'Server', 'localhost');
    fdConexao.Params.Values['port']      := IniFile.ReadString('Configurações', 'Port', '3306');
    fdConexao.Params.Values['User_name'] := IniFile.ReadString('Configurações', 'UserName', 'root');
    fdConexao.Params.Values['Password']  := IniFile.ReadString('Configurações', 'Password', 'root');

    IniFile.WriteString('Configurações', 'Database', fdConexao.Params.Values['database']);
    IniFile.WriteString('Configurações', 'Server', fdConexao.Params.Values['server']);
    IniFile.WriteString('Configurações', 'Port', fdConexao.Params.Values['port']);
    IniFile.WriteString('Configurações', 'UserName', fdConexao.Params.Values['User_name']);
    IniFile.WriteString('Configurações', 'Password', fdConexao.Params.Values['Password']);

  finally
    FreeAndNil(IniFile);
  end;
end;

function TDMConexao.GetAllCategorias: TObjectList<TCategoria>;
var
  LQuery: TFDQuery;
  LCategoria: TCategoria;
begin
  LQuery := TFDQuery.Create(Self);
  try
    LQuery.Connection := fdConexao;
    LQuery.SQL.Text := 'SELECT * FROM categorias';
    LQuery.Open;
    LQuery.FetchAll;
    Result := TObjectList<TCategoria>.Create;
    LQuery.First;
    while not LQuery.Eof do
    try
      LCategoria := TCategoria.Create(fdConexao);
      LCategoria.ID     := LQuery.FieldByName('ID').AsInteger;
      LCategoria.Codigo := LQuery.FieldByName('Codigo').AsString;
      LCategoria.Nome   := LQuery.FieldByName('Nome').AsString;
      Result.Add(LCategoria);
    finally
      LQuery.Next;
    end;
    LQuery.Close;
  finally
    LQuery.Free;
  end;
end;

function TDMConexao.GetAllItens: TObjectList<TItem>;
var
  LQuery: TFDQuery;
  LItem: TItem;
begin
  LQuery := TFDQuery.Create(Self);
  try
    LQuery.Connection := fdConexao;
    LQuery.SQL.Text := 'SElECT * FROM itens';
    LQuery.Open;
    LQuery.FetchAll;

    Result := TObjectList<TItem>.Create;
    LQuery.First;
    while not LQuery.Eof do
    try
      LItem := TItem.Create(fdConexao);
      LItem.ID           := LQuery.FieldByName('ID').AsInteger;
      LItem.Tipo         := LQuery.FieldByName('Tipo').AsString;
      LItem.Codigo       := LQuery.FieldByName('Codigo').AsString;
      LItem.Nome         := LQuery.FieldByName('Nome').AsString;
      LItem.Descricao    := LQuery.FieldByName('Descricao').AsString;
      LItem.ValorUnitario:= LQuery.FieldByName('ValorUnitario').AsFloat;

      Result.Add(LItem);
    finally
      LQuery.Next;
    end;
    LQuery.Close;

  finally
    FreeAndNil(LQuery);
  end;
end;

end.
