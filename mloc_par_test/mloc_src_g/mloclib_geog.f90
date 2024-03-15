!***********************************************************************************************************************************
real function dgkmlogc (atmp)

   implicit none

   real :: atmp, rpd, dgkmla, dpr, radius
   
   data rpd/1.7453293e-2/, radius/6371./, dpr/57.29577951/

   dgkmla=dpr/radius
   dgkmlogc = dgkmla/sin(atmp*rpd) ! geocentric coordinates

   return
   
end function dgkmlogc

      
!***********************************************************************************************************************************
real function dgkmlo (atmp)

   implicit none

   real :: atmp, rpd, dgkmla, dpr, radius
   
   data rpd/1.7453293e-2/, radius/6371./, dpr/57.29577951/

   dgkmla=dpr/radius
   dgkmlo = dgkmla/cos(atmp*rpd) ! geographic coordinates

   return
   
end function dgkmlo


!***********************************************************************************************************************************
subroutine azgap (iev, openaz)

! Largest open angle from a set of azimuths. Only uses azimuth
! values for which the corresponding value of fltr is negative. In single
! mode, the open azimuth is based on fltrh. For a cluster, it is based
! on fltrc.

   implicit none

   include 'mloc.inc'

   integer :: indx(ntmax0), i, j, k, iev, naz
   real :: aztest(ntmax0), azdif, openaz, gap
   logical :: fltrtest
   character(len=132) :: msg
      
   naz = 0
   do i = 1, nst(iev) ! Form array of azimuths to test
      fltrtest = fltrc(iev,i)
      if (.not.fltrtest) then
         naz = naz + 1
         aztest(naz) = azes(iev,i)
         if (aztest(naz) .lt. 0. .or. aztest(naz) .ge. 360.) then
            if (aztest(naz) .lt. 0.) then
               do while (aztest(naz) .lt. 0.)
                  aztest(naz) = aztest(naz) + 360.
               end do
            else if (aztest(naz) .ge. 360.) then
               do while (aztest(naz) .ge. 360.)
                  aztest(naz) = aztest(naz) - 360.
               end do
            end if
         end if
      end if
   end do
   if (naz .le. 1) then
      openaz = 360.
      write (msg,'(a,i3,a)') 'azgap: naz = ', naz, '; openaz = 360'
      call warnings (trim(msg))
      return
   end if

   if (naz .ge. 1) then
      call indexx (naz, aztest, indx)
   else
      write (msg,'(a,i4,a)') 'azgap: illegal value for naz (', naz, ')'
      call oops (trim(msg))
   end if

   openaz = 0.
   do i = 1,naz-1
      j = indx(i)
      k = indx(i+1)
      azdif = aztest(k) - aztest(j)
      openaz = amax1(openaz,azdif)
   end do

   ! Check gap between largest and smallest azimuths
   gap = aztest(indx(1)) + 360. - aztest(indx(naz))
   openaz = amax1(openaz,gap)

   return
   
end subroutine azgap


!***********************************************************************************************************************************
subroutine set_longitude_range (lon, longitude_range)

! Keep longitude in the desired range, defined by the value of input variable 'longitude_range', which gives the center longitude
! of the desired range.

   implicit none
   
   real :: lon, temp
   integer :: longitude_range
   character(len=132) :: msg
   logical :: verbose_log
   
   verbose_log = .false.
   
   if (lon .lt. real(longitude_range-180))  then
      temp = lon
      lon = lon + 360.
      if (verbose_log) then
         write (msg,'(a,f8.3,a,f8.3)') 'set_longitude_range: ', temp, ' changed to ', lon
         call logit (trim(msg))
      end if
   end if
   
   if (lon .ge. real(longitude_range+180))  then
      temp = lon
      lon = lon - 360.
      if (verbose_log) then
         write (msg,'(a,f8.3,a,f8.3)') 'set_longitude_range: ', temp, ' changed to ', lon
         call logit (trim(msg))
      end if
   end if
         
   return
   
end subroutine set_longitude_range
 

!***********************************************************************************************************************************
subroutine geocen (glat, glon, elat, elats, elatc, elon, elons, elonc)

