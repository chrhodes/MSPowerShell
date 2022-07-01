Update-TypeData -TypeName System.Array -MemberName Sum -MemberType ScriptMethod -Value {
  $r=$null
  foreach ($e in $this) {$r += $e}
  $r
} -Force

"`nSum array of numbers:"
(1,2,3,4,5).Sum()

"`nSum array of strings:"
("abc","def","ghi").Sum()

"`nSum array of hashtables:"
(@{a=1},@{b=2},@{c=3}).Sum()

"`nPut string back together:"
([char[]] "hal" | foreach{[char]([int]$_+1)}).Sum()

Remove-TypeData -TypeName System.Array

"`nSum array of numbers:"
(1,2,3,4,5).Sum()