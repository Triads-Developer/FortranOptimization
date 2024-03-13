#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset FORMAT_GEO_MAP D
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=wells6.1_base.ps
projection=-JM16.0c+
region=-R-115.0/-114.7/41.0/41.4
gmt psbasemap $region $projection -Bxa0.2f0.1 -Bya0.2f0.1 -BWeSn+t'Base Map wells6.1' -K > $psfile
palette=-Ctables/gmt/cpt/topo.cpt
gmt grdcut @earth_relief_01m -Gmloc.grd $region
gmt grdgradient mloc.grd -Gmloc_ilum.grd -A340 -Nt
gmt grdimage mloc.grd $palette $projection -Imloc_ilum.grd -O -K >> $psfile
rm mloc.grd mloc_ilum.grd
gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile
# Event numbers
gmt psxy -: -R $projection -Sl8p+t"1" -G0 -O -K << END >> $psfile
    41.143  -114.851
END
gmt psxy -: -R $projection -Sl8p+t"2" -G0 -O -K << END >> $psfile
    41.138  -114.854
END
gmt psxy -: -R $projection -Sl8p+t"3" -G0 -O -K << END >> $psfile
    41.141  -114.869
END
gmt psxy -: -R $projection -Sl8p+t"4" -G0 -O -K << END >> $psfile
    41.131  -114.921
END
gmt psxy -: -R $projection -Sl8p+t"5" -G0 -O -K << END >> $psfile
    41.136  -114.857
END
gmt psxy -: -R $projection -Sl8p+t"6" -G0 -O -K << END >> $psfile
    41.126  -114.916
END
gmt psxy -: -R $projection -Sl8p+t"7" -G0 -O -K << END >> $psfile
    41.164  -114.914
END
gmt psxy -: -R $projection -Sl8p+t"8" -G0 -O -K << END >> $psfile
    41.126  -114.895
END
gmt psxy -: -R $projection -Sl8p+t"9" -G0 -O -K << END >> $psfile
    41.108  -114.901
END
gmt psxy -: -R $projection -Sl8p+t"10" -G0 -O -K << END >> $psfile
    41.151  -114.933
END
gmt psxy -: -R $projection -Sl8p+t"11" -G0 -O -K << END >> $psfile
    41.146  -114.906
END
gmt psxy -: -R $projection -Sl8p+t"12" -G0 -O -K << END >> $psfile
    41.162  -114.940
END
gmt psxy -: -R $projection -Sl8p+t"13" -G0 -O -K << END >> $psfile
    41.154  -114.929
END
gmt psxy -: -R $projection -Sl8p+t"14" -G0 -O -K << END >> $psfile
    41.141  -114.920
END
gmt psxy -: -R $projection -Sl8p+t"15" -G0 -O -K << END >> $psfile
    41.176  -114.919
END
gmt psxy -: -R $projection -Sl8p+t"16" -G0 -O -K << END >> $psfile
    41.253  -114.801
END
gmt psxy -: -R $projection -Sl8p+t"17" -G0 -O -K << END >> $psfile
    41.134  -114.923
END
gmt psxy -: -R $projection -Sl8p+t"18" -G0 -O -K << END >> $psfile
    41.126  -114.911
END
gmt psxy -: -R $projection -Sl8p+t"19" -G0 -O -K << END >> $psfile
    41.160  -114.927
END
gmt psxy -: -R $projection -Sl8p+t"20" -G0 -O -K << END >> $psfile
    41.101  -114.899
END
gmt psxy -: -R $projection -Sl8p+t"21" -G0 -O -K << END >> $psfile
    41.139  -114.939
END
gmt psxy -: -R $projection -Sl8p+t"22" -G0 -O -K << END >> $psfile
    41.151  -114.932
END
gmt psxy -: -R $projection -Sl8p+t"23" -G0 -O -K << END >> $psfile
    41.128  -114.892
END
gmt psxy -: -R $projection -Sl8p+t"24" -G0 -O -K << END >> $psfile
    41.156  -114.912
END
gmt psxy -: -R $projection -Sl8p+t"25" -G0 -O -K << END >> $psfile
    41.120  -114.909
END
gmt psxy -: -R $projection -Sl8p+t"26" -G0 -O -K << END >> $psfile
    41.278  -114.865
END
gmt psxy -: -R $projection -Sl8p+t"27" -G0 -O -K << END >> $psfile
    41.176  -114.905
END
gmt psxy -: -R $projection -Sl8p+t"28" -G0 -O -K << END >> $psfile
    41.160  -114.845
