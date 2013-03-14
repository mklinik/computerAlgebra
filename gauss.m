function firstNonZeroRow(col, M)
  for row := col to NumberOfRows(M) do
    if M[row,col] ne 0
      then return row; // found a row with non-zero element
    end if;
  end for;

  return 0; // none found
end function;

procedure gauss(~M)
  // for each max(columns, rows):
  for cur := 1 to Min(NumberOfRows(M), NumberOfColumns(M)) do
    // find a row j where the first element is not zero
    j := firstNonZeroRow(cur, M);
    if j ne 0 then
      // swap j with the current row
      SwapRows(~M, cur, j);
      // for each row below the current row:
      for cur2 := cur + 1 to NumberOfRows(M) do
        // if 1st element is non-zero,
        //   multiply with inverse of 1st elt
        //   and subtract multiple of cur from cur2
        curElt := M[cur2, cur];
        if curElt ne 0 then
          MultiplyRow(~M, 1/curElt, cur2);
          AddRow(~M, -1/M[cur,cur], cur, cur2);
        end if;
      end for;
    end if;
  end for;
end procedure;

procedure test()
  SetSeed(0);
  m := RandomMatrix(FiniteField(13), 5, 5);
  /*m := Matrix(RationalField(), 6, 4,*/
  /*[[1, 1, 2, 3]*/
  /*,[2, 5, 6, 7]*/
  /*,[3, 9, 6, 1]*/
  /*,[4, 3, 4, 5]*/
  /*,[4, 3, 4, 5]*/
  /*,[4, 3, 4, 5]*/
  /*]);*/
  print m;
  print "-----";
  /*print firstNonZeroRow(1, m);*/
  gauss(~m);
  print m;
end procedure;

// vim: ft=magma expandtab ts=2 sw=2
