function Get-DisplayWidth {
    param (
        [string]$Str
    )
    $width = 0
    foreach ($char in $Str.ToCharArray()) {
        if ([System.Text.Encoding]::UTF8.GetByteCount($char) -gt 1) {
            $width += 2
        } else {
            $width += 1
        }
    }
    return $width
}

function Pad-String {
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputString,

        [Parameter(Mandatory = $true)]
        [int]$TotalWidth,

        [Parameter(Mandatory = $false)]
        [string]$PadCharacter = " ",

        [Parameter(Mandatory = $false)]
        [string]$PadDirection = "Right" # Options: Left, Right, Both
    )

    $currentWidth = Get-DisplayWidth -Str $InputString
    $padLength = $TotalWidth - $currentWidth

    if ($padLength -le 0) {
        return $InputString
    }

    switch ($PadDirection.ToLower()) {
        "left" {
            $leftPadding = ""
            while ((Get-DisplayWidth -Str ($leftPadding + $InputString)) -lt $TotalWidth) {
                $leftPadding += $PadCharacter
            }
            return $leftPadding + $InputString
        }
        "right" {
            $rightPadding = ""
            while ((Get-DisplayWidth -Str ($InputString + $rightPadding)) -lt $TotalWidth) {
                $rightPadding += $PadCharacter
            }
            return $InputString + $rightPadding
        }
        "both" {
            $leftPadding = ""
            $rightPadding = ""
            while ((Get-DisplayWidth -Str ($leftPadding + $InputString + $rightPadding)) -lt $TotalWidth) {
                if ((Get-DisplayWidth -Str ($leftPadding + $InputString + $rightPadding)) % 2 -eq 0) {
                    $leftPadding += $PadCharacter
                } else {
                    $rightPadding += $PadCharacter
                }
            }
            return $leftPadding + $InputString + $rightPadding
        }
        default {
            throw "Invalid PadDirection specified. Use 'Left', 'Right', or 'Both'."
        }
    }
}

# Example usage:
$PaddedString = Pad-String -InputString "Hello 世界" -TotalWidth 20 -PadCharacter "*" -PadDirection "Right"

# Verify the length
$PaddedString
"".padleft(20,"#")
# $PaddedString.Length
# Get-DisplayWidth -Str $PaddedString
