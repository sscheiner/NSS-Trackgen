# NSS-Trackgen

NSS Trackgen Tool, 9:36 AM 7/15/2015


This tool takes two given intial coordinates, and generates a NSS track between those two points which deviates randomly from a direct course. It works by dividing the track into equally spaced intervals (the amount of which are determined by the user) then generating points that are a random distance from those intervals. The randomness is modified by a coefficient that is in units of degrees latitude/longitude.

The program additionally has the option to visualize the track generated for debugging and pre-simulation checks before run an NSS scenario. This can be enabled by uncommenting code blocks labeled "draw". 
