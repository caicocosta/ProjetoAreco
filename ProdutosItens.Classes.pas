unit ProdutosItens.Classes;

interface

uses
  FireDAC.Comp.Client;

type
  TCategoria = class
  private
    FConnection: TFDConnection;
    FQuery     : TFDQuery;
    FID        : Integer;
    FCodigo    : string;
    FNome      : string;
    function GetCodigo: string;
    function GetID: Integer;
    function GetNome: string;
    procedure SetCodigo(const Value: string);
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: string);
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    procedure SalvarBancoDados;
    procedure CarregarBancoDados(AID: Integer);
    procedure ExcluirBancoDados(AID: Integer);

    property ID: Integer read GetID write SetID;
    property Codigo: string read GetCodigo write SetCodigo;
    property Nome: string read GetNome write SetNome;
  end;

  TItem = class
  private
    FConnection   : TFDConnection;
    FQuery        : TFDQuery;
    FDescricao    : string;
    FCodigo       : string;
    FValorUnitario: Double;
    FID           : Integer;
    FNome         : string;
    FTipo         : string;
    procedure SetCodigo(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetValorUnitario(const Value: Double);
    function GetCodigo: string;
    function GetDescricao: string;
    function GetID: Integer;
    function GetNome: string;
    function GetValorUnitario: Double;
    function GetTipo: string;
    procedure SetTipo(const Value: string);
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    procedure SalvarBancoDados; virtual; abstract;
    procedure CarregarBancoDados(AID: Integer); virtual; abstract;
    procedure ExcluirBancoDados(AID: Integer);

    property ID           : Integer read GetID write SetID;
    property Tipo         : string read GetTipo write SetTipo;
    property Codigo       : string read GetCodigo write SetCodigo;
    property Nome         : string read GetNome write SetNome;
    property Descricao    : string read GetDescricao write SetDescricao;
    property ValorUnitario: Double read GetValorUnitario write SetValorUnitario;
  end;

  TProduto = class(TItem)
  private
    FPeso  : Double;
    FAltura: Double;
    procedure SetAltura(const Value: Double);
    procedure SetPeso(const Value: Double);
    function GetAltura: Double;
    function GetPeso: Double;
  public
    procedure SalvarBancoDados; override;
    procedure CarregarBancoDados(AID: Integer); override;

    property Peso  : Double read GetPeso write SetPeso;
    property Altura: Double read GetAltura write SetAltura;
  end;

  TServico = class(TItem)
  private
    FCodigoServico: string;
    FIDCategoria  : Integer;
    procedure SetCodigoServico(const Value: string);
    function GetCodigoServico: string;
    procedure SetIDCategoria(const Value: Integer);
    function GetIDCategoria: Integer;
  public
    procedure SalvarBancoDados; override;
    procedure CarregarBancoDados(AID: Integer); override;

    property CodigoServico: string read GetCodigoServico write SetCodigoServico;
    property IDCategoria  : Integer read GetIDCategoria write SetIDCategoria;
  end;

implementation

uses
  FireDAC.Stan.Param;

{ TItem }


constructor TItem.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TItem.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TItem.ExcluirBancoDados(AID: Integer);
begin
  FQuery.SQL.Text := 'DELETE FROM itens WHERE (ID = :ID)';
  FQuery.ParamByName('ID').AsInteger := AID;
  FQuery.ExecSQL;
end;

function TItem.GetCodigo: string;
begin
  Result := FCodigo;
end;

function TItem.GetDescricao: string;
begin
  Result := FDescricao;
end;

function TItem.GetID: Integer;
begin
  Result := FID;
end;

function TItem.GetNome: string;
begin
  Result := FNome;
end;

function TItem.GetTipo: string;
begin
  Result := FTipo;
end;

function TItem.GetValorUnitario: Double;
begin
  Result := FValorUnitario;
end;

procedure TItem.SetCodigo(const Value: string);
begin
  FCodigo := Value;
end;

procedure TItem.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TItem.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TItem.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TItem.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

procedure TItem.SetValorUnitario(const Value: Double);
begin
  FValorUnitario := Value;
end;

{ TProduto }

procedure TProduto.CarregarBancoDados(AID: Integer);
begin
  FQuery.SQL.Text := 'SELECT * FROM itens WHERE (ID = :ID)';
  FQuery.ParamByName('ID').AsInteger := AID;
  FQuery.Open;
  FID            := FQuery.FieldByName('ID').AsInteger;
  FTipo          := FQuery.FieldByName('Tipo').AsString;
  FCodigo        := FQuery.FieldByName('Codigo').AsString;
  FNome          := FQuery.FieldByName('Nome').AsString;
  FDescricao     := FQuery.FieldByName('Descricao').AsString;
  FValorUnitario := FQuery.FieldByName('ValorUnitario').AsFloat;
  FPeso          := FQuery.FieldByName('Peso').AsFloat;
  FAltura        := FQuery.FieldByName('Altura').AsFloat;
  FQuery.Close;
end;

function TProduto.GetAltura: Double;
begin
  Result := FAltura;
end;

function TProduto.GetPeso: Double;
begin
  Result := FPeso;
end;

procedure TProduto.SalvarBancoDados;
begin
  if FID <= 0 then
    FQuery.SQL.Text := 'INSERT INTO itens (Tipo, Codigo, Nome, Descricao, ValorUnitario, Peso, Altura)' +
      'VALUES (:Tipo, :Codigo, :Nome, :Descricao, :ValorUnitario, :Peso, :Altura)'
  else
    FQuery.SQL.Text :=
      'UPDATE itens                     ' +
      'SET                              ' +
      ' Tipo          = :Tipo,          ' +
      ' Codigo        = :Codigo,        ' +
      ' Nome          = :Nome,          ' +
      ' Descricao     = :Descricao,     ' +
      ' ValorUnitario = :ValorUnitario, ' +
      ' Peso          = :Peso,          ' +
      ' Altura        = :Altura         ' +
      'WHERE (ID = :ID)                 ';
  FQuery.ParamByName('Tipo').AsString         := 'PRODUTO';
  FQuery.ParamByName('Codigo').AsString       := Codigo;
  FQuery.ParamByName('Nome').AsString         := Nome;
  FQuery.ParamByName('Descricao').AsString    := Descricao;
  FQuery.ParamByName('ValorUnitario').AsFloat := ValorUnitario;
  FQuery.ParamByName('Peso').AsFloat          := Peso;
  FQuery.ParamByName('Altura').AsFloat        := Altura;

  if ID > 0 then
    FQuery.ParamByName('ID').AsInteger := ID;

  FQuery.ExecSQL;
end;

procedure TProduto.SetAltura(const Value: Double);
begin
  FAltura := Value;
end;

procedure TProduto.SetPeso(const Value: Double);
begin
  FPeso := Value;
end;

{ TServico }

procedure TServico.CarregarBancoDados(AID: Integer);
begin
  FQuery.SQL.Text := 'SELECT * FROM itens WHERE (ID = :ID)';
  FQuery.ParamByName('ID').AsInteger := AID;
  FQuery.Open;
  FID            := FQuery.FieldByName('ID').AsInteger;
  FTipo          := FQuery.FieldByName('Tipo').AsString;
  FCodigo        := FQuery.FieldByName('Codigo').AsString;
  FNome          := FQuery.FieldByName('Nome').AsString;
  FDescricao     := FQuery.FieldByName('Descricao').AsString;
  FValorUnitario := FQuery.FieldByName('ValorUnitario').AsFloat;
  FCodigoServico := FQuery.FieldByName('CodServico').AsString;
  FIDCategoria   := FQuery.FieldByName('IDCategoria').AsInteger;
  FQuery.Close;
end;

function TServico.GetCodigoServico: string;
begin
  Result := FCodigoServico;
end;

function TServico.GetIDCategoria: Integer;
begin
  Result := FIDCategoria;
end;

procedure TServico.SalvarBancoDados;
begin
  if FID <= 0 then
    FQuery.SQL.Text := 'INSERT INTO itens (Tipo, Codigo, Nome, Descricao, ValorUnitario, IDCategoria, CodServico)' +
      'VALUES (:Tipo, :Codigo, :Nome, :Descricao, :ValorUnitario, :IDCategoria, :CodServico)'
  else
    FQuery.SQL.Text :=
      'UPDATE itens                     ' +
      'SET                              ' +
      ' Tipo          = :Tipo,          ' +
      ' Codigo        = :Codigo,        ' +
      ' Nome          = :Nome,          ' +
      ' Descricao     = :Descricao,     ' +
      ' ValorUnitario = :ValorUnitario, ' +
      ' IDCategoria   = :IDCategoria,   ' +
      ' CodServico    = :CodServico    ' +
      'WHERE (ID = :ID)                 ';
  FQuery.ParamByName('Tipo').AsString         := 'SERVIÇO';
  FQuery.ParamByName('Codigo').AsString       := Codigo;
  FQuery.ParamByName('Nome').AsString         := Nome;
  FQuery.ParamByName('Descricao').AsString         := Descricao;
  FQuery.ParamByName('ValorUnitario').AsFloat := ValorUnitario;
  FQuery.ParamByName('CodServico').AsString   := CodigoServico;
  FQuery.ParamByName('IDCategoria').AsInteger := IDCategoria;

  if ID > 0 then
    FQuery.ParamByName('ID').AsInteger := ID;

  FQuery.ExecSQL;
end;

procedure TServico.SetCodigoServico(const Value: string);
begin
  FCodigoServico := Value;
end;

{ TCategoria }

procedure TCategoria.CarregarBancoDados(AID: Integer);
begin
  FQuery.Params.Clear;
  FQuery.SQL.Text := 'SELECT * FROM categorias WHERE ID = :ID';
  FQuery.ParamByName('ID').AsInteger := AID;
  FQuery.Open;
  FID     := FQuery.FieldByName('ID').AsInteger;
  FCodigo := FQuery.FieldByName('Codigo').AsString;
  FNome   := FQuery.FieldByName('Nome').AsString;
  FQuery.Close;
end;

constructor TCategoria.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection       := AConnection;
  FQuery            := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TCategoria.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TCategoria.ExcluirBancoDados(AID: Integer);
begin
  FQuery.Params.Clear;
  FQuery.SQL.Text := 'DELETE FROM categorias WHERE (ID = :ID)';
  FQuery.ParamByName('ID').AsInteger := AID;
  FQuery.ExecSQL;
end;

function TCategoria.GetCodigo: string;
begin
  Result := FCodigo;
end;

function TCategoria.GetID: Integer;
begin
  Result := FID;
end;

function TCategoria.GetNome: string;
begin
  Result := FNome;
end;

procedure TCategoria.SalvarBancoDados;
begin
  FQuery.Params.Clear;
  if FID < 0 then
    FQuery.SQL.Text := 'INSERT INTO categorias (Codigo, Nome) VALUES(:Codigo, :Nome)'
  else
    FQuery.SQL.Text :=
      'UPDATE categorias ' +
      'SET               ' +
      ' Codigo = :Codigo,' +
      ' Nome   = :Nome   ' +
      'WHERE (ID = :ID)  ';

  FQuery.ParamByName('Codigo').AsString := FCodigo;
  FQuery.ParamByName('Nome').AsString   := FNome;

  if FID > 0 then
    FQuery.ParamByName('ID').AsInteger := FID;

  FQuery.ExecSQL;
end;

procedure TCategoria.SetCodigo(const Value: string);
begin
  FCodigo := Value;
end;

procedure TCategoria.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCategoria.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TServico.SetIDCategoria(const Value: Integer);
begin
  FIDCategoria := Value;
end;

end.
