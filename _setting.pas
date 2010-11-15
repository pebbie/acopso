unit _setting;

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
  TFrmSetting = class( TForm )
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DefRadius: TSpinEdit;
    Label2: TLabel;
    DefPrefix: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    DefNumNode: TSpinEdit;
    Button1: TButton;
    procedure Button1Click( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSetting        : TFrmSetting;

implementation

{$R *.dfm}
uses Unit1,
  _pso1;

procedure TFrmSetting.Button1Click( Sender: TObject );
begin
  num_node := DefNumNode.Value;
  Close;
end;

end.

