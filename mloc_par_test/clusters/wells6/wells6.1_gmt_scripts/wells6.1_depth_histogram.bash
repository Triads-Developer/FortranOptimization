#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=wells6.1_depth_histogram.ps
projection=-JX12/10
region=-R0/17/0/19
gmt pshistogram $projection $region -W1 -F -Gcyan -L1p -Z0 -Bxa5f1+l'Depth (km)' -Bya10f1+lCounts -BWeSn+t'Focal Depths wells6.1' -K <<END>> $psfile
    12.251
    11.358
    11.445
    10.680
    12.437
    11.049
     9.437
    10.090
    11.132
     9.442
    10.349
     8.481
     8.517
     9.673
     9.190
    11.862
     9.988
     9.798
     8.742
    10.989
     8.920
     7.534
    11.390
     9.505
    11.658
    12.423
    11.275
    12.338
    11.241
    10.574
    11.412
    11.768
    11.546
    11.202
     9.147
     8.892
     9.612
     8.348
     8.407
    11.643
     9.366
    10.977
     8.586
    11.774
    11.599
     9.816
    11.419
    11.506
     8.027
END
gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jBL -O << END >> $psfile
    17.860     1.000 Median of constrained depths = 10.7
END
