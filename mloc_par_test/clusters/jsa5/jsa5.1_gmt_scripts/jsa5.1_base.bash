#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset FORMAT_GEO_MAP D
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=jsa5.1_base.ps
projection=-JM16.0c+
region=-R-148.4/-147.9/-7.9/-7.2
gmt psbasemap $region $projection -Bxa0.2f0.1 -Bya0.2f0.1 -BWeSn+t'Base Map jsa5.1' -K > $psfile
gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile
# Event numbers
gmt psxy -: -R $projection -Sl8p+t"1" -G0 -O -K << END >> $psfile
    -7.386  -148.342
END
gmt psxy -: -R $projection -Sl8p+t"2" -G0 -O -K << END >> $psfile
    -7.366  -148.298
END
gmt psxy -: -R $projection -Sl8p+t"3" -G0 -O -K << END >> $psfile
    -7.328  -148.349
END
gmt psxy -: -R $projection -Sl8p+t"4" -G0 -O -K << END >> $psfile
    -7.354  -148.321
END
# Change in location, calibration shift if available
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    -7.500  -148.262
    -7.386  -148.342
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    -7.500  -148.262
    -7.386  -148.342
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    -7.511  -148.225
    -7.366  -148.298
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    -7.511  -148.225
    -7.366  -148.298
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    -7.625  -148.060
    -7.328  -148.349
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    -7.625  -148.060
    -7.328  -148.349
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    -7.750  -148.040
    -7.354  -148.321
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    -7.750  -148.040
    -7.354  -148.321
END
# Confidence ellipses for relative location
gmt psxy -: -R $projection -SE -Wthick -O -K << END >> $psfile
    -7.386  -148.342    12.682     4.684    10.289
    -7.366  -148.298    20.035     5.487    12.662
    -7.328  -148.349    12.773     4.754    10.543
    -7.354  -148.321    12.624     4.757    12.596
END
# Circle of radius 5 km for reference
gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile
    -7.796  -148.395     0.000    10.000    10.000
END
gmt psxy -: -R $projection -Sx -Wthinnest,blue -O -K << END >> $psfile
    -7.796  -148.395     0.070
END
gmt pstext -: -R $projection -F+f6p,Helvetica-Bold,red+a0.+jBC -Gwhite -O << END >> $psfile
    -7.841  -148.395   5 km
END
