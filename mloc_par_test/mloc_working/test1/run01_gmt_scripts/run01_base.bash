#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset FORMAT_GEO_MAP D
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=run01_base.ps
projection=-JM16.0c+
region=-R-150.3/-148.3/55.3/56.7
gmt psbasemap $region $projection -Bxa0.5f0.1 -Bya0.5f0.1 -BWeSn+t'Base Map run01' -K > $psfile
gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile
# Event numbers
gmt psxy -: -R $projection -Sl8p+t"1" -G0 -O -K << END >> $psfile
    56.243  -149.374
END
gmt psxy -: -R $projection -Sl8p+t"2" -G0 -O -K << END >> $psfile
    56.327  -148.359
END
gmt psxy -: -R $projection -Sl8p+t"3" -G0 -O -K << END >> $psfile
    56.328  -149.449
END
gmt psxy -: -R $projection -Sl8p+t"4" -G0 -O -K << END >> $psfile
    56.114  -149.577
END
gmt psxy -: -R $projection -Sl8p+t"5" -G0 -O -K << END >> $psfile
    56.092  -149.191
END
gmt psxy -: -R $projection -Sl8p+t"6" -G0 -O -K << END >> $psfile
    56.233  -149.457
END
gmt psxy -: -R $projection -Sl8p+t"7" -G0 -O -K << END >> $psfile
    56.292  -148.704
END
gmt psxy -: -R $projection -Sl8p+t"8" -G0 -O -K << END >> $psfile
    56.058  -149.545
END
gmt psxy -: -R $projection -Sl8p+t"9" -G0 -O -K << END >> $psfile
    56.514  -148.850
END
gmt psxy -: -R $projection -Sl8p+t"10" -G0 -O -K << END >> $psfile
    56.019  -149.207
END
gmt psxy -: -R $projection -Sl8p+t"11" -G0 -O -K << END >> $psfile
    56.263  -149.440
END
gmt psxy -: -R $projection -Sl8p+t"12" -G0 -O -K << END >> $psfile
    55.909  -150.083
END
gmt psxy -: -R $projection -Sl8p+t"13" -G0 -O -K << END >> $psfile
    56.162  -149.501
END
gmt psxy -: -R $projection -Sl8p+t"14" -G0 -O -K << END >> $psfile
    56.058  -149.656
END
gmt psxy -: -R $projection -Sl8p+t"15" -G0 -O -K << END >> $psfile
    56.090  -149.180
END
gmt psxy -: -R $projection -Sl8p+t"16" -G0 -O -K << END >> $psfile
    56.254  -149.281
END
gmt psxy -: -R $projection -Sl8p+t"17" -G0 -O -K << END >> $psfile
    56.230  -149.261
END
gmt psxy -: -R $projection -Sl8p+t"18" -G0 -O -K << END >> $psfile
    56.503  -148.961
END
gmt psxy -: -R $projection -Sl8p+t"19" -G0 -O -K << END >> $psfile
    56.085  -149.775
END
gmt psxy -: -R $projection -Sl8p+t"20" -G0 -O -K << END >> $psfile
    56.378  -148.401
END
gmt psxy -: -R $projection -Sl8p+t"21" -G0 -O -K << END >> $psfile
    56.055  -149.572
END
gmt psxy -: -R $projection -Sl8p+t"22" -G0 -O -K << END >> $psfile
    56.116  -149.257
END
gmt psxy -: -R $projection -Sl8p+t"23" -G0 -O -K << END >> $psfile
    56.363  -148.700
END
gmt psxy -: -R $projection -Sl8p+t"24" -G0 -O -K << END >> $psfile
    55.859  -149.909
END
gmt psxy -: -R $projection -Sl8p+t"25" -G0 -O -K << END >> $psfile
    56.092  -149.291
END
gmt psxy -: -R $projection -Sl8p+t"26" -G0 -O -K << END >> $psfile
    55.413  -148.994
END
gmt psxy -: -R $projection -Sl8p+t"27" -G0 -O -K << END >> $psfile
    56.458  -148.559
