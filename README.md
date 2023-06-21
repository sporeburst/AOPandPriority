AOP and Priority Script

This script combines many critical tools used in popular DOJRP servers into one script with script optimizations as priority.
I would like to thank coDex for contributions of Server Replicated CONVAR integration.
The script utilizes between 0.00 and 0.01ms of CPU Time.
NUI font will automatically size itself based on screen resolution.  Text will no longer appear Tiny in 4k resolutions.


Features:
    NUI was created to display all of the information so screen rendering every frame is not needed.
    County/City split priority system, or a simple 'State' priority.
    AOP display
    PeaceTime integration
    Cardinal Direction and Street names.
    nearest-postal script integration supported
    Fully configurable config file for font colors based on conditions.
    NUI will flash a particular event being changed (ie:  AOP change, Priority change).  This is also configurable to disable the flash.

Priority System:

You can opt to use the Priority system, or disable it.
You may split County/City Priority systems if your server is large enough for both City and State patrols.
You may combine City/County priority systems into just one priority system based on the AOP for smaller servers.
Edit the Config.lua file for colors for each priority state, and how many minutes you want the cooldown to count.

AOP System:

Simplified AOP system where the AOP is changed via Server Replicated CONVAR.
You may change the color or disable AOP in the config.lua file.

PeaceTime system:

Option to enable/disable PeaceTime ability.
While in PeaceTime, you can enable, or disable certain damage incurred during PeaceTime:
    All Damage received
    Vehicle Damage received
    Damage done by players while not in a vehicle

Postal system:

You may integrate the nearest-postal script into AOPandPriority.  A few things must be done first:
    the postal script should be 'nearest-postal'
    nearest-postal should be the latest version(must have the getPostal export)
    comment lines:  66-84 in cl_render.lua in the nearest-postal script
    in config.lua of AOPandPriority, enable UsePostal by setting it to true

Direction System:

You may enable/disable the direction system if you want to utilize the vMenu direction system.  Be warned that the vMenu version uses up to 0.20-0.30ms of CPU cycles.
You can enable/disable the Cardinal Direction detection

NUI Modifications:

You can change the colors of Priority, AOP, etc from the default color of RED to any color you wish in the html/css/stylesheed.css file on line 11.
To move the entire NUI box to another location on your screen, edit line 5 to position it using the percentage of total screen.

Logging:

Simplified Logging system.  You can utilize AOP/Priority changes to be logged to Discord(requires knowledge of LUA).

Permission Based:

AOPandPriority requires permissions to be passed to the script to be used and is configurable in the config.lua.  Simply pass a server sided "TriggerEvent" to the script along with the source for them to receive the proper commands.  This command can only be triggered via a server sided script and not Client-->Server to prevent modders from gaining access to these commands.  Additionally, the commands passed to the server for a change are in a table file to prevent modders from bypassing commands.  I'm sure eventually(or quickly) one would be able to change it so prepare with your developer accordingly to prevent such access via IsAceAllowed commands to validate such permission.

For Example, you may tie this into your discordAuth SERVER SIDED script by:  TriggerEvent('AOPandPriority:Server:CheckAuth', source, 'job') where 'job' is the ACE permission being passed.  You will want to pass the highest permission to the script such as a server owner, admin, moderator, etc.  This event must be triggered after the client is fully loaded into the game.  A LUA Developer may also modify this to check Ace Permissions and apply them accordingly if they know how to do this.

Other:

You may modify this script however you wish.  This is a free project and I wish for all DOJRP servers to prosper with good script optimizations.
Take care everyone!