END
gmt psxy -: -R $projection -Sl8p+t"29" -G0 -O -K << END >> $psfile
    41.139  -114.885
END
gmt psxy -: -R $projection -Sl8p+t"30" -G0 -O -K << END >> $psfile
    41.232  -114.848
END
gmt psxy -: -R $projection -Sl8p+t"31" -G0 -O -K << END >> $psfile
    41.277  -114.861
END
gmt psxy -: -R $projection -Sl8p+t"32" -G0 -O -K << END >> $psfile
    41.280  -114.864
END
gmt psxy -: -R $projection -Sl8p+t"33" -G0 -O -K << END >> $psfile
    41.275  -114.863
END
gmt psxy -: -R $projection -Sl8p+t"34" -G0 -O -K << END >> $psfile
    41.192  -114.841
END
gmt psxy -: -R $projection -Sl8p+t"35" -G0 -O -K << END >> $psfile
    41.162  -114.911
END
gmt psxy -: -R $projection -Sl8p+t"36" -G0 -O -K << END >> $psfile
    41.144  -114.925
END
gmt psxy -: -R $projection -Sl8p+t"37" -G0 -O -K << END >> $psfile
    41.203  -114.856
END
gmt psxy -: -R $projection -Sl8p+t"38" -G0 -O -K << END >> $psfile
    41.185  -114.875
END
gmt psxy -: -R $projection -Sl8p+t"39" -G0 -O -K << END >> $psfile
    41.193  -114.878
END
gmt psxy -: -R $projection -Sl8p+t"40" -G0 -O -K << END >> $psfile
    41.101  -114.898
END
gmt psxy -: -R $projection -Sl8p+t"41" -G0 -O -K << END >> $psfile
    41.129  -114.912
END
gmt psxy -: -R $projection -Sl8p+t"42" -G0 -O -K << END >> $psfile
    41.126  -114.910
END
gmt psxy -: -R $projection -Sl8p+t"43" -G0 -O -K << END >> $psfile
    41.125  -114.932
END
gmt psxy -: -R $projection -Sl8p+t"44" -G0 -O -K << END >> $psfile
    41.220  -114.833
END
gmt psxy -: -R $projection -Sl8p+t"45" -G0 -O -K << END >> $psfile
    41.213  -114.842
END
gmt psxy -: -R $projection -Sl8p+t"46" -G0 -O -K << END >> $psfile
    41.117  -114.919
END
gmt psxy -: -R $projection -Sl8p+t"47" -G0 -O -K << END >> $psfile
    41.196  -114.840
END
gmt psxy -: -R $projection -Sl8p+t"48" -G0 -O -K << END >> $psfile
    41.192  -114.838
END
gmt psxy -: -R $projection -Sl8p+t"49" -G0 -O -K << END >> $psfile
    41.206  -114.834
END
# Change in location, calibration shift if available
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.143  -114.850
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.124  -114.861
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.139  -114.854
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.147  -114.860
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.141  -114.869
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.100  -114.876
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.131  -114.922
    41.131  -114.921
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.112  -114.925
    41.131  -114.921
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.136  -114.857
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.104  -114.859
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.126  -114.916
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.100  -114.923
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.161  -114.914
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.114  -114.915
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.126  -114.895
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.112  -114.900
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.109  -114.901
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.102  -114.903
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.148  -114.932
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.122  -114.953
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.146  -114.907
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.120  -114.805
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.162  -114.940
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.167  -114.941
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.153  -114.929
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.142  -114.922
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.141  -114.920
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.103  -114.947
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.177  -114.920
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.155  -114.924
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.251  -114.803
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.202  -114.779
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.134  -114.924
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.107  -114.922
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.126  -114.912
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.106  -114.894
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.159  -114.927
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.082  -114.879
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.101  -114.899
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.106  -114.898
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.140  -114.939
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.120  -114.933
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.148  -114.932
    41.151  -114.932
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.123  -114.916
    41.151  -114.932
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.128  -114.892
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.134  -114.889
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.157  -114.913
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.138  -114.908
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.120  -114.910
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.090  -114.914
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.277  -114.865
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.290  -114.856
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.175  -114.906
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.168  -114.905
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.160  -114.845
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.163  -114.841
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.137  -114.884
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.140  -114.881
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.232  -114.848
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.242  -114.858
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.276  -114.861
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.277  -114.855
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.280  -114.863
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.292  -114.863
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.275  -114.863
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.272  -114.857
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.192  -114.841
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.151  -114.874
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.161  -114.911
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.177  -114.919
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.145  -114.922
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.115  -114.893
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.203  -114.856
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.245  -114.819
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.185  -114.875
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.215  -114.861
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.192  -114.878
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.169  -114.847
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.102  -114.898
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.108  -114.907
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.129  -114.912
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.134  -114.913
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.127  -114.912
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.129  -114.901
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.125  -114.933
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.132  -114.929
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.219  -114.832
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.186  -114.835
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.212  -114.842
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.177  -114.822
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.116  -114.919
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.009  -114.854
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.196  -114.839
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.205  -114.842
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.192  -114.837
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.201  -114.850
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile
    41.205  -114.835
    41.206  -114.834