END
gmt psxy -: -R $projection -Sl8p+t"28" -G0 -O -K << END >> $psfile
    56.443  -149.197
END
gmt psxy -: -R $projection -Sl8p+t"29" -G0 -O -K << END >> $psfile
    55.925  -149.589
END
gmt psxy -: -R $projection -Sl8p+t"30" -G0 -O -K << END >> $psfile
    56.037  -149.243
END
gmt psxy -: -R $projection -Sl8p+t"31" -G0 -O -K << END >> $psfile
    56.436  -149.144
END
gmt psxy -: -R $projection -Sl8p+t"32" -G0 -O -K << END >> $psfile
    55.946  -149.872
END
gmt psxy -: -R $projection -Sl8p+t"33" -G0 -O -K << END >> $psfile
    55.709  -149.166
END
gmt psxy -: -R $projection -Sl8p+t"34" -G0 -O -K << END >> $psfile
    55.919  -149.895
END
gmt psxy -: -R $projection -Sl8p+t"35" -G0 -O -K << END >> $psfile
    56.265  -149.182
END
gmt psxy -: -R $projection -Sl8p+t"36" -G0 -O -K << END >> $psfile
    56.030  -149.903
END
gmt psxy -: -R $projection -Sl8p+t"37" -G0 -O -K << END >> $psfile
    56.512  -148.732
END
gmt psxy -: -R $projection -Sl8p+t"38" -G0 -O -K << END >> $psfile
    56.392  -149.433
END
gmt psxy -: -R $projection -Sl8p+t"39" -G0 -O -K << END >> $psfile
    56.222  -148.548
END
gmt psxy -: -R $projection -Sl8p+t"40" -G0 -O -K << END >> $psfile
    56.117  -149.161
END
gmt psxy -: -R $projection -Sl8p+t"41" -G0 -O -K << END >> $psfile
    56.379  -148.969
END
gmt psxy -: -R $projection -Sl8p+t"42" -G0 -O -K << END >> $psfile
    56.047  -149.192
END
gmt psxy -: -R $projection -Sl8p+t"43" -G0 -O -K << END >> $psfile
    56.308  -148.540
END
gmt psxy -: -R $projection -Sl8p+t"44" -G0 -O -K << END >> $psfile
    56.265  -149.208
END
gmt psxy -: -R $projection -Sl8p+t"45" -G0 -O -K << END >> $psfile
    55.688  -149.224
END
gmt psxy -: -R $projection -Sl8p+t"46" -G0 -O -K << END >> $psfile
    56.008  -149.642
END
gmt psxy -: -R $projection -Sl8p+t"47" -G0 -O -K << END >> $psfile
    56.138  -149.226
END
gmt psxy -: -R $projection -Sl8p+t"48" -G0 -O -K << END >> $psfile
    56.371  -149.182
END
gmt psxy -: -R $projection -Sl8p+t"49" -G0 -O -K << END >> $psfile
    56.377  -148.769
END
gmt psxy -: -R $projection -Sl8p+t"50" -G0 -O -K << END >> $psfile
    56.548  -148.572
END
gmt psxy -: -R $projection -Sl8p+t"51" -G0 -O -K << END >> $psfile
    56.131  -149.756
END
gmt psxy -: -R $projection -Sl8p+t"52" -G0 -O -K << END >> $psfile
    56.226  -149.379
END
gmt psxy -: -R $projection -Sl8p+t"53" -G0 -O -K << END >> $psfile
    56.178  -148.540
