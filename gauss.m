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
    // find a row 'fnz' where the col-th element is not zero
    fnz := firstNonZeroRow(col, M);
    if fnz ne 0 then
      // swap fnz with the current row
      SwapRows(~M, col, fnz);
      // for each row below the current row:
      for row := col + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        //   multiply with inverse of 1st elt
        //   and subtract multiple of col from row
        curElt := M[row, col];
        if curElt ne 0 then
          MultiplyRow(~M, 1/curElt, row);
          AddRow(~M, -1/M[col,col], col, row);
        end if;
      end for;
    end if;
  end for;
end procedure;

procedure gaussDivisionFree(~M)
  // for each max(columns, rows):
  for col := 1 to Min(NumberOfRows(M), NumberOfColumns(M)) do
    // find a row fnz where the col-th element is not zero
    fnz := firstNonZeroRow(col, M);
    if fnz ne 0 then
      // swap fnz with the current row
      SwapRows(~M, col, fnz);
      // for each row below the current row:
      for row := col + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        curElt := M[row, col];
        if curElt ne 0 then
          for j := col to NumberOfColumns(M) do
            M[row,j] :=
              M[col,col] * M[row,j] - M[col,j] * curElt;
          end for;
        end if;
      end for;
    end if;
  end for;
end procedure;

procedure gaussFractionFree(~M)
  // for each max(columns, rows):
  divisor := 1;
  for col := 1 to Min(NumberOfRows(M), NumberOfColumns(M)) do
    // find a row fnz where the col-th element is not zero
    fnz := firstNonZeroRow(col, M);
    if fnz ne 0 then
      // swap fnz with the current row
      SwapRows(~M, col, fnz);
      // for each row below the current row:
      for row := col + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        curElt := M[row, col];
        if curElt ne 0 then
          // update all elements in this row
          for j := col to NumberOfColumns(M) do
            M[row,j] :=
              (M[col,col] * M[row,j] - M[col,j] * curElt) / divisor;
          end for;
        end if;
      end for;
    end if;
    divisor := M[col, col];
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
  /*m := Matrix(IntegerRing(), 4, 5,*/
    /*[[ 3,  4, -2,  1, -2]*/
    /*,[ 1, -1,  2,  2,  7]*/
    /*,[ 4, -3,  4, -3,  2]*/
    /*,[-1,  1,  6, -1,  1]*/
    /*]);*/

  print m;
  /*n := m; gaussSimple(~n); print n;*/
  n := m; gaussDivisionFree(~n); print "-----", n;
  n := m; gaussFractionFree(~n); print "-----", n;
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
