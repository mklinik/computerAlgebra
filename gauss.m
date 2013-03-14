function firstNonZeroRow(col, M)
  for row := col to NumberOfRows(M) do
    if M[row,col] ne 0
      then return row; // found a row with non-zero element
    end if;
  end for;

  return 0; // none found
end function;

procedure gaussSimple(~M)
  // for each max(columns, rows):
  for col := 1 to Min(NumberOfRows(M), NumberOfColumns(M)) do
    // find a row fnz where the first element is not zero
    fnz := firstNonZeroRow(col, M);
    if fnz ne 0 then
      // swap fnz with the current row
      SwapRows(~M, col, fnz);
      // for each row below the current row:
      for cur2 := col + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        //   multiply with inverse of 1st elt
        //   and subtract multiple of col from cur2
        curElt := M[cur2, col];
        if curElt ne 0 then
          MultiplyRow(~M, 1/curElt, cur2);
          AddRow(~M, -1/M[col,col], col, cur2);
        end if;
      end for;
    end if;
  end for;
end procedure;

procedure gaussDivisionFree(~M)
  // for each max(columns, rows):
  for col := 1 to Min(NumberOfRows(M), NumberOfColumns(M)) do
    // find a row fnz where the first element is not zero
    fnz := firstNonZeroRow(col, M);
    if fnz ne 0 then
      // swap fnz with the current row
      SwapRows(~M, col, fnz);
      // for each row below the current row:
      for cur2 := col + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        curElt := M[cur2, col];
        if curElt ne 0 then
          for j := col to NumberOfColumns(M) do
            M[cur2,j] :=
              M[col,col] * M[cur2,j] - M[col,j] * curElt;
          end for;
        end if;
      end for;
    end if;
  end for;
end procedure;

procedure test()
  SetSeed(0);

  /*m := RandomMatrix(FiniteField(13), 5, 15);*/

  /*m := Matrix(RationalField(), 6, 4,*/
  /*[[1, 1, 2, 3]*/
  /*,[2, 5, 6, 7]*/
  /*,[3, 9, 6, 1]*/
  /*,[4, 3, 4, 5]*/
  /*,[4, 3, 4, 5]*/
  /*,[4, 3, 4, 5]*/
  /*]);*/

  // the example on page 392
  m := Matrix(IntegerRing(), 4, 5,
    [[ 3,  4, -2,  1, -2]
    ,[ 1, -1,  2,  2,  7]
    ,[ 4, -3,  4, -3,  2]
    ,[-1,  1,  6, -1,  1]
    ]);

  print m;
  print "-----";
  /*print firstNonZeroRow(1, m);*/
  gaussDivisionFree(~m);
  /*gaussSimple(~m);*/
  print m;
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
