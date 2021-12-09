program solution;
{$APPTYPE CONSOLE}
{ Design By: Mr G. Pearl   Email: PearlG@hhs.co.za    2021-12-09
  Continued by: Joshua Blom
  Purpose:
  Demonstrates the testing of the solve 3x + 1 problem in mathematics
  Produces test files containing the values based on the algorithm

  see: http://oeis.org/wiki/3x%2B1_problem

  Limitations:

  Loop is an INTEGER, maximum representation of values
  Test only positive values for x.

}

uses
  SysUtils;

const
  endOn = ' 4 2 1';

var
  iTest, min, max, incBy: Int64;
  updateBy: String;
  deleteInput, deleteLoop: Integer;
  txtOptions: Char;
  tf: Textfile;
  doManyTxt: Boolean;

  { ==============================================================================
  }

function getNext(valueX: Int64): Int64;
begin
  result := 3 * valueX + 1;
end;

function EVEN(valueX: Int64): Boolean;
begin
  result := NOT ODD(valueX);
end;

function endsWITH(startX: Int64; endOn: String): Boolean;
var
  iAm: Int64;
  route: String;
begin
  iAm := startX;
  WriteLN(tf, 'Test Loading: Start with ', startX);

  REPEAT
    iAm := getNext(iAm);
    route := '';
    route := route + ' ' + IntToStr(iAm);

    while EVEN(iAm) do
    begin
      iAm := iAm div 2;
      route := route + ' ' + IntToStr(iAm);
    end;

    WriteLN(tf, route);

  UNTIL route = endOn;

  WriteLN(tf, 'Test Terminating');

  result := TRUE;
end;

{ ==============================================================================
}

function calculatePercentage(value: Int64): Integer;
begin
  result := Round((value / (max - min + 1)) * 100);
end;

var
  status: String;
  last: Integer;

procedure showProgressBar();
var
  loop, completed: Integer;
begin
  status := '';
  completed := calculatePercentage(iTest);
  if last < completed then
  begin
    for loop := last to completed do
      status := status + '#';
    last := calculatePercentage(iTest);
  end;
  Write(status);
end;

{ ==============================================================================
}

procedure noneParameters();
begin
  WriteLN('Testing 3x+1 terminates in 4 2 1 pattern');
  Write('Enter Min: ');
  ReadLN(min);
  Write('Enter Max: ');
  ReadLN(max); // 1607795;
end;

function getInt64FromParam(data: String): Int64;
Begin
  delete(data, 1, 4);
  result := StrToInt64(data);
End;

function getStringFromParam(data, code: String): String;
Begin
  delete(data, 1, Length(code));
  result := data;
End;

procedure someParameters();
var
  iLoop: Integer;
  cmd: String;
begin
  for iLoop := 1 to ParamCount do
  begin
    cmd := lowercase(ParamStr(iLoop));
    WriteLN('Applying: ', cmd);
    if (POS('min=', cmd) > 0) then
      min := getInt64FromParam(ParamStr(iLoop));
    if (POS('max=', cmd) > 0) then
      max := getInt64FromParam(ParamStr(iLoop));
    if (POS('inc=', cmd) > 0) then
      incBy := getInt64FromParam(ParamStr(iLoop));
    if (POS('apply=', cmd) > 0) then
      updateBy := getStringFromParam(ParamStr(iLoop), 'apply=');

  end;
  WriteLN('Testing: ', min, ' to ', max);
end;

{ ==============================================================================
}
procedure run3n();
begin

end;

{ function doManyTxt(txtOptions : String): Boolean;
  begin
  if (txtOptions = 'S') OR (txtOptions = 's') then result := TRUE
  else result := FALSE;

  end; }

{ ==============================================================================
}

begin
  try
    min := 1;
    max := 100;
    incBy := 1;
    updateBy := '+';

    If (ParamCount = 0) Then
      noneParameters()
    Else
      someParameters();

    last := 0;
    Write(
      'How many files from the previous batch do you want to delete? (Type 0 to delete none) ');
    ReadLN(deleteInput);
    write(
      'Do you want to make multiple text files or just one? (L for a single txt file, S for a txt file for every number))');
    ReadLN(txtOptions);

    if (Length(IntToStr(deleteInput)) > 0) then
      for deleteLoop := 0 to deleteInput do

        deleteFile(
          'C:\Users\Cypher\Desktop\School stuff\Side Projects\4 2 1\Test Data\test'
            + IntToStr(deleteLoop) + '.txt');

    Write('Testing: ');
    iTest := min;

    if (txtOptions = 'S') OR (txtOptions = 's') then
      doManyTxt := TRUE
    else
      doManyTxt := FALSE;

    WHILE (iTest <= max) AND (doManyTxt = TRUE) do
    begin

      showProgressBar();

      AssignFile(tf,'C:\Users\Cypher\Desktop\School stuff\Side Projects\4 2 1\Test Data\test'+ IntToStr(iTest) + '.txt');
      Rewrite(tf);

      WriteLN(tf, 'Testing: ', iTest, ' = ', endsWITH(iTest, endOn));
      CloseFile(tf);

      if updateBy = '+' then
        iTest := iTest + incBy
      else if updateBy = '*' then
        iTest := iTest * incBy;

    end
    else if (doManyTxt = FALSE) then
    begin

      AssignFile(tf,
        'C:\Users\Cypher\Desktop\School stuff\Side Projects\4 2 1\Test Data\output.txt');
      Rewrite(tf);

      WHILE (iTest <= max) do
      begin

        showProgressBar();

        WriteLN(tf, 'Testing: ', iTest, ' = ', endsWITH(iTest, endOn));
        CloseFile(tf);

        if updateBy = '+' then
          iTest := iTest + incBy
        else if updateBy = '*' then
          iTest := iTest * incBy;

      end;
    end;

    WriteLN;
    WriteLN('Application Run Successfully');
    ReadLN;
  except
    on E: Exception do
      WriteLN(E.ClassName, ': ', E.Message);
  end;

end.
