#!/bin/bash
gmt gmtset PS_MEDIA letter
gmt gmtset PROJ_LENGTH_UNIT cm
gmt gmtset FORMAT_GEO_MAP D
gmt gmtset PS_PAGE_ORIENTATION portrait
psfile=wells6.1_dcal.ps
projection=-JM16.0c+
region=-R-117.4/-112.3/39.2/43.2
gmt psbasemap $region $projection -Bxa1.0f0.5 -Bya1.0f0.5 -BWeSn+t'Direct Calibration wells6.1' -K > $psfile
palette=-Ctables/gmt/cpt/topo.cpt
gmt grdcut @earth_relief_01m -Gmloc.grd $region
gmt grdgradient mloc.grd -Gmloc_ilum.grd -A340 -Nt
gmt grdimage mloc.grd $palette $projection -Imloc_ilum.grd -O -K >> $psfile
rm mloc.grd mloc_ilum.grd
gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile
# Raypaths used in direct calibration
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.143  -114.851
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.138  -114.854
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.141  -114.869
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.131  -114.921
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.131  -114.921
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.131  -114.921
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.136  -114.857
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.916
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.164  -114.914
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.895
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.108  -114.901
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.151  -114.933
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.146  -114.906
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.162  -114.940
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.154  -114.929
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.141  -114.920
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.176  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.253  -114.801
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.134  -114.923
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.160  -114.927
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.101  -114.899
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.139  -114.939
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.151  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.151  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.128  -114.892
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.156  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.120  -114.909
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.278  -114.865
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.176  -114.905
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.160  -114.845
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.139  -114.885
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.232  -114.848
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.277  -114.861
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.280  -114.864
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.275  -114.863
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.192  -114.841
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.162  -114.911
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.144  -114.925
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.203  -114.856
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.185  -114.875
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.162  -114.967
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.184  -114.841
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.038  -114.949
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.193  -114.878
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.162  -114.967
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.184  -114.841
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.038  -114.949
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.101  -114.898
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.162  -114.967
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.184  -114.841
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.038  -114.949
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.129  -114.912
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.162  -114.967
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.184  -114.841
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.038  -114.949
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.126  -114.910
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.153  -114.946
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.153  -114.946
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.138  -114.900
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.138  -114.900
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.167  -114.975
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.167  -114.975
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.158  -114.888
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.158  -114.888
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.162  -114.967
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.126  -114.859
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.096  -114.835
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.096  -114.835
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.038  -114.949
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.125  -114.932
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.220  -114.833
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.126  -114.859
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.126  -114.859
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.158  -114.888
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.158  -114.888
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.138  -114.900
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.138  -114.900
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.096  -114.835
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.096  -114.835
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.153  -114.946
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.153  -114.946
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.161  -114.840
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.213  -114.842
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.117  -114.919
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.416  -114.915
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.852  -115.039
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.431  -115.791
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    42.146  -115.016
    41.196  -114.840
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    41.360  -114.165
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.856  -114.204
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.817  -115.736
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.268  -114.745
    41.192  -114.838
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.206  -114.834
END
gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile
    40.745  -115.239
    41.206  -114.834
END
# Seismic stations used for direct calibration, marked by a triangle
gmt psxy -: -R $projection -St -Wthick,black -Gblack -O -K << END >> $psfile
    41.416  -114.915     0.300
    40.852  -115.039     0.300
    40.745  -115.239     0.300
    40.856  -114.204     0.300
    41.360  -114.165     0.300
    40.817  -115.736     0.300
    41.431  -115.791     0.300
    40.268  -114.745     0.300
    42.146  -115.016     0.300
    41.162  -114.967     0.300
    41.184  -114.841     0.300
    41.038  -114.949     0.300
    41.153  -114.946     0.300
    41.138  -114.900     0.300
    41.167  -114.975     0.300
    41.158  -114.888     0.300
    41.126  -114.859     0.300
    41.096  -114.835     0.300
    41.161  -114.840     0.300
END
# S-P stations used for direct calibration, marked by an open diamond
gmt psxy -: -R $projection -Sd -Wthick -O -K << END >> $psfile
END
# Cluster events, marked by open black circles
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.143  -114.851     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.138  -114.854     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.141  -114.869     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.131  -114.921     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.136  -114.857     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.126  -114.916     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.164  -114.914     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.126  -114.895     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.108  -114.901     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.151  -114.933     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.146  -114.906     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.162  -114.940     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.154  -114.929     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.141  -114.920     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.176  -114.919     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.253  -114.801     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.134  -114.923     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.126  -114.911     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.160  -114.927     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.101  -114.899     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.139  -114.939     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.151  -114.932     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.128  -114.892     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.156  -114.912     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.120  -114.909     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.278  -114.865     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.176  -114.905     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.160  -114.845     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.139  -114.885     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.232  -114.848     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.277  -114.861     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.280  -114.864     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.275  -114.863     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.192  -114.841     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.162  -114.911     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.144  -114.925     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.203  -114.856     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.185  -114.875     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.193  -114.878     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.101  -114.898     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.129  -114.912     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.126  -114.910     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.125  -114.932     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.220  -114.833     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.213  -114.842     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.117  -114.919     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.196  -114.840     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.192  -114.838     0.200
END
gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile
    41.206  -114.834     0.200
END
# Circle of radius 1 and 2 degrees
gmt psxy -: -R $projection -SE -Wthicker,red -O << END >> $psfile
    41.166  -114.889     0.000   222.000   222.000
    41.166  -114.889     0.000   444.000   444.000
END
