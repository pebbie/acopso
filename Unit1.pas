unit Unit1;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Math,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Grids,
  Menus,
  _pso1,
  _aco1;

type
  TForm1 = class( TForm )
    Image1: TImage;
    ScrollBox1: TScrollBox;
    Memo1: TMemo;
    sga: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Placement1: TMenuItem;
    PSO1: TMenuItem;
    Routing1: TMenuItem;
    ACO1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Save1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Config1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    argetArea1: TMenuItem;
    Panel3: TPanel;
    Panel4: TPanel;
    Button5: TButton;
    Button6: TButton;
    sd: TSaveDialog;
    od: TOpenDialog;
    Settings1: TMenuItem;
    sensorPSO1: TMenuItem;
    Impor1: TMenuItem;
    sensorPSO2: TMenuItem;
    procedure FormCreate( Sender: TObject );
    procedure Button1Click( Sender: TObject );
    procedure Button2Click( Sender: TObject );
    procedure Button3Click( Sender: TObject );
    procedure Button4Click( Sender: TObject );
    procedure Button6Click( Sender: TObject );
    procedure Button5Click( Sender: TObject );
    procedure PSO1Click( Sender: TObject );
    procedure argetArea1Click( Sender: TObject );
    procedure New1Click( Sender: TObject );
    procedure Save1Click( Sender: TObject );
    procedure Open1Click( Sender: TObject );
    procedure Settings1Click( Sender: TObject );
    procedure Add1Click( Sender: TObject );
    procedure Delete1Click( Sender: TObject );
    procedure ACO1Click( Sender: TObject );
    procedure sensorPSO2Click( Sender: TObject );
  private
    { Private declarations }
    procedure resizebitmap( ww, hh: integer );
  public
    procedure load_wmn_file( filename: string );
    procedure init_connectivity;
    procedure init_particles;
    procedure reset_particles;
    procedure update_particles;
    procedure display_particle( part: TParticle );
    procedure show_tabel;
  end;

var
  Form1             : TForm1;
  w, h              : integer;
  pbmp              : PByteArray;
  connectivity      : array of array of real;

implementation

uses _area,
  _setting,
  _t2csv;

{$R *.dfm}

{ TForm1 }

procedure TForm1.init_particles;
var
  i, j              : integer;
  maxscore          : real;
begin
  num_node := sga.RowCount - sga.FixedRows;

  setlength( noderadius, num_node );
  for i := 0 to high( noderadius ) do begin
    if length( trim( sga.Cells[3, i + 1] ) ) = 0 then sga.Cells[3, i + 1] := IntToStr( FrmSetting.DefRadius.Value );
    noderadius[i] := StrToFloat( trim( sga.Cells[3, 1 + i] ) );
  end;

  setlength( particles, num_particle );
  maxscore := -MAXINT;
  for i := 0 to high( particles ) do begin
    setlength( particles[i].best_pos, num_node * 2 );
    setlength( particles[i].pos, num_node * 2 );
    setlength( particles[i].vel, num_node * 2 );

    for j := 0 to num_node - 1 do begin
      particles[i].pos[j * 2] := random( w ); //StrToFloat( sga.Cells[2, j + 1] );
      particles[i].pos[j * 2 + 1] := random( h ); //StrToFloat( sga.Cells[3, j + 1] );

      particles[i].best_pos[j * 2] := particles[i].pos[j * 2];
      particles[i].best_pos[j * 2 + 1] := particles[i].pos[j * 2 + 1];

      particles[i].vel[j * 2] := ( random( w ) - w / 2 );
      particles[i].vel[j * 2 + 1] := ( random( h ) - w / 2 );
    end;

    particles[i].score := eval_particle( particles[i] );
    particles[i].best_score := particles[i].score;

    if particles[i].score > maxscore then begin
      best := i;
      maxscore := particles[i].score;
    end;
  end;

  with particles[best] do begin
    for j := 0 to num_node - 1 do begin
      pos[j * 2] := StrToFloat( sga.Cells[1, j + 1] );
      pos[j * 2 + 1] := StrToFloat( sga.Cells[2, j + 1] );

      best_pos[j * 2] := pos[j * 2];
      best_pos[j * 2 + 1] := pos[j * 2 + 1];

      vel[j * 2] := ( random( w ) - w / 2 );
      vel[j * 2 + 1] := ( random( h ) - h / 2 );
    end;

    score := eval_particle( particles[best] );
    best_score := score;
  end;
  display_particle( particles[best] );
