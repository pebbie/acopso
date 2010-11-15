unit _t2csv;

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
  Dialogs,
  StdCtrls,
  Grids,
  ExtCtrls;

type
  TFrmTabel = class( TForm )
    sg: TStringGrid;
    Button1: TButton;
    od: TOpenDialog;
    Panel1: TPanel;
    procedure Button1Click( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTabel             : TFrmTabel;

implementation

{$R *.dfm}

procedure TFrmTabel.Button1Click( Sender: TObject );
var
  s                 : TStrings;
  i                 : integer;
begin
  if od.Execute then begin
    with TStringlist.Create do begin
      LoadFromFile( od.FileName );

      s := TStringlist.Create;
      s.Delimiter := #9;
      s.DelimitedText := Strings[0];
      sg.ColCount := s.Count;

      sg.RowCount := Count;
      for i := 0 to Count - 1 do begin
        s.DelimitedText := Strings[i];
        sg.Rows[i].Assign( s );
        Strings[i] := s.CommaText;
      end;
      SaveToFile( ChangeFileExt( od.FileName, '.csv' ) );
      Free;
    end;
  end;
  with TStringlist.Create do begin
    Add( 'Name,X,Y,Radius' );
    for i := 2 to sg.ColCount - 1 do begin
      Add( 'node' + inttostr( i - 1 ) + ',' + sg.Cells[i, sg.RowCount - 3] + ',' )
    end;
    SaveToFile( ChangeFileExt( od.FileName, '.wmn' ) );
  end;
end;

end.

