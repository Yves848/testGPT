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
          while ($InputString.Length -lt $TotalWidth) {
              $InputString = $PadCharacter + $InputString
          }
      }
      "right" {
          while ($InputString.Length -lt $TotalWidth) {
              $InputString = $InputString + $PadCharacter
          }
      }
      "both" {
          while ($InputString.Length -lt $TotalWidth) {
              $InputString = $PadCharacter + $InputString + $PadCharacter
          }
      }
      default {
          throw "Invalid PadDirection specified. Use 'Left', 'Right', or 'Both'."
      }
  }

  return $InputString
}

# Example usage:
$PaddedString = Pad-String -InputString "Hello 世界" -TotalWidth 20 -PadCharacter "*" -PadDirection "Both"

# Verify the length
$PaddedString
"".padleft(20,"#")
# $PaddedString.Length
# Get-DisplayWidth -Str $PaddedString
