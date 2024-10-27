# test.ps1

# Load the user32.dll library
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int MessageBox(int hWnd, string text, string caption, int type);
}
"@

# Display a simple message box
[User32]::MessageBox(0, "Hey", "Greeting", 1)

# -----
