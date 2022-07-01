##
##  create individual arrays
$b = 0,1,2
$c = 0,1,2,3,4
$d = "Hello","world"
$e = 0,1,2,3
$f = ,0
$g = 0,1

## create jagged array
$a = $b,$c,$d,$e,$f,$g

## test jagged array access
$a[0][2]
$a[1][4]
$a[2][1]
$a[3][3]
$a[4][0]
$a[5][1]