end;

procedure TForm1.FormCreate( Sender: TObject );
var
  i                 : integer;
begin
  sga.Rows[0].CommaText := 'Name,X,Y,Radius';
  resizebitmap( 385, 500 );
  randomize;
  reset_particles;
end;

procedure TForm1.reset_particles;
var
  i, j              : integer;
begin
  for i := 0 to high( particles ) do begin
    setlength( particles[i].best_pos, 0 );
    setlength( particles[i].pos, 0 );
    setlength( particles[i].vel, 0 );
  end;
  setlength( particles, 0 );
end;

procedure TForm1.update_particles;
var
  i, j              : integer;
  u1, u2            : real;
begin
  memo1.lines.Clear;
  for i := 0 to high( particles ) do begin
    //calculate new position
    for j := 0 to num_node * 2 - 1 do
      with particles[i] do begin
        vel[j] := alpha * vel[j] + beta * random * ( best_pos[j] - pos[j] ) + gamma * random * ( particles[best].pos[j] - pos[j] ) + random( min( w, h ) ) * rho;
        pos[j] := pos[j] + vel[j];
        if pos[j] < 0 then pos[j] := 0;
        if j mod 2 = 0 then begin
          if pos[j] > w then begin
            pos[j] := w;
            vel[j] := -vel[j];
          end;
        end
        else begin
          if pos[j] > h then begin
            pos[j] := h;
            vel[j] := -vel[j];
          end;
        end;
      end;

    particles[i].score := eval_particle( particles[i] );
    memo1.Lines.add( format( 'fitness: %f', [particles[i].score] ) );

    if particles[i].score > particles[i].best_score then begin
      particles[i].best_score := particles[i].score;

      for j := 0 to high( particles[i].pos ) do
        particles[i].best_pos[j] := particles[i].pos[j];
    end;

  end;
  for i := 0 to high( particles ) do begin
    if particles[i].score > particles[best].score then best := i;
  end;
  display_particle( particles[best] );
  memo1.lines.add( format( 'best : %d %f %f', [best, particles[best].score, particles[best].best_score] ) );
end;

procedure TForm1.Button1Click( Sender: TObject );
begin
  reset_particles;
end;

procedure TForm1.Button2Click( Sender: TObject );
begin
  init_particles;
  display_particle( particles[best] );
  memo1.lines.add( format( 'best : %d %f %f', [best, particles[best].score, particles[best].best_score] ) );
end;

procedure TForm1.Button3Click( Sender: TObject );
begin
  update_particles;
end;

procedure TForm1.display_particle( part: TParticle );
var
  i, j              : integer;
  x, y, x2, y2      : integer;
  totaldist, dist   : real;
  r                 : integer;
