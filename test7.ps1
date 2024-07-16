class candyString {
  static [int] GetDisplayWidth([string] $Str) {
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
}