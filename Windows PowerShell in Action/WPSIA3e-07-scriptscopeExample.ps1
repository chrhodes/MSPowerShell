## set
##  $a=1; $b=2; $c=3; $d=4
## before running the script
##
$b = 20
function one {$b=200; $c = 300; two}
function two {$d = 4000; "$a $script:b $c $d" }
one