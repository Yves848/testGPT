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

function Truncate-String {
  param (
      [Parameter(Mandatory = $true)]
      [string]$InputString,

      [Parameter(Mandatory = $true)]
      [int]$MaxWidth
  )

  $ellipsis = "…"
  $ellipsisWidth = Get-DisplayWidth -Str $ellipsis
  $currentWidth = Get-DisplayWidth -Str $InputString

  if ($currentWidth -le $MaxWidth) {
      return $InputString
  }

  $truncatedString = ""
  foreach ($char in $InputString.ToCharArray()) {
      $charWidth = if ([System.Text.Encoding]::UTF8.GetByteCount($char) -gt 1) { 2 } else { 1 }
      if ((Get-DisplayWidth -Str $truncatedString + $charWidth + $ellipsisWidth) -ge ($MaxWidth-1)) {
          break
      }
      $truncatedString += $char
  }

  return $truncatedString + $ellipsis
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

  $InputString = Truncate-String -InputString $InputString -MaxWidth $TotalWidth
  $currentWidth = Get-DisplayWidth -Str $InputString
  $padLength = $TotalWidth - $currentWidth

  if ($padLength -le 0) {
      return $InputString
  }

  switch ($PadDirection.ToLower()) {
      "left" {
          while (Get-DisplayWidth -Str ($PadCharacter + $InputString) -lt $TotalWidth) {
              $InputString = $PadCharacter + $InputString
          }
      }
      "right" {
          while (Get-DisplayWidth -Str ($InputString + $PadCharacter) -lt $TotalWidth) {
              $InputString = $InputString + $PadCharacter
          }
      }
      "both" {
          $leftPad = $rightPad = $PadCharacter
          while ((Get-DisplayWidth -Str ($leftPad + $InputString + $rightPad)) -lt $TotalWidth) {
              $leftPad += $PadCharacter
              if ((Get-DisplayWidth -Str ($leftPad + $InputString + $rightPad)) -lt $TotalWidth) {
                  $rightPad += $PadCharacter
              }
          }
          $InputString = $leftPad + $InputString + $rightPad
      }
      default {
          throw "Invalid PadDirection specified. Use 'Left', 'Right', or 'Both'."
      }
  }

  return $InputString
}

# Example usage:
$PaddedString = Pad-String -InputString "Hello 世界 and beyond" -TotalWidth 20 -PadCharacter "*" -PadDirection "Both"

# Verify the result
"".padleft(20,"#")
$PaddedString
$PaddedString = Pad-String -InputString "Hello 世界" -TotalWidth 20 -PadCharacter "*" -PadDirection "Both"
$PaddedString