!  Converts geographic to geocentric coordinates. Latitude is measured 
!  positive to the south from the north pole, longitude is positive to the
!  east from the prime meridian.
     
!  Input:
!    glat   latitude in geographic coordinates
!    glon   longitude in geographic coordinates

!  Output:
!    elat   geocentric latitude
!    elats  sin(geocentric latitude)
!    elatc  cos(geocentric latitude)
!    elon   geocentric longitude
!    elons  sin(geocentric longitude)
!    elonc  cos(geocentric longitude)

   implicit none
   
   real :: glat, glon, elat, elats, elatc, elon, elons, elonc, deg, rad
         
   data deg/57.29577951/, rad/0.017453292/
   
   elat = 90.0 - deg*atan(0.9932773*(sin(glat*rad)/cos(glat*rad)))
   elats = sin(elat*rad)
   elatc = cos(elat*rad)
   elon = glon
   if (glon .lt. 0.0) elon = 360.0 + glon
   elons = sin(elon*rad)
   elonc = cos(elon*rad)
   
   return
   
end subroutine geocen
      
      
!***********************************************************************************************************************************
subroutine geogra (elat, glat)
      
! Input: elat    geocentric latitude
! Output glat    geographic latitude
! Engdahl's code

   implicit none

   real :: elat, glat, deg, rad, elatc, elats

   data deg/57.29577951/, rad/0.017453292/

   elats=sin (elat*rad)
   elatc=cos (elat*rad)
   glat=deg*atan(1.0067682*(elatc/elats))
   
   return
   
end subroutine geogra


!***********************************************************************************************************************************
subroutine delaz (eqlt, eqln, stlt, stln, delta, deltdg, deltkm, azeqst, azesdg, azsteq, azsedg, i)

!  compute distance and azimuth from earthquake (eq) to station (st).

!  delta  = distance between (eq) and (st) in radians.
!  azeqst = azimuth from (eq) to (st) clockwise from north in radians
!  azsteq = azimuth from (st) to (eq) clockwise from north in radians
!  cos(delta)  = aa
!  sin(delta)  = bb
!  sin(azeqst) = cc
!  sin(azsteq) = dd

!  i=0 if input coordinates are geographic degrees.
!  i=1 if input coordinates are geocentric radians.

!  subroutines called:
!    coortr (appended)

   implicit none
   
   include 'mloc.inc'
   
   integer :: i, deltm
   real :: eqltrd, eqlnrd, eqlt, eqln, stltrd, stlnrd, stlt, stln, cc, dd, delta, deltdg,&
    deltkm, azeqst, azesdg, azsteq, azsedg, eqstln, dx, dy, angle, dgkmlo, dgkmlogc
!   real :: eqlndg0, eqltdg0, stlndg0, stltdg0
   double precision :: desln, deqlt, dstlt, dse, dss, dses, dce, dcs, dces, aa, bb
   character(len=132) :: msg
   
   ! Convert to spherical polar coordinates in radians.
   if (i .eq. 0) then
	  call coortr (eqltrd , eqlnrd , eqlt , eqln , i)
	  call coortr (stltrd , stlnrd , stlt , stln , i)
	  eqltrd = pi/2. - eqltrd
	  stltrd = pi/2. - stltrd
	  dy = (stlt - eqlt)/dgkmla ! latitude difference in km
	  dx = (stln - eqln)/dgkmlo(eqlt) ! longitude difference in km
   else if (i .eq. 1) then
!         eqltrd=pi/2.-eqlt
	  eqltrd = eqlt
	  eqlnrd = eqln
