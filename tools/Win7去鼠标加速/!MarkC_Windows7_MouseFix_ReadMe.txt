The MarkC Windows 7 Mouse Acceleration Fix
==========================================

http://donewmouseaccel.blogspot.com/2010/03/markc-windows-7-mouse-acceleration-fix.html

WHAT IS IT?

It is a registry file that removes Windows 7 mouse pointer acceleration.

It is like the CPL Mouse Fix and Cheese Mouse Fix, but gives exactly
1-to-1 mouse to pointer response for Windows 7.

Exactly 1-to-1 means no discarded or delayed mouse input while game playing.


HOW DO YOU USE IT?

- Find the display DPI that you currently use: Click Start, click
  Control Panel, select Appearance and Personalization, select Display.
  See if you have 100% or 125% or 150% selected.

- Open the ZIP file at the link above.

- Select the REG file that matches the DPI% you use and Double-click it.

- Answer Yes, OK to the prompts that appear.
  (See below for non-Administrator account use.)

- Reboot or Log off to apply the fix (you have to reboot or Log off).

- Enjoy exactly 1-to-1 mouse to pointer response!


WHY DO YOU NEED THE FIX?

If you don't know you need it, then you don't need it!

Some older games, such as Half-Life 1, Counter-Strike 1.x, Quake, Quake
2, Unreal and others, while they are active and running, call a Windows
function intending to disable variable mouse acceleration by forcing ALL
movement to be accelerated by the same amount (doubled).
On Windows 2000 and earlier, that removed all variable acceleration.
Pointing and aiming in those games was OK, because the mouse response
was then linear (all movement was accelerated by the same amount; it was
doubled). 

In XP, Vista and Windows 7, Microsoft changed how mouse pointer
acceleration worked.
Now when those games call the function (asking that all movement be
accelerated), Windows enables the mouse 'Enhance pointer precision'
feature, which adds mouse acceleration using a varying curve to control
the mouse response. (It enables it even if you have it turned off in the
Control Panel Mouse settings.) 

With 'Enhance pointer precision' enabled, slower mouse movements make
the pointer go extra slow and faster mouse movements make the pointer go
extra fast. It is not linear and not straightline.

This is annoying, because where you are aiming at depends on how far you
move your mouse, and also on how fast you moved the mouse to aim.


HOW DOES THE FIX WORK?

It redefines the curve used by the 'Enhance pointer precision'
feature to be a completely straight line. The slope of the line is tuned
so that every on-mouse-pad mouse movement is turned into exactly the
same amount of on-screen pointer movement.


HOW DO YOU KNOW THE FIX IS WORKING?

You can test if it is working by temporarily turning on the 'Enhance
pointer precision' feature and see how the mouse responds.
(NOTE: Only turn 'Enhance pointer precision' on for testing:
 it should normally be set OFF.)

If you have 'Enhance pointer precision' OFF, then the fix will not be
active (but it will be waiting to be activated when needed).
Just as some games turn it on when you don't want them to, we can turn
it on manually to test that the fix is working properly. 

- Go to Control Panel, and select Hardware and Sound, then click Mouse.
  Select 'Pointer options' and check-ON/enable the 'Enhance pointer
  precision' option.

- See how the mouse responds.

- If you want, you can run the MouseMovementRecorder.exe program that is
  included in the ZIP file to see that the mouse and pointer movements are
  1-to-1 and always the same.
  (The numbers in the MOUSE MOVEMENT column should be the same as the
   numbers in the POINTER MOVEMENT column. Any differences will appear in
   green or red.
   If you do sometimes see differences, also test with 'Enhance pointer 
   precision' OFF, in case the problem is with Windows or 
   MouseMovementRecorder.exe rather than a problem with the fix.) 

- Turn the 'Enhance pointer precision' option OFF when you have finished testing.


DOES MY GAME NEED A MOUSE FIX?

You can test your game to see if it turns 'Enhance pointer precision' ON,
and needs a mouse fix.

- Turn the 'Enhance pointer precision' option OFF,
- Run Mouse Movement Recorder (included in the ZIP file),
- Run your game and look at the 'EnPtPr' column footer at the bottom
  of the Mouse Movement Recorder window.
  If it is displayed with a red background then the game has turned
  acceleration ON and needs a mouse fix. 


IS THIS FIX DIFFERENT FROM THE CHEESE MOUSE FIX?

The 'Enhance pointer precision' option works slightly differently in
Windows 7 than it does in XP and Vista.

The Cheese Mouse Fix gives exactly 1-to-1 mouse response for Windows XP
and Windows Vista.

The MarkC Mouse Fix gives exactly 1-to-1 mouse response for Windows 7.

(Note: Both fixes need the Control Panel 'pointer speed' slider set to
the 6th, middle position to give exact 1-to-1.)


BUT I DON'T USE THE MIDDLE 6/11 POINTER SPEED SETTING?

If you want exact 1-to-1 in-game response when the pointer speed slider
is not in the 6/11 position, or you have a custom display DPI, see the
MarkC Mouse Fix Builder, which works for Windows 7, Vista and XP.
For those older games that turn acceleration on, it gives the same response
as position 6/11 does (1-to-1), without having to move the pointer speed
slider to 6/11.
http://donewmouseaccel.blogspot.com/2010/04/markc-mouse-acceleration-fix-builder.html


HOW DO YOU REMOVE IT?

- Open the ZIP file at the link above. 
- Select 'WindowsDefault.reg' and Double-click it. 
- Answer Yes, OK to the prompts that appear. 
- Reboot or Log off.


LOADING THE FIX WITH A NON-ADMINISTRATOR ACCOUNT

On Windows 7, when adding the mouse acceleration fix to the registry,
you may get this error message:

"Cannot import (filename).reg: Not all data was successfully written to the registry."

This error happens because part of the fix turns off acceleration for the
Welcome screen (the log on screen).
If you use the Welcome screen (or the Windows Log in dialog) and acceleration
is NOT turned off for the Welcome screen, then the MarkC fixes have a 1 pixel
/ 1 mouse count error when the mouse changes direction left/right or up/down.

You can remove this 1 mouse count error by any of these methods:

- Run Disable_WelcomeScreen+Login_Accel.CMD as Administrator
  (Right-click > Run as administrator).
- Add/Merge Disable_WelcomeScreen+Login_Accel.reg to the registry
  while logged in as an administrator.
- Run RegEdit.exe and edit 'HKEY_USERS\.DEFAULT\Control Panel\Mouse\MouseSpeed'
  to 0 (zero), while logged in as an administrator.
- Not moving or touching the mouse while using the Welcome screen
  (use arrow keys to select the user and Enter key to log in).
- Ignoring the 1 mouse count error! It's only a single count: You won't notice it.