# Demo de /auto-tester para o README — gera auto-tester/demo.gif
# Reprodução encenada via demo/bin/claude (VHS grava um shell, não o REPL do Claude Code).
Output auto-tester/demo.gif

Set Shell bash
Set FontSize 15
Set Width 1180
Set Height 580
Set Padding 26
Set TypingSpeed 55ms
Set Theme "Catppuccin Mocha"

Hide
Type 'export PATH="$PWD/demo/bin:$HOME/.local/bin:$PATH"; clear'
Enter
Show

Sleep 600ms
Type 'claude "/auto-tester routes/validators.py --focus security"'
Sleep 900ms
Enter
Sleep 9s
