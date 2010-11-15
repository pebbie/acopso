program covPSO;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  _area in '_area.pas' {FrmArea},
  _setting in '_setting.pas' {FrmSetting},
  _pso1 in '_pso1.pas',
  _aco1 in '_aco1.pas',
  _t2csv in '_t2csv.pas' {FrmTabel};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmArea, FrmArea);
  Application.CreateForm(TFrmSetting, FrmSetting);
  Application.CreateForm(TFrmTabel, FrmTabel);
  Application.Run;
end.

