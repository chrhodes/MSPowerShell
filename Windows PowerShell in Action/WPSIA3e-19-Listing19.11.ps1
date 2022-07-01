using module apartmentpets 

class apartmentpets2 : apartmentpets 
{
    [string]
    $Notes
}

$apEntry = [apartmentpets2] @{ 
                Type = "dog"
                Count = 1
                UnitNumber = 66
                Notes = "very friendly" 
            }

$apEntry | Format-List 