function ConvertFrom-Bit {
    param (
        $bit
    )
    [int]$int = 0
    $bits = $bit.ToString().ToCharArray()
    $index = ($bits.Count)-1
    foreach ($b in $bits) {
        if ($b -notlike 0) {
            $int += [math]::Pow(2,$index)
        }
    $index -= 1
    }
    $int
}