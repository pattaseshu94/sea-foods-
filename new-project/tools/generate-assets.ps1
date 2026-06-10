Add-Type -AssemblyName System.Drawing

function New-Canvas {
  param([int]$Width, [int]$Height)
  $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
  return @{ Bitmap = $bitmap; Graphics = $graphics }
}

function Fill-Background {
  param($Graphics, [int]$Width, [int]$Height, [string]$Top, [string]$Bottom)
  $rect = New-Object System.Drawing.Rectangle 0, 0, $Width, $Height
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.ColorTranslator]::FromHtml($Top)), ([System.Drawing.ColorTranslator]::FromHtml($Bottom)), 90
  $Graphics.FillRectangle($brush, $rect)
  $brush.Dispose()
}

function Draw-Label {
  param($Graphics, [string]$Text, [int]$Y)
  $font = New-Object System.Drawing.Font "Arial", 24, ([System.Drawing.FontStyle]::Bold)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#13201e"))
  $format = New-Object System.Drawing.StringFormat
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $Graphics.DrawString($Text, $font, $brush, (New-Object System.Drawing.RectangleF 0, $Y, 900, 50), $format)
  $format.Dispose()
  $brush.Dispose()
  $font.Dispose()
}

function Draw-Fish {
  param($Graphics, [int]$X, [int]$Y, [int]$Scale, [string]$Color)
  $body = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml($Color))
  $dark = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#0f6c76"))
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $Graphics.FillEllipse($body, $X, $Y, (260 * $Scale / 100), (110 * $Scale / 100))
  $tail = @(
    [System.Drawing.Point]::new($X + (250 * $Scale / 100), $Y + (55 * $Scale / 100)),
    [System.Drawing.Point]::new($X + (335 * $Scale / 100), $Y),
    [System.Drawing.Point]::new($X + (335 * $Scale / 100), $Y + (110 * $Scale / 100))
  )
  $Graphics.FillPolygon($body, $tail)
  $Graphics.FillEllipse($white, $X + (52 * $Scale / 100), $Y + (28 * $Scale / 100), (22 * $Scale / 100), (22 * $Scale / 100))
  $Graphics.FillEllipse($dark, $X + (60 * $Scale / 100), $Y + (35 * $Scale / 100), (8 * $Scale / 100), (8 * $Scale / 100))
  $body.Dispose(); $dark.Dispose(); $white.Dispose()
}

function Draw-KingFishPhotoStyle {
  param($Graphics, [int]$X, [int]$Y)
  $bodyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#c7d6dc"))
  $topBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#6f8793"))
  $linePen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#405762")), 4
  $thinPen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#31464f")), 2
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $dark = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#13201e"))

  $bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $bodyPath.AddBezier($X + 70, $Y + 170, $X + 185, $Y + 55, $X + 520, $Y + 62, $X + 680, $Y + 155)
  $bodyPath.AddBezier($X + 680, $Y + 155, $X + 500, $Y + 238, $X + 190, $Y + 246, $X + 70, $Y + 170)
  $Graphics.FillPath($bodyBrush, $bodyPath)
  $Graphics.DrawPath($linePen, $bodyPath)

  $topPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $topPath.AddBezier($X + 120, $Y + 145, $X + 255, $Y + 85, $X + 500, $Y + 88, $X + 650, $Y + 145)
  $topPath.AddLine($X + 645, $Y + 164, $X + 110, $Y + 168)
  $topPath.CloseFigure()
  $Graphics.FillPath($topBrush, $topPath)

  $tail = @(
    [System.Drawing.Point]::new($X + 660, $Y + 155),
    [System.Drawing.Point]::new($X + 820, $Y + 65),
    [System.Drawing.Point]::new($X + 750, $Y + 160),
    [System.Drawing.Point]::new($X + 820, $Y + 260)
  )
  $Graphics.FillPolygon($bodyBrush, $tail)
  $Graphics.DrawPolygon($linePen, $tail)

  $dorsal = @(
    [System.Drawing.Point]::new($X + 335, $Y + 92),
    [System.Drawing.Point]::new($X + 400, $Y + 5),
    [System.Drawing.Point]::new($X + 430, $Y + 103)
  )
  $Graphics.FillPolygon($topBrush, $dorsal)
  $Graphics.DrawPolygon($thinPen, $dorsal)

  $fin = @(
    [System.Drawing.Point]::new($X + 350, $Y + 205),
    [System.Drawing.Point]::new($X + 440, $Y + 280),
    [System.Drawing.Point]::new($X + 420, $Y + 198)
  )
  $Graphics.FillPolygon($bodyBrush, $fin)
  $Graphics.DrawPolygon($thinPen, $fin)

  for ($i = 0; $i -lt 12; $i++) {
    $startX = $X + 165 + ($i * 38)
    $Graphics.DrawLine($thinPen, $startX, $Y + 160, $startX + 16, $Y + 132)
  }

  $Graphics.FillEllipse($white, $X + 102, $Y + 145, 30, 30)
  $Graphics.FillEllipse($dark, $X + 113, $Y + 154, 10, 10)
  $Graphics.DrawLine($thinPen, $X + 76, $Y + 170, $X + 30, $Y + 190)
  $Graphics.DrawLine($thinPen, $X + 76, $Y + 170, $X + 28, $Y + 152)

  $bodyPath.Dispose(); $topPath.Dispose()
  $bodyBrush.Dispose(); $topBrush.Dispose(); $linePen.Dispose(); $thinPen.Dispose(); $white.Dispose(); $dark.Dispose()
}

