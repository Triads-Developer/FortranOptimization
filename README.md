# FortranOptimization
Optimization of code which performs multiple event relocation on a cluster of earthquakes, using the Hypocentroidal Decomposition (HD) algorithm


# How to run

Connect to the VPN and SSH into the server:


    ssh triads@mantle.wustl.edu

CD into the current working directory


    cd /RAID/users/triads/mloc_working/test1

Run the program providing a *.in file as input

    /RAID/users/triads/mloc_working/mloc_f < run01.in


note, the code will produce a bunch of files prepended with run01. If you want to run it again with that same .in file, you'll have to move the run01* files into another folder.
