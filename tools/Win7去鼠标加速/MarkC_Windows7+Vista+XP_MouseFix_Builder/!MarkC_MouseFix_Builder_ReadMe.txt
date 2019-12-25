The MarkC Windows 7 & Vista & XP Mouse Acceleration Fix Builder
===============================================================

http://donewmouseaccel.blogspot.com/2010/04/markc-mouse-acceleration-fix-builder.html

WHAT IS IT?

It is a VBS script program that creates a registry .REG file that removes
Windows' mouse acceleration for Windows 7 or Vista or XP.

The registry fix created works like the CPL and Cheese and MarkC fixes,
but is customized for your specific desktop display text size (DPI),
your specific mouse pointer speed slider setting, your specific refresh rate
and has any in-game pointer scaling/sensitivity factor you want (see note).

For older games that turn acceleration on, it gives the same response as position
6/11 does (1-to-1), without having to move the pointer speed slider to 6/11.
(Yeah, I know : "Whoop-de-do...")

Exactly 1-to-1 means no discarded or delayed mouse input while game playing.

Other Registry fixes need the pointer speed slider set to 6/11 (middle) to get
exactly 1-to-1 in-game mouse to pointer response, but this script can create 
a registry fix that gives exact 1-to-1 in-game response for non-6/11 settings.

Other registry fixes only provide files for some pre-defined display DPI
values: 100%, 125%..., but this script can create a fix for any DPI setting.

The Cheese registry fixes only provides files for some pre-defined monitor
refresh rate values: 60Hz, 70Hz, but this script can create a fix for any
refresh rate setting.

This script can create a fix with any in-game mouse-to-pointer scaling factor
you want (see note).

NOTE: ALL registry based mouse fixes, INCLUDING this one, ONLY work when the
Control Panel > Mouse > 'Enhance pointer precision' option is ON, OR when an
older game forces 'Enhance pointer precision' to ON.
Most newer games do not force 'Enhance pointer precision' to ON and this mouse
fix will have no effect for those games.


EH? WHAT IS IT AGAIN?

A mostly pointless sledgehammer solution to the problem of having to change
your Control Panel > Mouse > pointer speed slider to 6/11 before you play an
older game that needs a registry fix so you can avoid at most a single pixel
of discarded or delayed mouse input while game playing...

An interesting programming exercise!


HOW DO YOU USE IT?

- In Windows Explorer, double-click MarkC_Windows7+Vista+XP_MouseFix_Builder.vbs,
  or double-click MarkC_Windows7+Vista+XP_MouseFix_Builder.CMD.

- Verify or edit the suggested settings, clicking OK as you go.

- Add/Merge the created fix to the registry.
  (See below for non-Administrator account use.)

- Reboot or Log off to apply the fix (you have to reboot or Log off).

- Enjoy exactly 1-to-1 mouse to pointer response for your custom desktop settings!


WHY DO YOU NEED A FIX?
Some older games turn Windows mouse acceleration on when you don't want them to.
See for more details:
http://donewmouseaccel.blogspot.com/2010/03/markc-windows-7-mouse-acceleration-fix.html#why


HOW DOES THE FIX WORK?

The current system is queried, and you can change the values and tune the
registry fix file created.

The result is saved to a file and can optionally be imported into the registry.

The script asks for:
- Operating system that the fix will be used for.
- The desktop Control Panel, Display, text size (DPI) that will be used.
- The in-game monitor refresh rate that will be used (XP and Vista only).
- The Control Panel, Mouse, pointer speed slider position that will be used.
- The pointer speed scaling (sensitivity) factor for that pointer speed setting.
- Where you want to save the fix to and what name.

It creates a registry .reg file with the settings entered, and
optionally lets you merge / apply it into the registry.


HOW DO YOU KNOW THE FIX IS WORKING?

You can test if it is working by temporarily turning on the 'Enhance
pointer precision' feature and see how the mouse responds.
(NOTE: Only turn 'Enhance pointer precision' on for testing: it should 
 normally be set OFF.)

If you have 'Enhance pointer precision' OFF, then the fix will not be active
(but it will be waiting to be activated when needed).
Just as some games turn it on when you don't want them to, we can turn it on
manually to test that the fix is working properly.

- Go to Control Panel, and select Hardware and Sound, then click Mouse.
  Select 'Pointer options' and check-ON/enable the 'Enhance pointer
  precision' option.

- See how the mouse responds.

- If you want, you can run the MouseMovementRecorder.exe program that is
  included in the ZIP file to see that the mouse and pointer movements are
  1-to-1 and always the same (or are whatever custom scaling you entered).
  (The numbers in the MOUSE MOVEMENT column should be the same as the
   numbers in the POINTER MOVEMENT column. Any differences will appear in
   green or red. If you do sometimes see differences, also test with
   'Enhance pointer precision' OFF, in case the problem is with Windows or
   MouseMovementRecorder.exe rather than a problem with the fix.)

- Turn the 'Enhance pointer precision' option OFF when you have finished testing.


HOW DO YOU REMOVE IT?

- Open the ZIP file at the link above. 
- Select 'WindowsDefault.reg' and Double-click it. 
- Answer Yes, OK to the prompts that appear. 
- Reboot or Log off.


LOADING THE FIX ON WINDOWS 7 WITH A NON-ADMINISTRATOR ACCOUNT

On Windows 7, when adding the mouse acceleration fix to the registry,
you may get one of these error messages:

"Cannot import (filename).reg: Not all data was successfully written to the registry."

"Part of the mouse acceleration fix can't be applied,
 because you are not logged in as an Administrator."

This error happens because part of the fix turns off acceleration for the
Welcome screen (the log on screen).
If you use the Welcome screen (or the Windows Log in dialog) and acceleration
is NOT turned off for the Welcome screen, then the MarkC fixes have a 1 pixel
/ 1 mouse count error when the mouse changes direction left/right or up/down.

You can remove this 1 mouse count error by any of these methods:

- Run Disable_WelcomeScreen+Login_Accel.CMD as Administrator
  (Right-click > Run as administrator).
- Run MarkC_Windows7+Vista+XP_MouseFix_Builder.CMD as Administrator.
- Add/Merge Disable_WelcomeScreen+Login_Accel.reg to the registry
  while logged in as an administrator.
- Run RegEdit.exe and edit 'HKEY_USERS\.DEFAULT\Control Panel\Mouse\MouseSpeed'
  to 0 (zero), while logged in as an administrator.
- Not moving or touching the mouse while using the Welcome screen
  (use arrow keys to select the user and Enter key to log in).
- Ignoring the 1 mouse count error! It's only a single count: You won't notice it.


Credits: hoppan and scandalous for debugging and testing, Microsoft for inspiration.