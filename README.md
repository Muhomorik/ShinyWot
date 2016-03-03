ShinyWot
========

Course Project: Shiny Application and Reproducible Pitch

[ShinyApp (when running)](https://muhomorik.shinyapps.io/ShinyWot/)
[RPubs presentation](http://rpubs.com/Muhomorik/ShinyWot)

<span style="color:red">**Note:** </span>This document is auto-generated
by knitr from [Readme.Rmd](Readme.Rmd).

Abstract
========

This is my "pet toy" project. Once upon a time I use to play MMORPG
World of Tanks.

The good thind is thet
[Wargaming](https://eu.wargaming.net/developers/documentation/guide/getting-started/)
provide an API (json).

So I decided to take a look and make a simple app to perform requests
and plot response. The idea was to check how warious types of vehicles
perform for the articular player.

I am not very happy with the current results and the signle player data
is not enough. So I will keep digging after this course.

Input
=====

Only "random" battles are taken.

Choose against some pre-defined players. I've included some:

-   Na\`Vi (e-sports chamions) players.
-   Good SPG players to see different king of stats.
-   Russian popular streamers (youtube.com)

Tier

-   Most pupular tiers are 7-8 and 10.

In garage

-   Take only owned vehicles.

TODO:
=====

-   [ ] Reorder functions for better re-use in Rmd (here).

Results
=======

The result is some charts like

WinRate histogram
-----------------

![](Readme_files/figure-markdown_strict/winrateHist-1.png)

WinRate density and density by tier
-----------------------------------

![](Readme_files/figure-markdown_strict/density-1.png)

Average Dmg vs Win ratio
------------------------

![](Readme_files/figure-markdown_strict/avgDmg_vs_WinRate-1.png)

Spotted vs Win ratio
--------------------

[Spotting](http://wiki.wargaming.net/en/Battle_Mechanics#Spotting_Mechanics)
vs Win Ratio

![](Readme_files/figure-markdown_strict/spotted_vs_WinRate-1.png)
