class ApartmentPets
{
    [int]
    $UnitNumber
    
    [string]
    $Type

    [int]
    $Count

    ApartmentPets(){}    

    ApartmentPets([int] $UnitNumber, [string] $Type, [int] $Count)
    {
        if ($UnitNumber -lt 1 -or $UnitNumber -gt 100)
        {
            throw [InvalidOperationException]::new(
            "Unit number $UnitNumber is invalid. Must be in range 1-100")
        }

        $maxPets = switch ($Type)
        {
            cat  { 3; break }
            dog  { 2; break }
            fish { 10; break }
            default {
                throw [InvalidOperationException]::new(
                "The allowed pets are dogs, cats & fish. A $type is not allowed")
            }
        }
        if ($count -gt $maxPets)
        {
            throw [InvalidOperationException]::new(
            "You are only allowed to have up to $maxPets pets of type $Type")
        }
        $this.Count = $Count
        $this.Type = $Type
        $this.UnitNumber = $UnitNumber
    }
}