function Draw-Prawn {
  param($Graphics, [int]$X, [int]$Y)
  $pen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#d5523f")), 16
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $Graphics.DrawArc($pen, $X, $Y, 210, 150, 200, 260)
  $thin = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#f6bd47")), 5
  $Graphics.DrawLine($thin, $X + 168, $Y + 28, $X + 230, $Y - 18)
  $Graphics.DrawLine($thin, $X + 170, $Y + 30, $X + 245, $Y + 22)
  $pen.Dispose(); $thin.Dispose()
}

function Draw-Crab {
  param($Graphics, [int]$X, [int]$Y)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml("#d5523f"))
  $pen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#8f2f24")), 8
  $Graphics.FillEllipse($brush, $X + 80, $Y + 60, 180, 120)
  $Graphics.DrawLine($pen, $X + 75, $Y + 105, $X + 10, $Y + 70)
  $Graphics.DrawLine($pen, $X + 265, $Y + 105, $X + 330, $Y + 70)
  $Graphics.DrawLine($pen, $X + 115, $Y + 175, $X + 70, $Y + 220)
  $Graphics.DrawLine($pen, $X + 225, $Y + 175, $X + 270, $Y + 220)
  $Graphics.FillEllipse($brush, $X, $Y + 35, 58, 58)
  $Graphics.FillEllipse($brush, $X + 286, $Y + 35, 58, 58)
  $brush.Dispose(); $pen.Dispose()
}

function Draw-Squid {
  param($Graphics, [int]$X, [int]$Y)
  $pen = New-Object System.Drawing.Pen ([System.Drawing.ColorTranslator]::FromHtml("#f6bd47")), 18
  for ($i = 0; $i -lt 4; $i++) {
    $Graphics.DrawEllipse($pen, $X + ($i * 64), $Y + (($i % 2) * 24), 86, 58)
  }
  $pen.Dispose()
}

function Save-Image {
  param([string]$Path, [scriptblock]$Draw)
  $canvas = New-Canvas 900 650
  Fill-Background $canvas.Graphics 900 650 "#e8f5f0" "#ffffff"
  & $Draw $canvas.Graphics
  $canvas.Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $canvas.Graphics.Dispose()
  $canvas.Bitmap.Dispose()
}

$assetDir = Join-Path (Split-Path $PSScriptRoot -Parent) "assets"

Save-Image (Join-Path $assetDir "king-fish.png") {
  param($g)
  Draw-KingFishPhotoStyle $g 30 170
}

Save-Image (Join-Path $assetDir "pomfret.png") {
  param($g)
  Draw-Fish $g 260 215 120 "#d7e0df"
  Draw-Label $g "White Pomfret" 510
}

Save-Image (Join-Path $assetDir "seer-fish.png") {
  param($g)
  Draw-Fish $g 235 220 130 "#aebfc4"
  Draw-Label $g "Seer Fish" 510
}

Save-Image (Join-Path $assetDir "mackerel.png") {
  param($g)
  Draw-Fish $g 245 225 125 "#91aeb2"
  Draw-Label $g "Indian Mackerel" 510
}

Save-Image (Join-Path $assetDir "hilasa.png") {
  param($g)
  Draw-Fish $g 245 225 125 "#c7c9b6"
  Draw-Label $g "Hilasa" 510
}

Save-Image (Join-Path $assetDir "pulasa.png") {
  param($g)
  Draw-Fish $g 245 225 125 "#b7c8cc"
  Draw-Label $g "Pulasa" 510
}

Save-Image (Join-Path $assetDir "tiger-prawns.png") {
  param($g)
  Draw-Prawn $g 300 220
  Draw-Prawn $g 390 280
  Draw-Label $g "Tiger Prawns" 510
}

Save-Image (Join-Path $assetDir "mud-crab.png") {
  param($g)
  Draw-Crab $g 270 190
  Draw-Label $g "Live Mud Crab" 510
}

Save-Image (Join-Path $assetDir "squid-rings.png") {
  param($g)
  Draw-Squid $g 280 245
  Draw-Label $g "Squid Rings" 510
}

Save-Image (Join-Path $assetDir "hero-seafood.png") {
  param($g)
  Draw-Fish $g 120 140 110 "#b9ced0"
  Draw-Prawn $g 430 155
  Draw-Crab $g 420 305
  Draw-Squid $g 110 390
  Draw-Label $g "PNM Sea Foods" 535
}
