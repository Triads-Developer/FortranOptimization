!*****************************************************************************************
logical function tt_exist (phase_in, delta_test, depth_test)

! Ensure the phase exists at the depth and epicentral distance range.

   implicit none
   
   include 'mloc.inc'

   ! tau-p variables
   integer, parameter :: max = 60
   real :: tt(max), dtdd(max), dtdh(max), dddp(max)
   integer :: nphase, i, j
   character(len=8) :: phcd(max)

   character(len=8) :: phase_in
   real :: delta_test, depth_test
   
   tt_exist = .false.
   
   if (.not.locmod) then
      call trtm (delta_test, max, nphase, tt, dtdd, dtdh, dddp, phcd)
   else
      call tt_mixed_model (depth_test, delta_test, nphase, tt, dtdd, dtdh, dddp, phcd)
   end if
   do j=1,nphase
      if (phcd(j) .eq. phase_in) then
         tt_exist = .true.
         return
      end if
   end do
   
   return

end function tt_exist

!*****************************************************************************************
subroutine ttdat (phtest, i1, i2, dincrement, vred, hp)
   
! For a given phase and distance range, finds travel times and writes data lines for GMT plotting.
! If no TT is found, nothing is written. 
! vred = inverse reduction velocity, in seconds per degree.
! i1 and i2 are indices for epicentral distance, which is discretized at "dincrement" deg.
! hp is the depth for which travel times should be calculated, only needed for custom crust model

   implicit none
   
   include 'mloc.inc'

   integer max
   parameter (max=60)
   real tt(max), dtdd(max), dtdh(max), dddp(max), hp, tt_p_, tt_lg, tt_rg
   integer nphase
   character*8 phcd(max), phtest
   logical stype
   
   integer i, j, i1, i2
   real d, ttred, vred, dincrement
   
   do i = i1,i2
      d = real(i) * dincrement
      if (.not.locmod) then
         call trtm (d, max, nphase, tt, dtdd, dtdh, dddp, phcd)
      else
         call tt_mixed_model (hp, d, nphase, tt, dtdd, dtdh, dddp, phcd)
      end if
      do j = 1,nphase
         if (phcd(j) .eq. phtest) then
            ttred = tt(j) - vred*d
            write (io_gmt,'(2f10.3)') ttred, d
            exit
         end if
      end do
      
      ! S-P relative phase
      if (phtest(1:3) .eq. 'S-P') then
         ! Find the first S phase
         do j = 1,nphase
            if (stype(phcd(j))) exit
         end do
         ttred = tt(j) - tt(1) - vred*d
         write (io_gmt,'(2f10.3)') ttred, d
      end if
      
      ! P_ travel time
      if (phtest .eq. 'P_      ') then
         tt_p_ = p__a + d*p__b
         ttred = tt_p_ - vred*d
         write (io_gmt,'(2f10.3)') ttred, d
      end if

      ! Lg travel time
      if (phtest .eq. 'Lg      ') then
         tt_lg = lg_a + d*lg_b
         ttred = tt_lg - vred*d
         write (io_gmt,'(2f10.3)') ttred, d
      end if
      
      ! Rg travel time
      if (phtest .eq. 'Rg      ') then
         tt_rg = rg_a + d*rg_b
         ttred = tt_rg - vred*d
         write (io_gmt,'(2f10.3)') ttred, d
      end if
      
   end do
   
   return
   
end subroutine ttdat


!*****************************************************************************************
subroutine ttdat_reduced (phtest, i1, i2, dincrement, hp)
   
! For a given phase and distance range, finds travel times and writes data lines for GMT plotting.
! This routine is used only for the PKP caustic plot. Times are reduced by the theoretical
! time for PKPdf.
! If no TT is found, nothing is written. 
! i1 and i2 are indices for epicentral distance, which is discretized at "dincrement" deg.
! hp is the depth for which travel times should be calculated, only needed for custom crust model

   implicit none
   
   include 'mloc.inc'

   integer max
   parameter (max=60)
   real tt(max), dtdd(max), dtdh(max), dddp(max), hp, tt_p_, tt_lg, tt_rg, tt_reduced
   integer nphase
   character*8 phcd(max), phtest
   logical stype
   
   integer i, j, i1, i2
   real d, ttred, dincrement
   
   do i = i1,i2
      d = real(i) * dincrement
      if (.not.locmod) then
         call trtm (d, max, nphase, tt, dtdd, dtdh, dddp, phcd)
      else
         call tt_mixed_model (hp, d, nphase, tt, dtdd, dtdh, dddp, phcd)
      end if
      ttred = -1.
      do j = 1,nphase
         if (phcd(j) .eq. 'PKPdf   ') then
            ttred = tt(j)
            exit
         end if
      end do
      if (ttred .lt. 0.) cycle
      do j = 1,nphase
         if (phcd(j) .eq. phtest) then
            tt_reduced = tt(j) - ttred
            write (io_gmt,'(2f10.3)') tt_reduced, d
            exit
         end if
      end do
   end do
   
   return
   
