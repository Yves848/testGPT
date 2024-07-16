# Calculate the width of columns in a table based on their initial % widths
class column {
  [string]$DisplayName
  [string]$PropertyName
  [int]$Width
  [string]$Align
  [int]$ExactWidth

  column([string]$displayName, [string]$propertyName, [int]$width) {
      $this.DisplayName = $displayName
      $this.PropertyName = $propertyName
      $this.Width = $width
      # $this.Align = $align
  }
}

$cols = @()
$cols += [column]::new("Name", "Name", 35)
$cols += [column]::new("Id", "Id", 35)
$cols += [column]::new("InstalledVersion", "Version", 17)
$cols += [column]::new("Source", "Source", 13)
$maxwidth = 136

# Calculate the total width of all columns
$totalWidth = ($cols | Measure-Object -Property Width -Sum).Sum

# Calculate the percentage width for each column relative to $maxwidth and floor the values
$calculatedWidths = @{}
$cols | ForEach-Object {
  $colWidthPercentage = $_.Width / $totalWidth
  $calculatedWidth = [math]::Floor($maxwidth * $colWidthPercentage)
  $calculatedWidths[$_.DisplayName] = $calculatedWidth
}

# Calculate the sum of calculated widths
$sumCalculatedWidths = ($calculatedWidths.Values | Measure-Object -Sum).Sum

# Distribute the remaining width to columns
$remainingWidth = $maxwidth - $sumCalculatedWidths

# Sort columns by their initial widths to fairly distribute the remaining width
$sortedCols = $calculatedWidths.Keys | Sort-Object { $calculatedWidths[$_] }
for ($i = 0; $i -lt $remainingWidth; $i++) {
  $colName = $sortedCols[$i % $sortedCols.Count]
  $calculatedWidths[$colName] += 1
}

# Output the final widths
foreach ($col in $cols) {
  $col.ExactWidth = $calculatedWidths[$col.DisplayName]
  Write-Output "Column: $($col.DisplayName), Exact Width: $($col.ExactWidth)"
}