!         stltrd=pi/2.-stlt
	  stltrd = stlt
	  stlnrd = stln
	  dy = (stltrd - eqltrd)*radius ! latitude difference in km
	  dx = (stlnrd - eqlnrd)*radius ! longitude difference in km
   else
      write (msg,'(a,i3)') 'delaz: illegal index: ', i
      call oops (trim(msg))
   end if
   deltkm = sqrt(dx*dx + dy*dy)
   
   if (deltkm .lt. 1.e-3) then ! Bail out if the separation is less than 1 meter
   
	  azeqst = 0.
	  azsteq = 0.
	  azesdg = 0.
	  azsedg = 0.
	  delta = 0.
	  deltdg = 0.
	  deltkm = 0.
      if (verbose_screen) call fyi ('delaz: identical eq and st; delta and azimuth set to zero')
      return
      
   else if (deltkm .lt. 1.) then ! Do short distances (< 1 km) in plane geometry
   
	  angle = atan2(dy,dx)
	  azeqst = (pi*0.5) - angle ! Convert to azimuth, clockwise from north, still in radians
	  if (azeqst .lt. 0.) azeqst = pi*2. + azeqst
	  azsteq = azeqst - pi
	  if (azsteq .lt. 0.) azsteq = pi*2. + azsteq
	  azesdg = azeqst*xdpr
	  azsedg = azsteq*xdpr
	  deltdg = deltkm*dgkmla
	  delta = deltdg*rpd
	  deltm = nint(deltkm*1.0e3)
      if (verbose_screen) then
         write (msg,'(a,i4,a,2(f5.3,a))') 'delaz: separation is only ', deltm, ' meters (', dx, ',', dy, ')'
         call fyi (trim(msg))
         write (*,'(t5,4f10.4)') eqlt, eqln, stlt, stln
      end if

   else ! Traditional calculation in spherical coordinates

	  eqstln = stlnrd - eqlnrd
	  desln = dble(eqstln)
	  deqlt = dble(eqltrd)
	  dstlt = dble(stltrd)
	  dse = dsin(deqlt)
	  dce = dcos(deqlt)
	  dss = dsin(dstlt)
	  dcs = dcos(dstlt)
	  dses = dsin(desln)
	  dces = dcos(desln)
	  aa = dce*dcs + dse*dss*dces
	  bb = dsqrt(1.0d0-aa*aa)
	  cc = sngl(dss*dses/bb)
	  dd = sngl(-dse*dses/bb)
	  delta = sngl(datan2(bb,aa))
	  azeqst = asin(cc)
	  azsteq = asin(dd)
	  if ((dse*dcs - dce*dss*dces) .lt. 0.) azeqst = pi - azeqst
	  if (azeqst .lt. 0.) azeqst = pi*2. + azeqst
	  if ((dce*dss - dse*dcs*dces) .le. 0.) azsteq = pi - azsteq
	  if (azsteq .lt. 0.) azsteq = pi*2. + azsteq
	  deltdg = delta*xdpr
	  azesdg = azeqst*xdpr
	  azsedg = azsteq*xdpr
	  deltkm = delta*radius
   
   end if
   
   return
   
end subroutine delaz


!***********************************************************************************************************************************
subroutine coortr (alatrd, alonrd, alatdg, alondg, i)
      
!  alatrd (geocentric latitude in radians)
!  alonrd (geocentric longitude in radians)
!  alatdg (geographical latitude in degrees)
!  alogdg (geographical latitude in degrees)

!  if i=1, transformation from radians to degrees
!  if i=0, transformation from degrees to radians

!  no subroutines called

   implicit none
   
   include 'mloc.inc'
   
   integer :: i
   real :: alatrd, alatdg, alonrd, alondg, bbb, aaa, alat2
   character(len=132) :: msg

   if (i .eq. 0) then    ! Degrees to radians
      alatrd=alatdg*rpd
      alonrd=alondg*rpd
      bbb=abs(alatdg)
      if (bbb .lt. 89.9) then
         aaa=0.9933056*tan(alatrd)
         alatrd=atan (aaa)
      end if
   else if (i .eq. 1) then   ! Radians to degrees
      bbb=abs(alatrd)
      if (bbb .lt. 1.57) then
         aaa=tan(alatrd)/0.9933056
         alat2=atan(aaa)
      else 
         alat2=alatrd
      end if
      alatdg=alat2*xdpr
      alondg=alonrd*xdpr
   else
      write (msg,'(a,i9)') 'coortr: illegal value for i: ', i
      call oops (trim(msg))
   end if

   return
   
end subroutine coortr


!***********************************************************************
subroutine surface_focus (phasein, depth, delta, dtddel, sfd)

! Input: phasein (phase name)
!        depth (focal depth in km)
!        delta (epicentral distance in degrees)
!        dtdel (ray parameter, in seconds per degree)

