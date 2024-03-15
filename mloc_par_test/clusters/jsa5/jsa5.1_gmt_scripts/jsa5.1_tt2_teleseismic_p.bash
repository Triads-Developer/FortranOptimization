#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=jsa5.1_tt2_teleseismic_p.ps
projection=-JX18/12
region=-R10/120/-10/10
gmt psbasemap $region $projection -Bxa10f5+l'Epicentral Distance (deg)' -Bya10f1g5+l'Travel Time Residual (s)' -BWeSn+t'Teleseismic P jsa5.1' -K > $psfile
gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile
     9.712    78.000
     8.537    79.000
     7.446    80.000
     6.441    81.000
     5.522    82.000
     4.687    83.000
     3.935    84.000
     3.272    85.000
     2.694    86.000
     2.194    87.000
     1.798    88.000
     1.498    89.000
     1.240    90.000
     1.013    91.000
     0.812    92.000
     0.630    93.000
     0.465    94.000
     0.320    95.000
     0.200    96.000
     0.107    97.000
     0.041    98.000
     0.006    99.000
END
gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile
     1.858    50.226     0.200
     1.627    50.507     0.200
     1.238    50.638     0.200
     2.243    50.996     0.200
     1.869    51.019     0.200
     1.371    51.192     0.200
     1.339    52.065     0.200
     0.529    53.283     0.200
     1.015    54.282     0.200
     1.198    55.430     0.200
     0.919    57.575     0.200
     0.983    57.737     0.200
     1.260    59.057     0.200
     0.214    59.021     0.200
     1.023    59.410     0.200
     0.694    61.403     0.200
     1.043    61.796     0.200
     0.244    62.019     0.200
    -1.186    62.906     0.200
     1.951    64.430     0.200
     0.643    64.630     0.200
    -0.593    65.993     0.200
    -0.684    67.260     0.200
    -0.472    68.769     0.200
    -0.189    69.013     0.200
    -0.324    70.709     0.200
    -1.159    72.089     0.200
    -0.619    72.166     0.200
    -0.779    72.226     0.200
    -0.155    73.894     0.200
    -0.273    73.897     0.200
     0.239    75.378     0.200
     1.459    78.281     0.200
    -0.211    78.620     0.200
    -2.139    81.418     0.200
     0.017    82.664     0.200
    -1.633    85.200     0.200
     1.342    50.469     0.200
     1.477    50.981     0.200
     0.939    51.186     0.200
     1.648    51.759     0.200
     1.248    52.028     0.200
     0.650    54.239     0.200
     1.203    55.391     0.200
     1.326    57.536     0.200
     1.011    57.694     0.200
     0.291    58.985     0.200
     1.128    59.369     0.200
    -0.773    61.817     0.200
    -0.078    63.134     0.200
     1.564    64.478     0.200
    -0.034    65.957     0.200
    -1.590    66.668     0.200
    -0.140    67.226     0.200
    -0.387    68.504     0.200
    -0.727    68.750     0.200
    -0.240    68.993     0.200
    -0.174    70.689     0.200
    -0.865    71.894     0.200
    -1.015    72.069     0.200
    -0.975    72.146     0.200
    -0.636    72.206     0.200
     0.827    75.681     0.200
   -12.807    78.244     0.200
   -16.480    78.583     0.200
     0.012    79.588     0.200
    -1.636    81.385     0.200
    -0.060    82.684     0.200
    -1.185    85.176     0.200
     1.456    51.180     0.200
     1.190    52.018     0.200
     1.127    55.384     0.200
     0.434    57.530     0.200
     1.057    57.697     0.200
     0.551    58.972     0.200
     1.123    59.366     0.200
     0.799    61.802     0.200
     1.566    64.443     0.200
    -0.744    65.443     0.200
     0.532    65.508     0.200
    -0.480    65.944     0.200
    -0.566    67.209     0.200
    -1.361    68.463     0.200
    -0.718    68.712     0.200
    -0.827    69.164     0.200
    -0.320    72.032     0.200
    -1.781    72.109     0.200
    -0.001    73.187     0.200
    -0.717    73.309     0.200
    -0.808    74.314     0.200
     1.500    75.645     0.200
     0.702    75.907     0.200
     1.141    78.302     0.200
    -0.330    78.641     0.200
    -1.342    78.825     0.200
     1.764    81.229     0.200
    -1.070    81.367     0.200
    -1.056    85.144     0.200
     2.556    51.188     0.200
     1.275    52.028     0.200
     1.426    55.392     0.200
     0.330    58.983     0.200
     0.938    59.372     0.200
    -0.130    61.815     0.200
     2.204    64.461     0.200
    -0.397    65.956     0.200
    -0.477    68.490     0.200
    -1.923    68.738     0.200
    -0.028    69.270     0.200
    -1.516    72.058     0.200
    -1.277    72.134     0.200
     0.289    73.216     0.200
    -0.817    73.336     0.200
    -0.752    74.331     0.200
     1.054    75.664     0.200
     1.070    75.923     0.200
    -1.990    81.382     0.200
     0.712    82.695     0.200
    -1.511    85.167     0.200
END
gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile
END
gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile
    66.029    53.283     0.200
    52.983    57.737     0.200
    53.057    57.697     0.200
END
gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,green+a0.+jBL -K -O << END >> $psfile
    -8.500    12.000 PcP in green
END
gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,red+a0.+jBL -O << END >> $psfile
    -9.500    12.000 Pdiff in red
END