begin
  with bmp.Canvas do begin
    Pen.Style := psClear;
    Brush.Color := clWhite;
    FillRect( Bounds( 0, 0, w, h ) );
    for j := 0 to num_node - 1 do begin
      x := round( part.pos[j * 2] );
      y := round( part.pos[j * 2 + 1] );
      Brush.Style := bsClear;
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Color := clGray;
      r := round( noderadius[j] );
      Ellipse( x - r, y - r, x + r, y + r );
      Brush.Style := bsSolid;
      Brush.Color := clblue;
      Ellipse( x - 2, y - 2, x + 2, y + 2 );
      Brush.Style := bsClear;
      TextOut( x, y, sga.Cells[0, j + 1] );
    end;

    for i := 0 to num_node - 2 do begin
      for j := i + 1 to num_node - 1 do begin
        x := round( part.pos[i * 2] );
        y := round( part.pos[i * 2 + 1] );

        x2 := round( part.pos[j * 2] );
        y2 := round( part.pos[j * 2 + 1] );

        dist := sqrt( ( x2 - x ) * ( x2 - x ) + ( y2 - y ) * ( y2 - y ) );

        if dist < ( noderadius[i] + noderadius[j] ) then begin
          connectivity[i][j] := dist;
          connectivity[j][i] := dist;
          totaldist := totaldist + dist;

          Pen.Color := clRed;
          Pen.Width := 2;
          MoveTo( x, y );
          LineTo( x2, y2 );
        end else begin
          connectivity[i][j] := 0;
          connectivity[j][i] := 0;
        end;

      end;
    end;
    Image1.Picture.Bitmap.Assign( bmp );
    memo1.lines.add( format( 'total distance : %f', [totaldist] ) );
  end;
end;

procedure TForm1.Button4Click( Sender: TObject );
var
  i                 : integer;
begin
  for i := 0 to 100 do begin
    button3Click( self );
    if i mod 10 = 0 then application.ProcessMessages;
  end;
end;

procedure TForm1.Button6Click( Sender: TObject );
begin
  memo1.Lines.clear;
end;

procedure TForm1.Button5Click( Sender: TObject );
begin
  sd.Filter := 'Text File (*.txt)|*.txt';
  sd.DefaultExt := '.txt';
  if sd.Execute then begin
    memo1.lines.SaveToFile( sd.FileName );
  end;
end;

procedure TForm1.PSO1Click( Sender: TObject );
var
  i                 : integer;
  strres            : string;
  maxstep           : integer;
begin
  maxstep := 100;
  try
    if not trystrtoint( InputBox( 'PSO Parameter', '# iteration', inttostr( maxstep ) ), maxstep ) then exit;
  finally
  end;

  init_particles;
  display_particle( particles[best] );
  for i := 0 to maxstep do begin
    button3Click( self );
    if i mod 10 = 0 then application.ProcessMessages;
  end;

  for i := 0 to num_node - 1 do begin
    sga.Cells[1, i + 1] := inttostr( round( particles[best].best_pos[i * 2] ) );
    sga.Cells[2, i + 1] := inttostr( round( particles[best].best_pos[i * 2 + 1] ) );
  end;
  reset_particles;
end;

procedure TForm1.argetArea1Click( Sender: TObject );
begin
  frmArea.ShowModal;
  resizebitmap( frmArea.spWidth.Value, frmArea.spHeight.Value );
end;

procedure TForm1.resizebitmap( ww, hh: integer );
begin
  w := ww;
  h := hh;
  if Assigned( bmp ) then bmp.Free;

  bmp := TBitmap.Create;
  bmp.PixelFormat := pf8bit;
  bmp.Width := w;
  bmp.Height := h;

  with bmp.Canvas do begin
    Pen.Style := psClear;
    Brush.Color := clWhite;
    FillRect( Bounds( 0, 0, w, h ) );
  end;
  Image1.Picture.Bitmap.Assign( bmp );
end;

procedure TForm1.New1Click( Sender: TObject );
var
  i                 : integer;
begin
  if not trystrtoint( InputBox( 'PSO Parameter', 'number of node', inttostr( num_node ) ), num_node ) then exit;
  sga.RowCount := sga.FixedRows + num_node;
  for i := 1 to num_node do begin
    sga.Rows[i].CommaText := format( 'node%d,%d,%d,%d', [i, random( w ), random( h ), FrmSetting.DefRadius.Value] );
  end;
  show_tabel;
end;

