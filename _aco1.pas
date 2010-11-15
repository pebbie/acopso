unit _aco1;

interface

uses math,
  Classes,
  DIalogs,
  SysUtils;

type
  TACOSol = record
    path: array of integer;
    total_dist: real;
  end;

procedure aco_clear;
procedure aco_initialize( n_ant, n_node: integer );
procedure aco_shortest_path;

var
  evaporation_coeff : real;
  pher_pow          : real = 0.5;
  heur_pow          : real = 0.5;
  ants              : array of TACOSol;
  pheromone         : array of array of real;
  num_ant, num_node : integer;

implementation

uses
  Unit1; { array connectivity akan jadi faktor heuristik }

procedure aco_clear;
var
  i                 : integer;
begin
  for i := 0 to high( ants ) do
    setlength( ants[i].path, 0 );
  setlength( ants, 0 );
  for i := 0 to high( pheromone ) do
    setlength( pheromone[i], 0 );
  setlength( pheromone, 0 );
end;

procedure aco_initialize( n_ant, n_node: integer );
var
  i, j              : integer;
  prob, sum         : real;
begin
  num_ant := n_ant;
  num_node := n_node;

  { initialize ants }
  setlength( ants, num_ant );
  for i := 0 to high( ants ) do
    setlength( ants[i].path, num_node );

  { initialize pheromone }
  setlength( pheromone, num_node );
  for i := 0 to high( pheromone ) do begin
    setlength( pheromone[i], num_node );
    sum := 0;
    for j := 0 to high( pheromone[i] ) do begin
      pheromone[i][j] := random;
      sum := sum + pheromone[i][j];
    end;
    for j := 0 to high( pheromone[i] ) do
      pheromone[i][j] := pheromone[i][j] / sum;
  end;
end;

procedure aco_shortest_path;
var
  i, j, ant         : integer;
  step, max_step    : integer;
  is_arrived        : Boolean;
  last_pos          : integer;
  start_pos         : integer;
  target_pos        : integer;
  prob, sum         : real;
  node              : integer;
  sel_node          : integer;
  pdf               : array of real;
  visited           : set of byte;
  cur_best_ant      : integer;
  min_dist          : real;
  best_ant          : TACOSol;
begin
  max_step := 100;
  setlength( pdf, num_node );

  for start_pos := 0 to num_node - 2 do begin
    for target_pos := start_pos + 1 to num_node - 1 do begin

      setlength( best_ant.path, 0 );
      best_ant.total_dist := MAXINT;

      for step := 0 to max_step do begin
        //form1.Memo1.Lines.add( 'putaran ke #' + inttostr( step ) );
        for ant := 0 to num_ant - 1 do begin
          //inisialisasi tiap semut
          is_arrived := False;
          last_pos := start_pos;
          setlength( ants[ant].path, 0 );
          visited := [start_pos];

          repeat
            //buat distribusi peluang
            sum := 0;
            for node := 0 to num_node - 1 do begin
              if ( connectivity[last_pos][node] <> 0 ) and not ( node in visited ) then begin
                pdf[node] := power( pheromone[last_pos][node], pher_pow ) * power( 1.0 / connectivity[last_pos][node], heur_pow );
                sum := sum + pdf[node];
              end
              else
                pdf[node] := 0;
            end;

            //pilih secara acak
            prob := random * sum;

            sel_node := -1;
            for node := 0 to num_node - 1 do begin
              if node in visited then continue;
              if connectivity[last_pos][node] = 0 then continue;
              prob := prob - pdf[node];
              sel_node := node;
              if prob < 1E-3 then
                break;
            end;
            if sel_node < 0 then break;

            //tambahkan node terpilih ke dalam jejak
            with ants[ant] do begin
              setlength( path, length( path ) + 1 );
              path[high( path )] := sel_node;
              visited := visited + [sel_node];
            end;
            last_pos := sel_node;

            //cek terminasi
            if last_pos = target_pos then is_arrived := True;
          until is_arrived;

          //jalur ketemu
          if is_arrived then begin
            //hitung total jarak
            ants[ant].total_dist := connectivity[start_pos][ants[ant].path[0]];
            for i := 0 to high( ants[ant].path ) - 1 do begin
              ants[ant].total_dist := ants[ant].total_dist + connectivity[ants[ant].path[i]][ants[ant].path[i + 1]];
            end;

          end
          else //semut terjebak di jalan buntu
            ants[ant].total_dist := MAXINT;
        end;

        //cari semut dengan jejak terbaik
        min_dist := MAXINT;
        cur_best_ant := -1;
        for ant := 0 to high( ants ) do begin
          if ants[ant].total_dist < min_dist then begin
            min_dist := ants[ant].total_dist;
            cur_best_ant := ant;
          end;
        end;

        if cur_best_ant = -1 then continue; //kalau tidak ada yang berhasil lanjut ke iterasi berikutnya

        //taruh pheromone di jejak semut dengan rute terbaik
        with ants[cur_best_ant] do begin
          pheromone[start_pos][path[0]] := pheromone[start_pos][path[0]] + 1.0 / ( connectivity[start_pos][path[0]] );
          for i := 0 to high( path ) - 1 do
            pheromone[path[i]][path[i + 1]] := pheromone[path[i]][path[i + 1]] + 1.0 / ( connectivity[path[i]][path[i + 1]] );
        end;

        //simpan path cur_best_ant jika lebih baik dari catatan umum terbaik
        if ants[cur_best_ant].total_dist < best_ant.total_dist then begin
          best_ant.total_dist := ants[cur_best_ant].total_dist;
          setlength( best_ant.path, length( ants[cur_best_ant].path ) );
          for i := 0 to high( best_ant.path ) do
            best_ant.path[i] := ants[cur_best_ant].path[i];
        end;

        //penguapan feromon di seluruh jalur
        for i := 0 to high( pheromone ) do
          for j := 0 to high( pheromone[i] ) do
            pheromone[i][j] := ( 1 - evaporation_coeff ) * pheromone[i][j];
      end; { step iterasi }

      //tampilkan jejak semut terbaik
      with TStringlist.Create do begin
        Add( form1.sga.Cells[0, 1 + start_pos] );
        for i := 0 to high( best_ant.path ) do
          Add( form1.sga.Cells[0, 1 + ( best_ant.path[i] )] );
        form1.Memo1.Lines.add( format( '[%s-%s] dist : (%4.2f) path : %s', [form1.sga.Cells[0, 1 + start_pos], form1.sga.Cells[0, 1 + target_pos], best_ant.total_dist, CommaText] ) );
        Free;
      end;

    end; { target pos }
  end; { start pos }

  setlength( pdf, 0 );
end;

end.

