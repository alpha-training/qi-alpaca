\d .alpaca
norm.Etrades:{
  ("P"$-1_x`t; / time stamp 
   `$x`S; / Sym
   "f"$x`p;  / price
   "j"$x`s;  / size
   `$x`x)  / exchange
 }

norm.Equotes:{
    ("P"$-1_x`t; /timestamp
    `$x`S; /sym
    `$x`bx; /b exc
    "f"$x`bp; /bprice
    "j"$x`bs; /bsize
    `$x`ax; /aex
    "f"$x`ap; /ap
    "j"$x`as) /as
 }

norm.Ebars:{
    ("P"$-1_x`t; / Start Time 
    `$x`S; / Sym
    9h$x`o;  / Open
    9h$x`h;  / High
    9h$x`l; / Low
    9h$x`c; / Close
    9h$x`vw; / VWAP
    7h$x`v)  / Volume
 }

norm.Ctrades:{
  ("P"$-1_x`t; / time stamp 
   `$x`S; / Sym
   "f"$x`p;  / price
   "f"$x`s;  / size
   `$raze x`tks)
 }

norm.Cquotes:{
  ("P"$-1_x`t; /timestamp
    `$x`S; /sym
    "f"$x`bp; /bprice
    "f"$x`bs; /bsize
    "f"$x`ap; /ap
    "f"$x`as) /as
 }

norm.Cbars:{
  ("P"$-1_x`t; / Start Time 
    `$x`S; / Sym
    9h$x`o;  / Open
    9h$x`h;  / High
    9h$x`l; / Low
    9h$x`c; / Close
    9h$x`vw; / VWAP
    7h$x`v; / volume
    "j"$x`n) / Count
 }