END
# Change in location, calibration shift if available
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.207  -149.422
    56.243  -149.374
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.207  -149.422
    56.243  -149.374
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.363  -148.428
    56.327  -148.359
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.363  -148.428
    56.327  -148.359
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.364  -149.545
    56.328  -149.449
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.364  -149.545
    56.328  -149.449
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.200  -149.599
    56.114  -149.577
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.200  -149.599
    56.114  -149.577
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.076  -149.270
    56.092  -149.191
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.076  -149.270
    56.092  -149.191
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.271  -149.472
    56.233  -149.457
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.271  -149.472
    56.233  -149.457
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.368  -148.742
    56.292  -148.704
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.368  -148.742
    56.292  -148.704
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.071  -149.700
    56.058  -149.545
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.071  -149.700
    56.058  -149.545
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.527  -148.957
    56.514  -148.850
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.527  -148.957
    56.514  -148.850
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.078  -149.275
    56.019  -149.207
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.078  -149.275
    56.019  -149.207
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.257  -149.533
    56.263  -149.440
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.257  -149.533
    56.263  -149.440
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.952  -150.156
    55.909  -150.083
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.952  -150.156
    55.909  -150.083
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.158  -149.559
    56.162  -149.501
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.158  -149.559
    56.162  -149.501
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.067  -149.781
    56.058  -149.656
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.067  -149.781
    56.058  -149.656
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.159  -149.243
    56.090  -149.180
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.159  -149.243
    56.090  -149.180
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.352  -149.383
    56.254  -149.281
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.352  -149.383
    56.254  -149.281
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.184  -149.422
    56.230  -149.261
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.184  -149.422
    56.230  -149.261
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.509  -148.979
    56.503  -148.961
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.509  -148.979
    56.503  -148.961
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.124  -149.875
    56.085  -149.775
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.124  -149.875
    56.085  -149.775
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.445  -148.434
    56.378  -148.401
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.445  -148.434
    56.378  -148.401
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.070  -149.642
    56.055  -149.572
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.070  -149.642
    56.055  -149.572
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.078  -149.348
    56.116  -149.257
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.078  -149.348
    56.116  -149.257
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.427  -148.780
    56.363  -148.700
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.427  -148.780
    56.363  -148.700
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.913  -150.066
    55.859  -149.909
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.913  -150.066
    55.859  -149.909
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.089  -149.283
    56.092  -149.291
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.089  -149.283
    56.092  -149.291
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.493  -149.115
    55.413  -148.994
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.493  -149.115
    55.413  -148.994
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.517  -148.631
    56.458  -148.559
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.517  -148.631
    56.458  -148.559
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.462  -149.281
    56.443  -149.197
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.462  -149.281
    56.443  -149.197
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.930  -149.748
    55.925  -149.589
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.930  -149.748
    55.925  -149.589
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.048  -149.373
    56.037  -149.243
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.048  -149.373
    56.037  -149.243
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.471  -149.169
    56.436  -149.144
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.471  -149.169
    56.436  -149.144
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.991  -149.997
    55.946  -149.872
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.991  -149.997
    55.946  -149.872
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.774  -149.114
    55.709  -149.166
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.774  -149.114
    55.709  -149.166
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.949  -150.029
    55.919  -149.895
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.949  -150.029
    55.919  -149.895
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.293  -149.257
    56.265  -149.182
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.293  -149.257
    56.265  -149.182
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.074  -149.996
    56.030  -149.903
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.074  -149.996
    56.030  -149.903
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.563  -148.792
    56.512  -148.732
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.563  -148.792
    56.512  -148.732
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.394  -149.399
    56.392  -149.433
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.394  -149.399
    56.392  -149.433
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.315  -148.509
    56.222  -148.548
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.315  -148.509
    56.222  -148.548
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.199  -149.185
    56.117  -149.161
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.199  -149.185
    56.117  -149.161
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.487  -148.970
    56.379  -148.969
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.487  -148.970
    56.379  -148.969
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.093  -149.223
    56.047  -149.192
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.093  -149.223
    56.047  -149.192
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.410  -148.390
    56.308  -148.540
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.410  -148.390
    56.308  -148.540
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.320  -149.199
    56.265  -149.208
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.320  -149.199
    56.265  -149.208
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    55.747  -149.266
    55.688  -149.224
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    55.747  -149.266
    55.688  -149.224
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.103  -149.631
    56.008  -149.642
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.103  -149.631
    56.008  -149.642
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.151  -149.337
    56.138  -149.226
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.151  -149.337
    56.138  -149.226
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.379  -149.203
    56.371  -149.182
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.379  -149.203
    56.371  -149.182
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.339  -148.847
    56.377  -148.769
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.339  -148.847
    56.377  -148.769
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.641  -148.571
    56.548  -148.572
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.641  -148.571
    56.548  -148.572
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.154  -149.816
    56.131  -149.756
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.154  -149.816
    56.131  -149.756
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.272  -149.435
    56.226  -149.379
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.272  -149.435
    56.226  -149.379
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    56.203  -148.594
    56.178  -148.540
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    56.203  -148.594
    56.178  -148.540