procedure TForm1.Save1Click( Sender: TObject );
var
  i                 : integer;
begin
  sd.Filter := 'WMN File (*.wmn)|*.wmn';
  sd.DefaultExt := '.wmn';
  if sd.Execute then begin
    with TStringlist.Create do begin
      for i := 0 to sga.RowCount - 1 do begin
        Add( sga.Rows[i].CommaText );
      end;
      SaveToFile( sd.FileName );
      Free;
    end;
  end;
end;

procedure TForm1.Open1Click( Sender: TObject );
var
  i                 : integer;
begin
  od.Filter := 'WMN File (*.wmn)|*.wmn';
  od.DefaultExt := '.wmn';
  if od.Execute then begin
    load_wmn_file( od.FileName );
  end;
end;

procedure TForm1.Settings1Click( Sender: TObject );
begin
  FrmSetting.Show;
end;

procedure TForm1.show_tabel;
var
  p                 : TParticle;
  i                 : integer;
begin
  num_node := ( sga.RowCount - sga.FixedRows );
  setlength( p.pos, num_node * 2 );
  setlength( p.best_pos, num_node * 2 );
  setlength( noderadius, num_node );

  init_connectivity;

  for i := 0 to num_node - 1 do begin
    p.pos[i * 2] := StrToFloat( trim( sga.Cells[1, 1 + i] ) );
    p.pos[i * 2 + 1] := StrToFloat( trim( sga.Cells[2, 1 + i] ) );
    if length( trim( sga.Cells[3, i + 1] ) ) = 0 then sga.Cells[3, i + 1] := IntToStr( FrmSetting.DefRadius.Value );
    noderadius[i] := StrToFloat( trim( sga.Cells[3, 1 + i] ) );
  end;

  display_particle( p );

  setlength( noderadius, 0 );
  setlength( p.pos, 0 );
end;

procedure TForm1.Add1Click( Sender: TObject );
begin
  sga.RowCount := sga.RowCount + 1;
  sga.Rows[sga.RowCount - 1].CommaText := format( '%s%d,%d,%d,%d', [FrmSetting.DefPrefix.Text, sga.RowCount, Random( w ), Random( h ), FrmSetting.DefRadius.Value] );

  num_node := sga.RowCount - sga.FixedRows;
  init_connectivity;
end;

procedure TForm1.Delete1Click( Sender: TObject );
var
  i, j              : integer;
begin
  i := sga.Selection.Top;
  if i = -1 then exit;
  for j := i to sga.RowCount - 2 do
    sga.Rows[i].Assign( sga.Rows[i + 1] );
  sga.RowCount := sga.RowCount - 1;
end;

procedure TForm1.ACO1Click( Sender: TObject );
begin
  aco_initialize( 10, num_node );
  aco_shortest_path;
end;

procedure TForm1.init_connectivity;
var
  i, j              : integer;
begin
  setlength( connectivity, num_node );
  for i := 0 to high( connectivity ) do begin
    setlength( connectivity[i], num_node );
    for j := 0 to high( connectivity[i] ) do
      connectivity[i][j] := 0;
  end;
end;

procedure TForm1.sensorPSO2Click( Sender: TObject );
begin
  FrmTabel.Button1Click( self );
  if fileexists( ChangeFileExt( FrmTabel.od.FileName, '.wmn' ) ) then begin
    load_wmn_file( ChangeFileExt( FrmTabel.od.FileName, '.wmn' ) )
  end;
end;

procedure TForm1.load_wmn_file( filename: string );
var
  i                 : integer;
begin
  if not fileexists( filename ) then exit;
  with TStringlist.Create do begin
    LoadFromFile( FileName );
    if Count <= 1 then
      sga.RowCount := 2
    else
      sga.RowCount := Count;
    for i := 0 to COunt - 1 do begin
      sga.Rows[i].CommaText := Strings[i];
    end;
    Free;
  end;
  show_tabel;
end;

end.