end subroutine ttdat_reduced


!*****************************************************************************************
subroutine ttdat2 (phtest, delta, vred, hp, ttred)
   
! Used to calculate the location in a travel-time plot for a phase label.
! vred = inverse reduction velocity, in seconds per degree.
! hp is the depth for which travel times should be calculated, only needed for custom crust model
! If no TT can be computed, returns -1. This could also happen if vred is too large.

   implicit none
   
   include 'mloc.inc'

   integer max
   parameter (max=60)
   real tt(max), dtdd(max), dtdh(max), dddp(max), hp, tt_p_, tt_lg, tt_rg
   integer nphase
   character*8 phcd(max), phtest
   logical stype
   
   integer j
   real ttred, vred, delta
   
   ttred = -1.0
   
   if (.not.locmod) then
	  call trtm (delta, max, nphase, tt, dtdd, dtdh, dddp, phcd)
   else
	  call tt_mixed_model (hp, delta, nphase, tt, dtdd, dtdh, dddp, phcd)
   end if
   do j = 1,nphase
	  if (phcd(j) .eq. phtest) then
		 ttred = tt(j) - vred*delta
		 exit
	  end if
   end do
   
   ! S-P relative phase
   if (phtest(1:3) .eq. 'S-P') then
	  ! Find the first S phase
	  do j = 1,nphase
		 if (stype(phcd(j))) exit
	  end do
	  ttred = tt(j) - tt(1) - vred*delta
   end if
   
   ! P_ travel time
   if (phtest .eq. 'P_      ') then
	  tt_p_ = p__a + delta*p__b
	  ttred = tt_p_ - vred*delta
   end if

   ! Lg travel time
   if (phtest .eq. 'Lg      ') then
	  tt_lg = lg_a + delta*lg_b
	  ttred = tt_lg - vred*delta
   end if
   
   ! Rg travel time
   if (phtest .eq. 'Rg      ') then
	  tt_rg = rg_a + delta*rg_b
	  ttred = tt_rg - vred*delta
   end if
   
   return
   
end subroutine ttdat2


!*****************************************************************************************
subroutine map_boundaries (it1, iplot, xlonmin, xlonmax, ylatmin, ylatmax)
   
! Creates a string for defining the map region in the GMT plot script
   
   implicit none
   
   include 'mloc.inc'

   integer :: it1, iplot, iev
   real :: ylatmin, ylatmax, xlonmin, xlonmax, lon_test
   
   xlonmin = 360.
   xlonmax = -360.
   ylatmin = 90.
   ylatmax = -90.
   do iev = 1,nev
      if (plot(iev,iplot)) then
      
         lon_test = lonp(iev,it1)
         call set_longitude_range (lon_test, longitude_range)
         
         if (latp(iev,it1) .lt. ylatmin) ylatmin = latp(iev,it1)
         if (latp(iev,it1) .gt. ylatmax) ylatmax = latp(iev,it1)
         lon_test = lonp(iev,it1)
         call set_longitude_range (lon_test, longitude_range)
         if (lon_test .lt. xlonmin) xlonmin = lon_test
         if (lon_test .gt. xlonmax) xlonmax = lon_test
         
         if (latp(iev,0) .lt. ylatmin) ylatmin = latp(iev,0)
         if (latp(iev,0) .gt. ylatmax) ylatmax = latp(iev,0)
         lon_test = lonp(iev,0)
         call set_longitude_range (lon_test, longitude_range)
         if (lon_test .lt. xlonmin) xlonmin = lon_test
         if (lon_test .gt. xlonmax) xlonmax = lon_test
         
         if (calibration) then
            if (latp_cal(iev) .lt. ylatmin) ylatmin = latp_cal(iev)
            if (latp_cal(iev) .gt. ylatmax) ylatmax = latp_cal(iev)
            lon_test = lonp_cal(iev)
            call set_longitude_range (lon_test, longitude_range)
            if (lon_test .lt. xlonmin) xlonmin = lon_test
            if (lon_test .gt. xlonmax) xlonmax = lon_test
         end if
         
      end if
   end do

   ylatmin = ylatmin - 0.1
   ylatmax = ylatmax + 0.1
   xlonmin = xlonmin - 0.1
   xlonmax = xlonmax + 0.1
   
   return
   