END
# Confidence ellipses for relative location
gmt psxy -: -R $projection -SE -Wthick -O -K << END >> $psfile
    56.243  -149.374    66.988     2.339     4.770
    56.327  -148.359    73.875     1.211     2.472
    56.328  -149.449    71.075     1.947     3.347
    56.114  -149.577    66.513     1.997     4.027
    56.092  -149.191    75.231     1.434     2.365
    56.233  -149.457    87.512     1.692     2.287
    56.292  -148.704    76.051     2.111     3.711
    56.058  -149.545    65.568     1.899     3.583
    56.514  -148.850   -89.618     2.347     5.399
    56.019  -149.207    68.023     2.135     3.830
    56.263  -149.440    68.175     1.883     3.282
    55.909  -150.083    78.492     2.490     3.709
    56.162  -149.501    84.774     1.695     3.300
    56.058  -149.656    69.150     1.297     2.118
    56.090  -149.180    70.943     2.213     4.325
    56.254  -149.281    67.569     1.793     3.634
    56.230  -149.261    70.831     2.604     4.758
    56.503  -148.961    72.925     1.226     2.223
    56.085  -149.775   -85.717     3.076     5.388
    56.378  -148.401    82.720     1.440     2.478
    56.055  -149.572    67.717     1.897     3.521
    56.116  -149.257    77.257     1.350     2.561
    56.363  -148.700    66.766     1.892     5.073
    55.859  -149.909    69.212     2.677     4.495
    56.092  -149.291   -79.244     1.435     2.169
    55.413  -148.994    70.301     2.247     4.604
    56.458  -148.559    70.151     1.762     2.889
    56.443  -149.197    79.277     1.584     2.223
    55.925  -149.589    75.558     1.366     2.102
    56.037  -149.243    67.317     1.297     2.128
    56.436  -149.144    69.829     1.390     2.285
    55.946  -149.872    67.174     1.662     2.291
    55.709  -149.166    77.850     1.552     2.191
    55.919  -149.895    64.450     1.823     2.610
    56.265  -149.182    64.593     0.887     1.426
    56.030  -149.903    84.726     1.388     2.199
    56.512  -148.732    66.602     1.802     3.373
    56.392  -149.433    89.077     1.601     2.325
    56.222  -148.548    77.866     1.289     2.286
    56.117  -149.161    67.591     1.502     2.896
    56.379  -148.969    69.247     1.338     2.865
    56.047  -149.192    82.500     1.465     2.063
    56.308  -148.540   -87.391     1.513     2.290
    56.265  -149.208    73.184     1.489     2.368
    55.688  -149.224    68.422     1.395     2.236
    56.008  -149.642    66.442     2.015     3.555
    56.138  -149.226    66.992     2.020     3.436
    56.371  -149.182    73.618     1.664     2.271
    56.377  -148.769    66.284     1.653     2.767
    56.548  -148.572    73.722     1.380     2.525
    56.131  -149.756    72.557     1.847     3.054
    56.226  -149.379    70.506     1.480     2.254
    56.178  -148.540    71.709     1.625     2.701
END
gmt pstext -: -R $projection -F+f6p,Helvetica,blue+a0.+jBL -O -K << END >> $psfile
    55.367  -150.139   Uncalibrated
END
# Circle of radius 5 km for reference
gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile
    55.367  -150.161     0.000    10.000    10.000
END
gmt psxy -: -R $projection -Sx -Wthinnest,blue -O -K << END >> $psfile
    55.367  -150.161     0.070
END
gmt pstext -: -R $projection -F+f6p,Helvetica-Bold,red+a0.+jBC -Gwhite -O << END >> $psfile
    55.322  -150.161   5 km
END