! Output: sfd (epicentral distance with distance to first bouncepoint removed)

   implicit none

   character(len=8) :: phasein
   real :: depth, delta, sfd, dtddel, bpdel, bptim
   integer :: ierr, iupcor

   sfd = delta
   if (depth .gt. 0.) then
      ierr = iupcor(phasein(1:1), abs(dtddel), bpdel, bptim)
      if (ierr .lt. 0) call warnings ('surface_focus: iupcor failed')
      if (dtddel .lt. 0.0) bpdel = -bpdel
      if (phasein(1:1) .eq. 'p' .or. phasein(1:1) .eq. 's') bpdel = -bpdel
      sfd = delta + bpdel
   end if

   !print *,'surface_focus: phasein depth delta sfd = ', phasein, depth, delta, sfd

   return
   
end subroutine surface_focus
      

!***********************************************************************
real function dlttrn (depth)

!  for a ray with a turning depth of 'depth', 'dlttrn' is the epicentral
!  distance from the turning point to where the ray reaches the earths
!  surface (degrees). it is calculated with respect to the 1968 herrin
!  tables for depths less than 800 km.

   implicit none

   real :: d(17), depth, x
   integer :: i, j
   
   data d(1)/0.0/, d(2)/3.0/, d(3)/6.5/, d(4)/7.6/, d(5)/8.3/,d(6)/8.7/, d(7)/9.2/, d(8)/9.7/, d(9)/10.1/, d(10)/10.4/,&
    d(11)/10.7/, d(12)/11.2/, d(13)/11.8/, d(14)/12.2/, d(15)/13.2/, d(16)/14.2/, d(17)/16.5/

   x = depth/50. + 1.
   i = int(x)
   j = i + 1
   x = x - i
   dlttrn = d(i) + x*(d(j)-d(i))

   return
   
end function dlttrn


!*****************************************************************************************
subroutine cluster_vector_perturb (it)

! For a geographically large cluster with indirect calibration and widely-separated calibration
! events the length of cluster vectors can be slightly expanded or contracted to account for
! distortion due to variance of true travel times from the theoretical TT model. This subroutine
! allows for a very ad hoc correction. Limited experience indicates this may be in the range ±1-2%.

! Input: 'perturbation' is a positive or negative percentile (e.g. '0.01' for 1% expansion)

   implicit none
   
   include 'mloc.inc'
   
   real :: ddel, dlat, dlon, dgkmlo, la, az
   real :: delta, deltdg, deltkm, azeqst, azesdg, azsteq, azsedg
   integer :: iev, it
   character(len=132) :: msg
   
   write (msg,'(a,f6.3)') 'cluster_vector_perturb: perturbation factor = ', perturbation
   write (io_log,'(a)') trim(msg)
   if (verbose_screen) call fyi (trim(msg))
   
   do iev = 1,nev
      call delaz (lath(it+1), lonh(it+1), latp(iev,it+1), lonp(iev,it+1),&
       delta, deltdg, deltkm, azeqst, azesdg, azsteq, azsedg, 0)
      ddel = deltkm*perturbation
      az = (90./xdpr) - azeqst ! convert azimuth to 'math' orientation (counterclockwise from east)
      dlat = ddel*sin(az) ! in km
      dlon = ddel*cos(az) ! in km
      la = latpgc(iev,it+1) - dlat*dgkmla
      call geogra (la,latp(iev,it+2))
      lonp(iev,it+2) = lonp(iev,it+1) + dlon*dgkmlo(latp(iev,it+2))
      write (io_log,'(i3,1x,2f10.3,5f10.2,2f10.3)') iev, latp(iev,it+1), lonp(iev,it+1),&
       azesdg, deltkm, ddel, dlat, dlon, latp(iev,it+2), lonp(iev,it+2)
      if (verbose_screen) write (*,'(i3,1x,2f10.3,5f10.2,2f10.3)') iev, latp(iev,it+1), lonp(iev,it+1),&
       azesdg, deltkm, ddel, dlat, dlon, latp(iev,it+2), lonp(iev,it+2)
      latp(iev,it+1) = latp(iev,it+2)
      lonp(iev,it+1) = lonp(iev,it+2)
   end do

   return
   
end subroutine cluster_vector_perturb