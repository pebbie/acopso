unit _area;

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
  Spin;

type
  TFrmArea = class( TForm )
    Label1: TLabel;
    Label2: TLabel;
    spWidth: TSpinEdit;
    spHeight: TSpinEdit;
    Button1: TButton;
    procedure Button1Click( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmArea           : TFrmArea;

implementation

{$R *.dfm}

procedure TFrmArea.Button1Click( Sender: TObject );
begin
  Close;
end;

end.

