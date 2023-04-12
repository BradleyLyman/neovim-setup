Set-PSReadLineOption -EditMode "Vi" -Colors @{
  Command = [ConsoleColor]::White
  Comment = [ConsoleColor]::White
  ContinuationPrompt = [ConsoleColor]::White
  Emphasis = [ConsoleColor]::White
  Error = [ConsoleColor]::Red
  Keyword = [ConsoleColor]::White
  Member = [ConsoleColor]::White
  Number = [ConsoleColor]::White
  Operator = [ConsoleColor]::White
  Parameter = [ConsoleColor]::White
  Selection = [ConsoleColor]::White
  String = [ConsoleColor]::White
  Type = [ConsoleColor]::White
  Variable = [ConsoleColor]::White

  InlinePrediction = [ConsoleColor]::Magenta
  ListPrediction = [ConsoleColor]::Magenta
  ListPredictionSelected = [ConsoleColor]::Magenta
}

Set-PSReadLineOption -BellStyle Audible -DingDuration 0

Set-PSReadlineKeyHandler -Key Tab -Function Complete

function prompt {
  Write-Host "┏╸" -ForegroundColor Magenta -NoNewLine
  Write-Host $pwd -ForegroundColor DarkYellow

  $branch = & git branch --show-current 2>$null
  if ($branch -ne $null) {
    Set-PSReadLineOption -ExtraPromptLineCount 2
    Write-Host "┣╸" -ForegroundColor Magenta -NoNewLine
    Write-Host "<" -ForegroundColor DarkYellow -NoNewLine
    Write-Host $branch -ForegroundColor Magenta -NoNewLine
    Write-Host ">" -ForegroundColor DarkYellow
  }
  else {
    Set-PSReadLineOption -ExtraPromptLineCount 1
    # Write-Host "┣╸" -ForegroundColor Magenta
  }

  Write-Host "┗" -ForegroundColor Magenta -NoNewLine
  return "╸"
}

Import-Module Color
