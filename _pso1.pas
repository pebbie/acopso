unit _pso1;

interface

uses
  Windows,
  Graphics,
  SysUtils,
  Classes,
  Math,
  Types;

type
  TParticle = record
    best_pos, pos, vel: array of real;
    score, best_score: real;
  end;

function eval_particle( part: TParticle ): real;

var
  particles         : array of TParticle;
  noderadius        : array of real;
  num_particle      : integer = 30;
  num_node          : integer = 8;
  radius            : integer = 100;
  alpha, beta, gamma, rho: real;
  bmp               : TBitmap;
  best              : integer;

implementation

uses
  Unit1;

function eval_particle( part: TParticle ): real;
var
  i, j              : integer;
  x, y, x2, y2      : integer;
  num_black         : integer;
  num_disconnected  : integer;
  connected         : boolean;
  dist              : real;
  r                 : integer;
begin
  num_black := 0;
  with bmp.Canvas do begin
    Pen.Style := psClear;
    Brush.Color := clWhite;
    FillRect( Bounds( 0, 0, w, h ) );
    Brush.Color := clBlack;
    for j := 0 to num_node - 1 do begin
      x := round( part.pos[j * 2] );
      y := round( part.pos[j * 2 + 1] );
      r := round( noderadius[j] );
      Ellipse( x - r, y - r, x + r, y + r );
    end;
    //Image1.Picture.Bitmap.Assign( bmp );

    for y := 0 to h - 1 do begin
      pbmp := bmp.ScanLine[y];
      for x := 0 to w - 1 do begin
        if pbmp[x] = 0 then inc( num_black );
      end;
    end;

    num_disconnected := 0;
    for i := 0 to num_node - 2 do begin
      connected := false;
      for j := i + 1 to num_node - 1 do begin
        x := round( part.pos[i * 2] );
        y := round( part.pos[i * 2 + 1] );

        x2 := round( part.pos[j * 2] );
        y2 := round( part.pos[j * 2 + 1] );

        dist := sqrt( ( x2 - x ) * ( x2 - x ) + ( y2 - y ) * ( y2 - y ) );

        if dist < ( noderadius[i] + noderadius[j] ) then begin
          connected := true;
        end;

      end;
      if not connected then inc( num_disconnected );
    end;

    //result := 1000 * ( ( num_node - num_disconnected ) / ( num_node ) ) * num_black / ( w * h );
    result := 1000 * num_black / ( w * h );
  end;
end;

initialization
  alpha := 0.5;
  beta := 0.8;
  gamma := 0.8;
  rho := 0.01;
finalization
  bmp.Free;
end.