END
gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile
    41.134  -114.767
    41.206  -114.834
END
# Confidence ellipses for relative location
gmt psxy -: -R $projection -SE -Wthick -O -K << END >> $psfile
    41.143  -114.851    -3.576     0.467     0.586
    41.138  -114.854   -15.599     0.479     0.595
    41.141  -114.869     3.009     0.399     0.516
    41.131  -114.921    50.295     2.637     4.340
    41.136  -114.857    36.217     0.744     0.974
    41.126  -114.916    14.328     0.553     0.618
    41.164  -114.914    34.877     0.761     0.836
    41.126  -114.895    72.061     1.068     1.118
    41.108  -114.901     2.490     0.885     0.944
    41.151  -114.933    32.353     0.845     1.020
    41.146  -114.906    14.631     0.916     1.003
    41.162  -114.940    18.489     0.624     0.719
    41.154  -114.929    33.509     0.590     0.719
    41.141  -114.920    19.181     0.513     0.639
    41.176  -114.919    17.739     0.784     0.850
    41.253  -114.801     5.875     0.849     0.938
    41.134  -114.923    49.382     0.898     0.996
    41.126  -114.911    40.252     0.451     0.509
    41.160  -114.927    18.351     0.701     0.828
    41.101  -114.899    15.025     0.723     0.963
    41.139  -114.939    21.741     0.617     0.683
    41.151  -114.932    54.167     2.302     2.883
    41.128  -114.892    24.471     0.528     0.619
    41.156  -114.912    82.575     0.564     0.632
    41.120  -114.909    31.471     0.498     0.593
    41.278  -114.865    27.531     0.628     0.650
    41.176  -114.905   -51.514     0.711     0.836
    41.160  -114.845   -45.712     0.810     0.828
    41.139  -114.885    57.345     0.703     0.729
    41.232  -114.848    27.228     0.593     0.669
    41.277  -114.861    45.923     0.684     0.715
    41.280  -114.864    33.549     0.589     0.669
    41.275  -114.863    24.241     0.937     1.180
    41.192  -114.841     3.314     0.372     0.448
    41.162  -114.911    47.507     0.559     0.613
    41.144  -114.925    25.707     0.591     0.712
    41.203  -114.856    24.616     0.865     1.170
    41.185  -114.875   -22.542     0.790     0.797
    41.193  -114.878    21.825     0.544     0.620
    41.101  -114.898   -21.267     0.552     0.599
    41.129  -114.912    18.948     0.487     0.542
    41.126  -114.910    14.470     0.590     0.723
    41.125  -114.932    -7.203     0.500     0.588
    41.220  -114.833   -12.632     0.379     0.435
    41.213  -114.842    -4.251     0.371     0.522
    41.117  -114.919     3.436     0.535     0.684
    41.196  -114.840    -6.816     0.621     0.765
    41.192  -114.838     9.567     0.558     0.815
    41.206  -114.834    29.560     2.310     3.139
END
# User-defined stars
gmt psxy -: -R $projection -Sa -Wthicker,red -Gred -O -K << END >> $psfile
    41.141  -114.869     0.200
END

# Hypocentroid confidence ellipse
gmt psxy -: -R $projection -SE -Wthick,blue -O -K << END >> $psfile
    41.055  -114.968    53.263     0.861     1.003
END
gmt pstext -: -R $projection -F+f6p,Helvetica,blue+a0.+jBL -O -K << END >> $psfile
    41.055  -114.946   Hypocentroid
END
# Circle of radius 5 km for reference
gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile
    41.055  -114.968     0.000    10.000    10.000
END
gmt psxy -: -R $projection -Sx -Wthinnest,blue -O -K << END >> $psfile
    41.055  -114.968     0.070
END
gmt pstext -: -R $projection -F+f6p,Helvetica-Bold,red+a0.+jBC -Gwhite -O << END >> $psfile
    41.010  -114.968   5 km
END
