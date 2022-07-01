param(
$a,
$b
) 
begin
{
    $c = 0; "Begin c = $c"
}
process
{
    $c++
    "Hello to $a from $b.  c = $c"
}
end
{
#    "End c = $c"
}