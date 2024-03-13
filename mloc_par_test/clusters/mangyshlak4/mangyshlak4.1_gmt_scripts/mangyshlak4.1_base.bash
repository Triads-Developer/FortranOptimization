#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset FORMAT_GEO_MAP D
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=mangyshlak4.1_base.ps
projection=-JM16.0c+
region=-R54.6/55.0/43.7/44.1
gmt psbasemap $region $projection -Bxa0.2f0.1 -Bya0.2f0.1 -BWeSn+t'Base Map mangyshlak4.1' -K > $psfile
gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile
# Event numbers
gmt psxy -: -R $projection -Sl8p+t"1" -G0 -O -K << END >> $psfile
    43.864    54.780
END
gmt psxy -: -R $projection -Sl8p+t"2" -G0 -O -K << END >> $psfile
    43.908    54.792
END
gmt psxy -: -R $projection -Sl8p+t"3" -G0 -O -K << END >> $psfile
    43.887    54.892
END
# Change in location, calibration shift if available
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    43.867    54.800
    43.837    54.702
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    43.867    54.800
    43.864    54.780
END
gmt psxy -: -R $projection -Wthin,red -O -K << END >> $psfile
    43.837    54.702
    43.864    54.780
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    43.850    54.800
    43.881    54.714
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    43.850    54.800
    43.908    54.792
END
gmt psxy -: -R $projection -Wthin,red -O -K << END >> $psfile
    43.881    54.714
    43.908    54.792
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    44.025    54.933
    43.860    54.814
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    44.025    54.933
    43.887    54.892
END
gmt psxy -: -R $projection -Wthin,red -O -K << END >> $psfile
    43.860    54.814
    43.887    54.892
END
# Calibration locations marked by a red cross
gmt psxy -: -R $projection -Sx -Wthick,red -O -K << END >> $psfile
    43.862    54.773     0.200
    43.910    54.794     0.200
    43.886    54.897     0.200
END
# Calibration location confidence ellipses
gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile
    43.862    54.773    -0.000     0.020     0.020
    43.910    54.794    -0.000     0.020     0.020
    43.886    54.897    -0.000     0.020     0.020
END
# Residual calibration shift vectors
gmt psxy -: -R $projection -Wthick,blue -O -K << END >> $psfile
    43.862    54.773
    43.864    54.780
END
gmt psxy -: -R $projection -Wthick,blue -O -K << END >> $psfile
    43.910    54.794
    43.908    54.792
END
gmt psxy -: -R $projection -Wthick,blue -O -K << END >> $psfile
    43.886    54.897
    43.887    54.892
END
# Confidence ellipses for relative location
gmt psxy -: -R $projection -SE -Wthick -O -K << END >> $psfile
    43.864    54.780    86.932     0.581     0.742
    43.908    54.792   -75.142     0.505     0.700
    43.887    54.892    77.975     0.548     0.879
END
# Hypocentroid confidence ellipse
gmt psxy -: -R $projection -SE -Wthick,blue -O -K << END >> $psfile
    43.791    54.677    88.221     0.554     0.761
END
gmt pstext -: -R $projection -F+f6p,Helvetica,blue+a0.+jBL -O -K << END >> $psfile
    43.791    54.699   Hypocentroid
END
# Circle of radius 5 km for reference
gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile
    43.791    54.677     0.000    10.000    10.000
END
gmt psxy -: -R $projection -Sx -Wthinnest,blue -O -K << END >> $psfile
    43.791    54.677     0.070
END
gmt pstext -: -R $projection -F+f6p,Helvetica-Bold,red+a0.+jBC -Gwhite -O << END >> $psfile
    43.746    54.677   5 km
END
