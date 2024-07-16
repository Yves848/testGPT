# Path: psCandy.psm1

# Define theme structure
class Theme {
  [Hashtable]$BorderTypes
  [string]$TextColor
  [string]$BackgroundColor

  Theme([Hashtable]$borderTypes, [string]$textColor, [string]$backgroundColor) {
      $this.BorderTypes = $borderTypes
      $this.TextColor = $textColor
      $this.BackgroundColor = $backgroundColor
  }
}

# Define available themes
$Themes = @{
  "Normal" = [Theme]::new(@{
      "Top"          = "─"
      "Bottom"       = "─"
      "Left"         = "│"
      "Right"        = "│"
      "TopLeft"      = "┌"
      "TopRight"     = "┐"
      "BottomLeft"   = "└"
      "BottomRight"  = "┘"
      "MiddleLeft"   = "├"
      "MiddleRight"  = "┤"
      "Middle"       = "┼"
      "MiddleTop"    = "┬"
      "MiddleBottom" = "┴"
  }, "255", "0")
  "Rounded" = [Theme]::new(@{
      "Top"          = "─"
      "Bottom"       = "─"
      "Left"         = "│"
      "Right"        = "│"
      "TopLeft"      = "╭"
      "TopRight"     = "╮"
      "BottomLeft"   = "╰"
      "BottomRight"  = "╯"
      "MiddleLeft"   = "├"
      "MiddleRight"  = "┤"
      "Middle"       = "┼"
      "MiddleTop"    = "┬"
      "MiddleBottom" = "┴"
  }, "44", "0")
  # Add more themes as needed
}

# Global variable for current theme
$Global:CurrentTheme = $Themes["Normal"]

# Function to switch theme
function Set-Theme {
  param (
      [string]$themeName
  )
  if ($Themes.ContainsKey($themeName)) {
      $Global:CurrentTheme = $Themes[$themeName]
  } else {
      Write-Error "Theme '$themeName' does not exist."
  }
}

# Function to get border character from the current theme
function Get-BorderChar {
  param (
      [string]$borderPart
  )
  return $Global:CurrentTheme.BorderTypes[$borderPart]
}

# Function to apply color formatting
function Apply-Color {
  param (
      [string]$text
  )
  $textColor = $Global:CurrentTheme.TextColor
  $backgroundColor = $Global:CurrentTheme.BackgroundColor
  return "$([char]27)[38;5;$($textColor)m$([char]27)[48;5;$($backgroundColor)m$text$([char]27)[0m"
}

# One-liner function to print styled text with borders
function Write-Candy {
  param (
      [string]$text
  )
  $borderTop = (Get-BorderChar -borderPart "TopLeft") + ("".padleft(($text.Length + 2),(Get-BorderChar -borderPart "Top"))) + (Get-BorderChar -borderPart "TopRight")
  $borderMiddle = (Get-BorderChar -borderPart "Left") + " " + (Apply-Color -text $text) + " " + (Get-BorderChar -borderPart "Right")
  $borderBottom = (Get-BorderChar -borderPart "BottomLeft") + ("".padleft(($text.Length + 2),(Get-BorderChar -borderPart "Bottom"))) + (Get-BorderChar -borderPart "BottomRight")

  Write-Output $borderTop
  Write-Output $borderMiddle
  Write-Output $borderBottom
}

# Example usage
Set-Theme -themeName "Normal"
Write-Candy -text "Hello, World! 📜 実験版"