end subroutine map_boundaries


!*****************************************************************************************
subroutine run_gmt_script (gmt_script, psfile)

! Standard processing of GMT scripts for plotting:
   
! Execute the GMT script (in mloc_working directory)
! Convert the postscript file to PDF
! Move the PDF file back into the cluster directory
! Delete the postscript file, or move certain ones into the _comcat folder if ComCat output is being created.
   
   implicit none
   
   include 'mloc.inc'
   
   character(len=160) :: command_line
   character(len=132) :: pdf_file
   character*(*) gmt_script, psfile
   integer :: lps
   
   lps = len_trim(psfile)
   pdf_file = psfile(1:lps-2)//'pdf'
   
   command_line = 'chmod +x '//gmt_script
   call system (trim(command_line))
   command_line = './'//gmt_script
   call system (trim(command_line))
   command_line = 'gmt psconvert -Tf -A1 '//trim(psfile)
   call system (trim(command_line))
   command_line = 'mv '//trim(pdf_file)//' '//trim(datadir)//dirsym//trim(pdf_file)
   call system (trim(command_line))
   
   ! If ComCat output is requested some postscript files are moved to the _comcat folder
   ! after conversion to PDF files. Otherwise, they are deleted.  
   if (comcatout) then
      if (index(psfile, '_epa_') .ne. 0) then ! Empirical path anomaly plot (epap)
         call system ('rm '//trim(psfile))
      else if (index(psfile, '_rdp') .ne. 0) then ! Catches summary plot and individual event plots for relative depth phases
         call system ('rm '//trim(psfile))   
      else if (index(psfile, '_tt5e_local') .ne. 0) then ! Local distance event plot (tt5e)
         call system ('rm '//trim(psfile))   
      else if (index(psfile, '_tt5s_local') .ne. 0) then ! Local distance station plot (tt5s)
         call system ('rm '//trim(psfile))   
      else if (index(psfile, 's_minus_p') .ne. 0) then ! S-P plot (tt9)
         call system ('rm '//trim(psfile))   
      else if (index(psfile, '_sel') .ne. 0) then ! selected events plot
         call system ('rm '//trim(psfile))   
      else 
         command_line = 'mv '//trim(psfile)//' '//trim(ccat_folder)//dirsym//trim(psfile)
         call system (trim(command_line))
      end if
   else
      call system ('rm '//trim(psfile))
   end if
   
   return
   
end subroutine run_gmt_script


!*****************************************************************************************
logical function pass (fcode)
   
   character*1 fcode
   
   pass = (fcode .ne. 'x' .and. &
           fcode .ne. 'd' .and. &
           fcode .ne. 'p' .and. &
           fcode .ne. 's' .and. &
           fcode .ne. 'a' .and. &
           fcode .ne. 'm' .and. &
           fcode .ne. 't')
   
   return
   
end function pass


!*****************************************************************************************
subroutine xsec_profile (it1, cs_id, cvxp_min, cvxp_max)

! Calculate end points of a depth section profile

   implicit none
   
   include 'mloc.inc'
   
   integer :: it1, iev, cs_id
   real :: cvx, cvy, cvxp, cvyp, cvxp_min, cvxp_max, theta, dgkmlo, cv_length
   
   ! Final cluster vectors in km, projected
   ! Cluster vectors are the same for indirect calibration so no special processing
   cvxp_min = 0.
   cvxp_max = 0.
   theta = (90. - xsec_az(cs_id))*rpd ! Convert to radians counterclockwise from positive x axis
   do iev = 1,nev ! Loop over events
	  cvx = (lonp(iev,it1) - lonh(it1))/dgkmlo(lath(it1))
	  cvy = (latp(iev,it1) - lath(it1))/dgkmla
	  cv_length = sqrt(cvx*cvx + cvy*cvy)
	  ! Rotate coordinates
	  if (cv_length .gt. 0.01) then
		 cvxp = cvx*cos(theta) + cvy*sin(theta)
		 cvyp = cvy*cos(theta) - cvx*sin(theta)
	  else
		 cvxp = 0.
		 cvyp = 0.
	  end if
	  ! End points on projected plane
	  if (cvxp .gt. cvxp_max) cvxp_max = cvxp
	  if (cvxp .lt. cvxp_min) cvxp_min = cvxp
   end do
   
   ! Same as xsec_gmt plot limits
   cvxp_max = cvxp_max + 5.
   if (cvxp_max .lt. 10.) cvxp_max = 10.
   cvxp_min = cvxp_min - 5.
   if (cvxp_min .gt. -10.) cvxp_min = -10.
   
   return
      
end subroutine xsec_profile

