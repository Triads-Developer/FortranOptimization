!*****************************************************************************************
      subroutine base_map (it, iplot, number_plot, conf_ellipse_plot, vectors_plot, suffix)
      
      ! Create a GMT script to plot the basemap with various options about what is plotted.
      ! The "ishell" parameter is used to specify the shell script to use. bash, csh and zsh
      ! are currently implemented.
      
      implicit none
      
      include 'mloc.inc'
      
      integer :: it, it1, iev, i, j, iplot, lenb
      real :: xlonmin, xlonmax, ylatmin, ylatmax, xl, yl, xymax, diameter,&
       cv22(2,2), alpha, al, bl, lon_test, ylatcirhe, xloncirhe, dgkmlo, label_offset
      real :: dp_minus, dp_plus, dp_az
      character(len=180) :: command_line
      character(len=132) :: gmt_script, psfile, part1, plot_title, gmt_script_path, msg
      character(len=30) :: comline1, comline2, dashb, part2, part4
      character(len=6) :: dp_pr
      character(len=4) :: shell
      character(len=1) :: ic
      character(len=*) :: suffix
      logical :: number_plot, conf_ellipse_plot, vectors_plot
      
      If (len_trim(suffix) .eq. 5 .and. suffix .eq. '_base') then
         call fyi ('base_map: base plot')
      else if (len_trim(suffix) .eq. 4 .and. suffix .eq. '_ell') then
         call fyi ('base_map: base plot, confidence ellipses only')
      else if (len_trim(suffix) .eq. 5 .and. suffix .eq. '_seis') then
         call fyi ('base_map: base plot, seismicity')
      else if (len_trim(suffix) .eq. 4 .and. suffix .eq. '_sel') then
         write (msg,'(a,i1)') 'base_map: base plot, selected events #', iplot
         call fyi (trim(msg))
      else
         call warnings ('base_map: unknown plot type ('//trim(suffix)//')')
         return
      end if
      
      dashb = ' '
      it1 = it + 1
            
      ! Open output script files and specify the shell
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      if (iplot .eq. 0) then ! Plot all events
         gmt_script = trim(basename)//trim(suffix)//'.'//trim(shell)
      else ! Plot selected events
         write (ic,'(i1)') iplot
         gmt_script = trim(basename)//trim(suffix)//ic//'.'//trim(shell)
      end if
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'base_map: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset FORMAT_GEO_MAP D' ! Use '+D' for 0-360 longitude
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
      
      ! Name of output script file.
      select case (ishell)
         case (1)
            if (iplot .eq. 0) then
               psfile = trim(basename)//trim(suffix)//'.ps'
            else
               psfile = trim(basename)//trim(suffix)//ic//'.ps'
            end if
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         case (2)
            if (iplot .eq. 0) then
               psfile = trim(basename)//trim(suffix)//'.ps'
            else
               psfile = trim(basename)//trim(suffix)//ic//'.ps'
            end if
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         case (3)
            if (iplot .eq. 0) then
               psfile = trim(basename)//trim(suffix)//'.ps'
            else
               psfile = trim(basename)//trim(suffix)//ic//'.ps'
            end if
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
      end select
      
      ! Projection
      select case (ishell)
         case (1)
            write (io_gmt,'(a)') 'projection=-JM16.0c+' 
         case (2)
            write (io_gmt,'(a)') 'set projection = -JM16.0c+'
         case (3)
            write (io_gmt,'(a)') 'projection=-JM16.0c+' 
      end select
      
      ! Map boundaries
      call map_boundaries (it1, iplot, xlonmin, xlonmax, ylatmin, ylatmax)
      comline1 = ' '
      comline2 = ' '
      write (comline1,'(f6.1,3(a,f6.1))') xlonmin, '/', xlonmax, '/', ylatmin, '/', ylatmax
      j = 1
      do i = 1,lenb(comline1)
         if (comline1(i:i) .ne. ' ') then
            comline2(j:j) = comline1(i:i)
            j = j + 1
         end if
      end do
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'region=-R', trim(comline2)
         case (2)
            write (io_gmt,'(2a)') 'set region = -R', trim(comline2)
         case (3)
            write (io_gmt,'(2a)') 'region=-R', trim(comline2)
      end select
      
      ! Basemap
      xl = abs(xlonmax - xlonmin)
      yl = abs(ylatmax - ylatmin)
      xymax = max(xl, yl)
      if (xymax .gt. 10.) then
         dashb = "a5.0f1.0"
      else if (xymax .gt. 2.0) then
         dashb = "a1.0f0.1"
      else if (xymax .gt. 1.0) then
         dashb = "a0.5f0.1"         
      else
         dashb = "a0.2f0.1"
      end if
      plot_title = "'Base Map "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! Topography
      if (plot_dem2) then
         call dem2_gmt ()
      else if (plot_dem1) then
         call dem1_gmt (.false.)
      end if
      
      ! Coastlines and rivers     
      write (io_gmt,'(a)') 'gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile'
      
      ! Fault map(s)
      if (fault_map) then
         do i = 1,n_fault_map
            part1 = 'gmt psxy '//trim(mloc_path)//dirsym//trim(fault_map_filename(i))
            part2 = '$projection $region'
            part4 = '-O -K >> $psfile'
            write (io_gmt,'(7a)') trim(part1)//' '//trim(part2)//' '//trim(fault_plot_style)//' '//trim(part4)
         end do
      end if
      
      ! Cross-section locations, in thick blue lines
	  if (n_xsec .gt. 0) then
		 write (io_gmt,'(a)') '# Cross-section locations'
		 lon_test = lonh(it1)
		 call set_longitude_range (lon_test, longitude_range)
		 do i = 1,n_xsec
		    dp_az = xsec_az(i)
		    call xsec_profile (it1, i, dp_minus, dp_plus)
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -S=0.1 -Wthicker,blue -O -K << END >> $psfile'
            write (dp_pr,'(f6.1)') dp_plus
            write (io_gmt,'(3f10.3,1x,a)') lath(it1), lon_test, dp_az, trim(adjustl(dp_pr))//'k'		    
            write (io_gmt,'(a)') 'END'
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -S=0.1 -Wthicker,blue -O -K << END >> $psfile'
            write (dp_pr,'(f6.1)') dp_minus
            write (io_gmt,'(3f10.3,1x,a)') lath(it1), lon_test, dp_az, trim(adjustl(dp_pr))//'k'		    
            write (io_gmt,'(a)') 'END'
            dp_az = dp_az + 90.
            if (dp_az .ge. 360.) dp_az = dp_az - 360.
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -S=0.1 -Wthin,blue -O -K << END >> $psfile'
            write (dp_pr,'(f6.1)') 2.5
            write (io_gmt,'(3f10.3,1x,a)') lath(it1), lon_test, dp_az, trim(adjustl(dp_pr))//'k'		    
            write (io_gmt,'(a)') 'END'
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -S=0.1 -Wthin,blue -O -K << END >> $psfile'
            write (dp_pr,'(f6.1)') -2.5
            write (io_gmt,'(3f10.3,1x,a)') lath(it1), lon_test, dp_az, trim(adjustl(dp_pr))//'k'		    
            write (io_gmt,'(a)') 'END'
		 end do
	  end if
     
      ! Event numbers
      if (number_plot) then
         write (io_gmt,'(a)') '# Event numbers'
         do iev = 1,nev
            if (plot(iev,iplot)) then
               if (iev .lt. 10) then
                  write (io_gmt,'(a,i1,a)') 'gmt psxy -: -R $projection -Sl8p+t"',&
                   iev, '" -G0 -O -K << END >> $psfile'
               else if (iev .lt. 100) then
                  write (io_gmt,'(a,i2,a)') 'gmt psxy -: -R $projection -Sl8p+t"',&
                   iev, '" -G0 -O -K << END >> $psfile'
               else
                  write (io_gmt,'(a,i3,a)') 'gmt psxy -: -R $projection -Sl8p+t"',&
                   iev, '" -G0 -O -K << END >> $psfile'
               end if
               if (calibration) then
                  lon_test = lonp_cal(iev)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') latp_cal(iev), lon_test
               else
                  lon_test = lonp(iev,it1)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') latp(iev,it1), lon_test
               end if
               write (io_gmt,'(a)') 'END'
            end if
         end do
      end if
         
      ! Change in location from data file input locations in black, controlled by 'vectors(1)'.
      ! Change in location from HD starting location in green, controlled by 'vectors(2)'.
      ! For indirect calibration, calibration shift in red, controlled by 'vectors(3)').
      if (vectors_plot) then
         write (io_gmt,'(a)') '# Change in location, calibration shift if available'
         do iev = 1,nev
            if (plot(iev,iplot)) then
               if (vectors(2)) then
                  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green -O -K << END >> $psfile'
                  lon_test = lonp(iev,0)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') latp(iev,0), lon_test
                  lon_test = lonp(iev,it1)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') latp(iev,it1), lon_test
                  write (io_gmt,'(a)') 'END'
               end if
               if (calibration) then
                  if (vectors(1)) then
                     write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
                     lon_test = lon_inp(iev)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') lat_inp(iev), lon_test
                     lon_test = lonp_cal(iev)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') latp_cal(iev), lon_test
                     write (io_gmt,'(a)') 'END'
                  end if
                  if (vectors(3)) then
                     write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red -O -K << END >> $psfile'
                     lon_test = lonp(iev,it1)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') latp(iev,it1), lon_test
                     lon_test = lonp_cal(iev)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') latp_cal(iev), lon_test
                     write (io_gmt,'(a)') 'END'
                  end if
               else
                  if (vectors(1)) then
                     write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
                     lon_test = lon_inp(iev)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') lat_inp(iev), lon_test
                     lon_test = lonp(iev,it1)
                     call set_longitude_range (lon_test, longitude_range)
                     write (io_gmt,'(2f10.3)') latp(iev,it1), lon_test
                     write (io_gmt,'(a)') 'END'
                  end if
               end if
            end if
         end do
      end if

      ! Calibration locations marked by a red cross.
      if (calibration) then
         write (io_gmt,'(a)') '# Calibration locations marked by a red cross'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthick,red -O -K << END >> $psfile'
         do iev = 1,nev
            if (cal_event(iev,3)) then
               lon_test = cal_lon(iev,3)
               call set_longitude_range (lon_test, longitude_range)
               write (io_gmt,'(3f10.3)') cal_lat(iev,3), lon_test, 0.20
            end if
         end do
         write (io_gmt,'(a)') 'END'
      end if
      
      ! Confidence ellipse of the calibration event in red
      if (calibration) then
         write (io_gmt,'(a)') '# Calibration location confidence ellipses'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile'
         do iev = 1,nev
            if (cal_event(iev,3)) then
               cv22(1,1) = rcv(iev,3,1,1)
               cv22(1,2) = rcv(iev,3,1,2)
               cv22(2,1) = rcv(iev,3,1,2)
               cv22(2,2) = rcv(iev,3,2,2)
               call elips (cv22, alpha, al, bl)
               xl = sqrt(1./al)
               yl = sqrt(1./bl)
               lon_test = cal_lon(iev,3)
               call set_longitude_range (lon_test, longitude_range)
               write (io_gmt,'(5f10.3)') cal_lat(iev,3), lon_test, alpha, 2.*xl, 2.*yl
            end if
         end do
         write (io_gmt,'(a)') 'END'
      end if
         
      ! Residual calibration shift vector in blue. Only relevant if there are multiple calibration events. 
      if (ncal(3) .gt. 1 .and. vectors_plot .and. vectors(4)) then
         write (io_gmt,'(a)') '# Residual calibration shift vectors'
         do iev = 1,nev
            if (plot(iev,iplot)) then
               if (cal_event(iev,3)) then
                  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -O -K << END >> $psfile'
                  lon_test = cal_lon(iev,3)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') cal_lat(iev,3), lon_test
                  lon_test = lonp_cal(iev)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(2f10.3)') latp_cal(iev), lon_test
                  write (io_gmt,'(a)') 'END'
               end if
            end if
         end do
      end if
      
      ! Confidence ellipses.
      ! If confidence ellipses are not plotted, then open circles are plotted with the same radius for all events.
      ! Since v4.5.2, -SE option takes full axis lengths, not semi-axis.
      ! For indirect calibration ellipses are plotted at the locations from the calibrated cluster, not at the calibration locations.
      ! Confidence ellipses are just for relative locations (they don't include the uncertainty of the calibration process).
      if (conf_ellipse_plot) then
         write (io_gmt,'(a)') '# Confidence ellipses for relative location'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthick -O -K << END >> $psfile'
         do iev = 1,nev
            if (plot(iev,iplot)) then
               if (calibration) then
                  lon_test = lonp_cal(iev)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(5f10.3)') latp_cal(iev), lon_test, alphac(iev), 2.*xl1c(iev), 2.*xl2c(iev)
               else
                  lon_test = lonp(iev,it1)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(5f10.3)') latp(iev,it1), lon_test, alphac(iev), 2.*xl1c(iev), 2.*xl2c(iev)
               end if
            end if
         end do
         write (io_gmt,'(a)') 'END'
      else
         diameter = 1.0
         write (io_gmt,'(a)') '# Location symbols, open circles, diameter 1 km'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthicker -O -K << END >> $psfile'
         do iev = 1,nev
            if (plot(iev,iplot)) then
               if (calibration) then
                  lon_test = lonp_cal(iev)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(5f10.3)') latp_cal(iev), lon_test, 0., diameter, diameter
               else
                  lon_test = lonp(iev,it1)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_gmt,'(5f10.3)') latp(iev,it1), lon_test, 0., diameter, diameter
               end if
            end if
         end do
         write (io_gmt,'(a)') 'END'
      end if
      
      ! User-defined ellipses, in red
      if (ellipse_plot) then
         write (io_gmt,'(a)') '# User-defined ellipses'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthicker,red -O -K << END >> $psfile'
         do i = 1,n_ellipse
            write (io_gmt,'(5f10.3)') (ellipse_data(i,j), j=1,5)
         end do
         write (io_gmt,'(a/)') 'END'
      end if

      ! User-defined triangles (for stations), in blue
      if (stat_plot) then
         write (io_gmt,'(a)') '# User-defined triangles (stations)'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -St -Wthicker,blue -Gblue -O -K << END >> $psfile'
         do i = 1,n_stat
            write (io_gmt,'(5f10.3)') (stat_data(i,j), j=1,3)
         end do
         write (io_gmt,'(a/)') 'END'
      end if

      ! User-defined stars, in red
      if (star_plot) then
         do iev = 1,nev
			if (plot(iev,iplot)) then ! Check if the event is among the selected events for plotting
			   write (io_gmt,'(a)') '# User-defined stars'
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sa -Wthicker,red -Gred -O -K << END >> $psfile'
			   do i = 1,n_star
			      if (iev .eq. iev_star(i)) then
					 if (calibration) then
						lon_test = lonp_cal(iev_star(i))
						call set_longitude_range (lon_test, longitude_range)
						write (io_gmt,'(3f10.3)') latp_cal(iev_star(i)), lon_test, star_size(i)
					 else
						lon_test = lonp(iev_star(i),it1)
						call set_longitude_range (lon_test, longitude_range)
						write (io_gmt,'(3f10.3)') latp(iev_star(i),it1), lon_test, star_size(i)
					 end if
				  end if
			   end do
			   write (io_gmt,'(a/)') 'END'
			end if
		 end do
      end if

      ! Center point for reference circle and hypocentroid ellipse, 6 km from lower left map boundaries
      xloncirhe = xlonmin + 6.0*(dgkmlo(ylatmin))
      ylatcirhe = ylatmin + 6.0*dgkmla

      ! Hypocentroid confidence ellipse, only for calibrated clusters
      ! If both direct and indirect calibration are used, ellipse for indirect is plotted.
      label_offset = 2.5*dgkmla
      if (calibration .or. direct_cal) then
         write (io_gmt,'(a)') '# Hypocentroid confidence ellipse'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthick,blue -O -K << END >> $psfile'
         if (calibration) then ! Indirect calibration
            write (io_gmt,'(5f10.3)') ylatcirhe, xloncirhe, alphagt, 2.*s1gt, 2.*s2gt 
         else if (direct_cal) then ! Direct calibration
            write (io_gmt,'(5f10.3)') ylatcirhe, xloncirhe, alphah, 2.*xl1h, 2.*xl2h
         end if
         write (io_gmt,'(a)') 'END'
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f6p,Helvetica,blue+a0.+jBL -O -K << END >> $psfile'
         write (io_gmt,'(2f10.3,3x,a)') ylatcirhe, xloncirhe+label_offset, 'Hypocentroid'
         write (io_gmt,'(a)') 'END'
      else
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f6p,Helvetica,blue+a0.+jBL -O -K << END >> $psfile'
         write (io_gmt,'(2f10.3,3x,a)') ylatcirhe, xloncirhe+label_offset, 'Uncalibrated'
         write (io_gmt,'(a)') 'END'
      end if

      ! Circle of radius 5 km for reference
      write (io_gmt,'(a)') '# Circle of radius 5 km for reference'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthick,red -O -K << END >> $psfile'
      write (io_gmt,'(5f10.3)') ylatcirhe, xloncirhe, 0., 10., 10. ! Since v4.5.2, -SE option takes full axis lengths, not semi-axis
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthinnest,blue -O -K << END >> $psfile'
      write (io_gmt,'(3f10.3)') ylatcirhe, xloncirhe, 0.07
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f6p,Helvetica-Bold,red+a0.+jBC -Gwhite -O << END >> $psfile'
      write (io_gmt,'(2f10.3,3x,a)') ylatcirhe-(5.0*dgkmla), xloncirhe, '5 km'
      write (io_gmt,'(a)') 'END'
      
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine base_map
      
      
!*****************************************************************************************
      subroutine dcal_map (it)
      
      !Create a GMT script to make the plot of raypaths used for diret calibration.
      
      implicit none
      
      include 'mloc.inc'
      
      integer :: it, it1, iev, i, j, ii, elevation_m, lenb
      real :: xlonmin, xlonmax, ylatmin, ylatmax, ylatcir, xloncir, dcal_distance, glat,&
       lon_test, dgkmlo, dlat, dlon
      character(len=180) :: command_line
      character(len=132) :: gmt_script, psfile, part1, plot_title, gmt_script_path, msg
      character(len=30) :: comline1, comline2, dashb, part2, part4
      character(len=4) :: shell
      character(len=5) :: suffix
      logical :: used
      
      call fyi ('dcal_map: direct calibration raypaths')
      
      dashb = ' '
      
      it1 = it + 1
            
      ! Open output script files and specify the shell
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      suffix = '_dcal'
      gmt_script = trim(basename)//trim(suffix)//'.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'dcal_map: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset FORMAT_GEO_MAP D' ! Use '+D' for 0-360 longitude
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
      
      ! Name of output script file.
      select case (ishell)
         case (1)
            psfile = trim(basename)//trim(suffix)//'.ps'
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         case (2)
            psfile = trim(basename)//trim(suffix)//'.ps'
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         case (3)
            psfile = trim(basename)//trim(suffix)//'.ps'
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
      end select
      
      ! Projection
      select case (ishell)
         case (1)
            write (io_gmt,'(a)') 'projection=-JM16.0c+' 
         case (2)
            write (io_gmt,'(a)') 'set projection = -JM16.0c+'
         case (3)
            write (io_gmt,'(a)') 'projection=-JM16.0c+' 
      end select
      
      ! Map boundaries
      call map_boundaries (it1, 0, xlonmin, xlonmax, ylatmin, ylatmax)
      dcal_distance = 200 ! km, distance scale for dcal plot
      dlat = dcal_distance * dgkmla
      dlon = dcal_distance * dgkmlo(lath(it1))
      ylatmin = ylatmin - dlat
      ylatmax = ylatmax + dlat
      xlonmin = xlonmin - dlon
      xlonmax = xlonmax + dlon
      comline1 = ' '
      comline2 = ' '
      write (comline1,'(f6.1,3(a,f6.1))') xlonmin, '/', xlonmax, '/', ylatmin, '/', ylatmax
      j = 1
      do i = 1,lenb(comline1)
         if (comline1(i:i) .ne. ' ') then
            comline2(j:j) = comline1(i:i)
            j = j + 1
         end if
      end do
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'region=-R', trim(comline2)
         case (2)
            write (io_gmt,'(2a)') 'set region = -R', trim(comline2)
         case (3)
            write (io_gmt,'(2a)') 'region=-R', trim(comline2)
      end select
      
      ! Basemap
      dashb = "a1.0f0.5"
      plot_title = "'Direct Calibration "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bx'//trim(dashb)//' ',&
            '-By'//trim(dashb)//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! Topography
      if (plot_dem1) call dem1_gmt (.false.)
      
      ! Coastlines and rivers     
      write (io_gmt,'(a)') 'gmt pscoast $projection $region -Df -Ia/blue -Wblue -O -K >> $psfile'
      
      ! Fault map(s)
      if (fault_map) then
         do i = 1,n_fault_map
            part1 = 'gmt psxy '//trim(mloc_path)//dirsym//trim(fault_map_filename(i))
            part2 = '$projection $region'
            part4 = '-O -K >> $psfile'
            write (io_gmt,'(7a)') trim(part1)//' '//trim(part2)//' '//trim(fault_plot_style)//' '//trim(part4)
         end do
      end if
      
      ! Raypaths used in direct calibration.
      if (rpth) then
		 write (io_gmt,'(a)') '# Raypaths used in direct calibration'
		 do iev = 1,nev
			do ii = 1,nst(iev)
			   if (.not.fltrh(iev,ii)) then
				  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -O -K << END >> $psfile'
				  call geogra (stladg(iev,ii), glat) ! Convert from geocentric to geographic latitude
				  lon_test = stlndg(iev,ii)
				  call set_longitude_range (lon_test, longitude_range)
				  write (io_gmt,'(2f10.3)') glat, lon_test
				  if (calibration) then
					 lon_test = lonp_cal(iev)
					 call set_longitude_range (lon_test, longitude_range)
					 write (io_gmt,'(2f10.3)') latp_cal(iev), lon_test
				  else
					 lon_test = lonp(iev,it1)
					 call set_longitude_range (lon_test, longitude_range)
					 write (io_gmt,'(2f10.3)') latp(iev,it1), lon_test
				  end if
				  write (io_gmt,'(a)') 'END'
			   end if
			end do
		 end do
      end if
      
      ! Stations used in direct calibration.
      write (io_gmt,'(a)') '# Seismic stations used for direct calibration, marked by a triangle'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -St -Wthick,black -Gblack -O -K << END >> $psfile'
      write (io_stn_log,'(/a)') 'Seismic stations used for direct calibration.'
      nstn_used = 1
      stn_dcal_used(1) = ' '
      do iev = 1,nev
         do ii = 1,nst(iev)
            if (.not.fltrh(iev,ii) .and. phase(iev,ii) .ne. 'S-P     ') then
               used = .false.
               do j = 1,nstn_used
                  if (stname(iev,ii)//deployment(iev,ii) .eq. stn_dcal_used(j)) then
                     used = .true.
                     exit
                  end if
               end do
               if (.not.used) then
                  nstn_used = nstn_used + 1
                  stn_dcal_used(nstn_used) = stname(iev,ii)//deployment(iev,ii)
                  call geogra (stladg(iev,ii), glat) ! Convert from geocentric to geographic latitude
                  lon_test = stlndg(iev,ii)
                  elevation_m = nint(ahgts(iev,ii)*1.0e3)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_stn_log,'(a,1x,f8.4,1x,f9.4,1x,i5)') sad(iev,ii), glat, lon_test, elevation_m
                  write (io_gmt,'(3f10.3)') glat, lon_test, 0.30
               end if
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! S-P Stations used in direct calibration.
      write (io_gmt,'(a)') '# S-P stations used for direct calibration, marked by an open diamond'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sd -Wthick -O -K << END >> $psfile'
      write (io_stn_log,'(/a)') 'S-P stations used for direct calibration.'
      nstn_used = 1
      stn_dcal_used(1) = ' '
      do iev = 1,nev
         do ii = 1,nst(iev)
            if (.not.fltrh(iev,ii) .and. phase(iev,ii) .eq. 'S-P     ') then
               used = .false.
               do j = 1,nstn_used
                  if (stname(iev,ii)//deployment(iev,ii) .eq. stn_dcal_used(j)) then
                     used = .true.
                     exit
                  end if
               end do
               if (.not.used) then
                  nstn_used = nstn_used + 1
                  stn_dcal_used(nstn_used) = stname(iev,ii)//deployment(iev,ii)
                  call geogra (stladg(iev,ii), glat) ! Convert from geocentric to geographic latitude
                  lon_test = stlndg(iev,ii)
                  elevation_m = nint(ahgts(iev,ii)*1.0e3)
                  call set_longitude_range (lon_test, longitude_range)
                  write (io_stn_log,'(a,1x,f8.4,1x,f9.4,1x,i5)') sad(iev,ii), glat, lon_test, elevation_m
                  write (io_gmt,'(3f10.3)') glat, lon_test, 0.25
               end if
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Cluster events, marked by open black circles
      write (io_gmt,'(a)') '# Cluster events, marked by open black circles'
      do iev = 1,nev
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,black -O -K << END >> $psfile'
         if (calibration) then
            lon_test = lonp_cal(iev)
            call set_longitude_range (lon_test, longitude_range)
            write (io_gmt,'(3f10.3)') latp_cal(iev), lon_test, 0.20
         else
            lon_test = lonp(iev,it1)
            call set_longitude_range (lon_test, longitude_range)
            write (io_gmt,'(3f10.3)') latp(iev,it1), lon_test, 0.20
         end if
         write (io_gmt,'(a)') 'END'
      end do
      
      ! Circle of radius 1 and 2 degrees from hypocentroid.
      write (io_gmt,'(a)') '# Circle of radius 1 and 2 degrees'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -SE -Wthicker,red -O << END >> $psfile'
      xloncir = lonh(it1)
      call set_longitude_range (xloncir, longitude_range)
      ylatcir = lath(it1)
      ! Since v4.5.2, -SE option takes full axis lengths, not semi-axis
      write (io_gmt,'(5f10.3)') ylatcir, xloncir, 0., 222., 222.
      write (io_gmt,'(5f10.3)') ylatcir, xloncir, 0., 444., 444.
      write (io_gmt,'(a)') 'END'
      
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      if (verbose_screen) call fyi ('dcal_map: script executed')

      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))

      if (verbose_screen) call fyi ('dcal_map: script moved')
      
      return
      end subroutine dcal_map
      
      
!*****************************************************************************************
      subroutine xsec_gmt (it, cs_id)
      
      ! Cross-section (depth profile)
      
      implicit none
      
      include 'mloc.inc'
      
      integer :: it, it1, cs_id, iev, i
      real :: proj_width, proj_height, ratio, dgkmlo, size, fdm, fdp, ddep
      real :: cvx, cvy, max_depth, theta, cvxp(nevmax), cvyp, cv_length
      real :: cvxp_min, cvxp_max, depthpp(nevmax), cvxp_length
      character(len=180) :: command_line
      character(len=100) ::  gmt_script, psfile, plot_title, gmt_script_path
      character(len=16) :: cproj
      character(len=6) :: cproj_width, cproj_height, cdepth, cdelt1, cdelt2
      character(len=4) :: shell, az_pr
      character(len=3) :: iev_pr
      character(len=1) :: cs
      character(len=132) :: msg
      
      data size/0.2/ ! cm
      
      call fyi ('xsec_gmt: Depth section plot')

      it1 = it + 1
      
      ! Index for cross-section
      write (cs,'(i1)') cs_id
       
      ! Final cluster vectors in km, projected
      ! Cluster vectors are the same for indirect calibration so no special processing
      write (io_log,'(/a)') 'Depth cross section '//cs
      cvxp_min = 0.
      cvxp_max = 0.
      theta = (90. - xsec_az(cs_id))*rpd ! Convert to radians counterclockwise from positive x axis
      write (io_log,'(2x,a,f7.1)') 'Projected to a vertical plane striking at azimuth ', xsec_az(cs_id)
      write (io_log,'(2x,a)') 'Cluster vector coordinates (km):'
      do iev = 1,nev ! Loop over events
         cvx = (lonp(iev,it1) - lonh(it1))/dgkmlo(lath(it1))
         cvy = (latp(iev,it1) - lath(it1))/dgkmla
         cv_length = sqrt(cvx*cvx + cvy*cvy)
         ! Rotate coordinates
         if (cv_length .gt. 0.01) then
			cvxp(iev) = cvx*cos(theta) + cvy*sin(theta)
			cvyp = cvy*cos(theta) - cvx*sin(theta)
		 else
		    cvxp(iev) = 0.
		    cvyp = 0.
		 end if
         write (io_log,'(2x,i3,2f8.2,a,2f8.2)') iev, cvx, cvy, ' after rotation of axes: ', cvxp(iev), cvyp
         ! X limits on projected plane
         if (cvxp(iev) .gt. cvxp_max) cvxp_max = cvxp(iev)
         if (cvxp(iev) .lt. cvxp_min) cvxp_min = cvxp(iev)
      end do
      cvxp_max = cvxp_max + 5.
      if (cvxp_max .lt. 10.) cvxp_max = 10.
      cvxp_min = cvxp_min - 5.
      if (cvxp_min .gt. -10.) cvxp_min = -10.
      write (io_log,'(2x,a,2f7.1)') 'Horizontal plot limits = ', cvxp_min, cvxp_max
      cvxp_length = cvxp_max - cvxp_min
      
      ! Maximum depth
      write (io_log,'(2x,a)') 'Depth section coordinates'
      max_depth = 0.
      do iev = 1,nev ! Loop over events
         depthpp(iev) = depthp(iev,it+1) ! Direct calibration or uncalibrated
         if (calibration) depthpp(iev) = depthp_cal(iev) ! Indirect calibration
         if (depthpp(iev) .gt. max_depth) max_depth = depthpp(iev)
         write (io_log,'(2x,i3,2f8.2)') iev, cvxp(iev), depthpp(iev)
      end do
      if (max_depth .lt. 10.) max_depth = 10.
      max_depth = max_depth + 5.
      write (io_log,'(2x,a,f5.1)') 'Plot limit for depth = ', max_depth
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_xsec_'//cs//'.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'xsec_gmt: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
      
      ! Basemap and associated variables
      psfile = trim(basename)//'_xsec_'//cs//'.ps'
      
      ratio = cvxp_length/max_depth
      if (ratio .ge. 1.) then
         proj_width = 18. ! cm
         proj_height = -proj_width/ratio
      else
         proj_width = amin1(23.0*ratio,18.0)
         proj_height = -proj_width/ratio
      end if
      write (cproj_width,'(f6.1)') proj_width
      write (cproj_height,'(f6.1)') proj_height
      cproj = trim(adjustl(cproj_width))//'/'//trim(adjustl(cproj_height))
      write (cdelt1,'(f6.1)') cvxp_min
      write (cdelt2,'(f6.1)') cvxp_max
      write (cdepth,'(f6.1)') max_depth
      plot_title = "'Cross-section "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX'//trim(adjustl(cproj))
            write (io_gmt,'(a)') 'region=-R'//trim(adjustl(cdelt1))//'/'//trim(adjustl(cdelt2))//'/0/'//trim(adjustl(cdepth))
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa10f10+l'//"'Distance (km)'"//' ',&
            '-Bya10f10+l'//"'Depth (km)'"//' ',&
            '-BWesN+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX'//trim(adjustl(cproj))
            write (io_gmt,'(a)') 'set region = -R'//trim(adjustl(cdelt1))//'/'//trim(adjustl(cdelt2))//'/0/'//trim(adjustl(cdepth))
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa10f10+l'//"'Distance (km)'"//' ',&
            '-Bya10f10+l'//"'Depth (km)'"//' ',&
            '-BWesN+t'//trim(plot_title)//' -K >! $psfile'            
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX'//trim(adjustl(cproj))
            write (io_gmt,'(a)') 'region=-R'//trim(adjustl(cdelt1))//'/'//trim(adjustl(cdelt2))//'/0/'//trim(adjustl(cdepth))
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa10f10+l'//"'Distance (km)'"//' ',&
            '-Bya10f10+l'//"'Depth (km)'"//' ',&
            '-BWesN+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! Depth plot for each event
      
      do iev = 1,nev ! Loop over events
      
         if (mindx(iev,3) .gt. 0) then ! Free depth relocation, red circle regardless of how initial depth was set
            write (io_gmt,'(a,i3,a)') '# Event ', iev, ' free depth'
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -Sc -K -O << END >> $psfile'
            write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size
            write (io_gmt,'(a)') 'END'
            ! Uncertainty
			if (direct_cal) then
			   ddep = ddepdc(iev)
			else
			   ddep = sdxhatc(iev,3)
			end if
			write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red -O -K << END >> $psfile'
			write (io_gmt,'(2f10.3)') depthpp(iev)-ddep, cvxp(iev)
			write (io_gmt,'(2f10.3)') depthpp(iev)+ddep, cvxp(iev)
			write (io_gmt,'(a)') 'END'
            
         else ! Fixed depth relocation
         
            write (io_gmt,'(a,i3,a)') '# Event ', iev, ' fixed depth, contraint code '//depset_pr(iev)
         
			fdp = depthp_plus(iev)
			fdm = depthp_minus(iev)
			   
            if (depset_pr(iev) .eq. 'c') then ! Cluster default depth in black cross, no uncertainty
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sx -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               
            else if (depset_pr(iev) .eq. 'd') then ! Depth from teleseismic depth phases, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'e') then ! Engineered epth (man-made), black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'f') then ! Depth from fault model (InSAR, GPS, etc), black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'i') then ! Depth from input data file preferred hypocenter, blue cross, no uncertainty
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -Sx -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               
            else if (depset_pr(iev) .eq. 'l') then ! Depth from local distance arrivals, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'm') then ! Depth from an mloc free depth relocation, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'n') then ! Depth from near-source arrivals, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'r') then ! Depth from a free-depth relocation outside of mloc, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else if (depset_pr(iev) .eq. 'u') then ! Depth from unknown source, blue cross, no uncertainty
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -Sx -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               
            else if (depset_pr(iev) .eq. 'w') then ! Depth from waveform modeling, black circle
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -Sc -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), size  
               write (io_gmt,'(a)') 'END'
               ! Uncertainty
			   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,black -O -K << END >> $psfile'
			   write (io_gmt,'(2f10.3)') depthpp(iev)-fdm, cvxp(iev)
			   write (io_gmt,'(2f10.3)') depthpp(iev)+fdp, cvxp(iev)
			   write (io_gmt,'(a)') 'END'
			   
            else
               msg = 'xsec_gmt: unknown depset_pr code: '//depset_pr(iev)
               call warnings (trim(msg))
               
            end if
         end if
         
         ! User-defined star
		 if (star_plot) then
			do i = 1,n_star
			   if (iev .eq. iev_star(i)) then
				  write (io_gmt,'(a)') '# User-defined star'
				  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sa -Wthicker,red -Gred -O -K << END >> $psfile'
                  write (io_gmt,'(3f10.3)') depthpp(iev), cvxp(iev), star_size(i)			   
			      write (io_gmt,'(a/)') 'END'
			   end if
			end do
		 end if
         
      end do
      
      ! Event numbers
	  write (io_gmt,'(/a)') '# Event numbers'
	  do iev = 1,nev
	     write (iev_pr,'(i3)') iev
		 write (io_gmt,'(3a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica,black+a0.+jBL -O -K << END >> $psfile'       
		 write (io_gmt,'(2f10.3,1x,a)') depthpp(iev), cvxp(iev)+size, trim(adjustl(iev_pr))
		 write (io_gmt,'(a)') 'END'
	  end do
                     
      ! Label
      write (io_gmt,'(/a)') '# Azimuth of the projection plane'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jTR -O << END >> $psfile'
      write (az_pr,'(i4)') nint(xsec_az(cs_id))
      write (io_gmt,'(2f10.3,1x,a)') 0.1, cvxp_max-0.1, 'Azimuth = '//trim(az_pr)
      write (io_gmt,'(a)') 'END'

      close (io_gmt)
      
      ! Run the GMT script and move .ps file back into the working directory
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine xsec_gmt
      
      
!*****************************************************************************************
      subroutine tt_summary (it)
      
      ! Creates a GMT script to plot summary travel times, 0-180 degrees, out to 1500 seconds (25 minutes).
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      
      implicit none
      
      include 'mloc.inc'
      
      integer iev, ird, it, it1
      real cross, usrc(2), dincrement, hp, delt_plot
      character(len=180) :: command_line
      character*100 gmt_script, psfile, plot_title, gmt_script_path
      character*4 shell
      character(len=132) :: msg
      
      call fyi ('tt_summary: tt1 plot')
      
      dincrement = 0.5
      
      it1 = it + 1
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_tt1_summary.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt1_summary_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
            
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
      
      ! Basemap and associated variables
      psfile = trim(basename)//'_tt1_summary.ps'
      plot_title = "'Summary Travel Times "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12/16'
            write (io_gmt,'(a)') 'region=-R0/180/0/1500'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa30f10+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya200f100+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX12/16'
            write (io_gmt,'(a)') 'set region = -R0/180/0/1500'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa30f10+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya200f100+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12/16'
            write (io_gmt,'(a)') 'region=-R0/180/0/1500'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa30f10+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya200f100+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select

      ! Theoretical TT curves, using hypocentroid depth
      hp = depthh(it1)
      call depset (hp, usrc)
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('P       ', 50, 220, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PKPdf   ', 220, 360, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'

      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PKiKP   ', 1, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'

      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PKPab   ', 288, 360, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PKPbc   ', 288, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PcP     ', 1, 200, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('PP      ', 50, 300, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('Pdiff   ', 200, 300, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('S       ', 1, 200, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('ScP     ', 1, 130, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('ScS     ', 1, 200, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('SS      ', 50, 140, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! Readings not used for cluster vectors in cyan
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,cyan -K -O << END >> $psfile'
      cross = 0.150 ! in cm
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (fltrc(iev,ird)) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, cross
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Readings used for cluster vectors in black
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
      cross = 0.150 ! in cm
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (.not.fltrc(iev,ird)) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, cross
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Legend
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 140., 60., 'P phases in red'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 100., 60., 'S phases in green'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 60., 60., 'Readings used for cluster vectors in black'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBL -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 20., 60., 'Readings not used for cluster vectors in cyan'
      write (io_gmt,'(a)') 'END'
      
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine tt_summary

!*****************************************************************************************
      subroutine tt_pkp_caustic (it)
      
      ! Creates a GMT script to plot travel times around the PKP caustic.
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      
      implicit none
      
      include 'mloc.inc'
      
      integer iev, ird, it, it1
      real size, dincrement, hp, usrc(2), delt_plot
      character(len=180) :: command_line
      character*100 gmt_script, psfile, plot_title, gmt_script_path
      character*4 shell
      logical pass
      character(len=132) :: msg
      
      call fyi ('tt_pkp_caustic: tt3 plot')

      dincrement = 0.5
      it1 = it + 1
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_tt3_pkp_caustic.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt3_pkp_caustic_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
    
      ! Basemap and associated variables
      psfile = trim(basename)//'_tt3_pkp_caustic.ps'
      plot_title = "'PKP Caustic "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12'
            write (io_gmt,'(a)') 'region=-R135/160/1160/1210'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX12'
            write (io_gmt,'(a)') 'set region = -R135/160/1160/1210'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12'
            write (io_gmt,'(a)') 'region=-R135/160/1160/1210'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! Theoretical TT curves, using hypocentroid depth
      hp = depthh(it1)
      call depset (hp, usrc)

      ! PKPdf in black
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'
      call ttdat ('PKPdf   ', 270, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! PKiKP in green
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'
      call ttdat ('PKiKP   ', 270, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! PKPab in blue
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O << END >> $psfile'
      call ttdat ('PKPab   ', 288, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! PKPbc in red
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'
      call ttdat ('PKPbc   ', 288, 320, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      size = 0.2 ! symbol size in cm
      
      ! PKPdf in black crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPdf   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! PKiKP in green crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKiKP   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! PKPab in blue crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPab   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! PKPbc in red crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPbc   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
            
      ! Anything else in cyan circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and.&
                phase(iev,ird) .ne. 'PKPdf   ' .and.&
                phase(iev,ird) .ne. 'PKiKP   ' .and.&
                phase(iev,ird) .ne. 'PKPab   ' .and.&
                phase(iev,ird) .ne. 'PKPbc   ' .and.&
                delt(iev,ird) .ge. 135.) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, 0.15
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Legend
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,blue+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 1208., 136., 'PKPab in blue'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,red+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 1206., 136., 'PKPbc in red'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,green+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 1204., 136., 'PKiKP in green'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 1202., 136., 'PKPdf in black'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,cyan+a0.+jBL -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 1200., 136., 'Other in cyan'
      write (io_gmt,'(a)') 'END'

      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine tt_pkp_caustic
      

!*****************************************************************************************
      subroutine tt_pkp_caustic2 (it)
      
      ! Creates a GMT script to plot travel times around the PKP caustic.
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      ! This version plots all arrivals as residuals against the arrival time of PKPdf at
      ! the appropriate epicentral distance. This works much better than the original
      ! subroutine 'tt_pkp_caustic' for clusters that include a wide range of depths. This
      ! routine drops plotting of "other" phases besides PKPdf, PKPab, PKPbc, and PKiKP.
      
      implicit none
      
      include 'mloc.inc'
      
      integer max
      parameter (max=60)
      real tt(max), dtdd(max), dtdh(max), dddp(max)
      integer nphase
      character*8 phcd(max)

      integer iev, ird, it, it1, np
      real size, usrc(2), delt_plot, reduction_tt, ttred, hp, dincrement
      character(len=180) :: command_line
      character*100 gmt_script, psfile, plot_title, gmt_script_path
      character*4 shell
      logical pass
      character(len=132) :: msg
      
      call fyi ('tt_pkp_caustic: tt3 plot')

      it1 = it + 1
      dincrement = 0.5
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_tt3_pkp_caustic.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt3_pkp_caustic_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
    
      ! Basemap and associated variables
      psfile = trim(basename)//'_tt3_pkp_caustic.ps'
      plot_title = "'PKP Caustic "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12'
            write (io_gmt,'(a)') 'region=-R135/160/-12/20'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX12'
            write (io_gmt,'(a)') 'set region = -R135/160/-20/20'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX12'
            write (io_gmt,'(a)') 'region=-R135/160/-12/20'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
            
      ! Theoretical TT curves
      
      ! Using hypocentroid depth, reduced by PKPdf theoretical time
      hp = depthh(it1)
      call depset (hp, usrc)

      ! PKPdf in black
      write (io_gmt,'(a)') '# PKPdf theoretical'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3)') 0., 135.
      write (io_gmt,'(2f10.3)') 0., 160.
      write (io_gmt,'(a)') 'END'
      
      ! PKiKP in green
      write (io_gmt,'(a)') '# PKiKP theoretical'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'
      call ttdat_reduced ('PKiKP   ', 270, 320, dincrement, hp)
      write (io_gmt,'(a)') 'END'
      
      ! PKPab in blue
      write (io_gmt,'(a)') '# PKPab theoretical'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O << END >> $psfile'
      call ttdat_reduced ('PKPab   ', 270, 320, dincrement, hp)
      write (io_gmt,'(a)') 'END'
      
      ! PKPbc in red
      write (io_gmt,'(a)') '# PKPbc theoretical'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'
      call ttdat_reduced ('PKPbc   ', 270, 320, dincrement, hp)
      write (io_gmt,'(a)') 'END'
      
      ! Observed Data
      
      size = 0.2 ! symbol size in cm

      ! PKPdf in black crosses
      write (io_gmt,'(a)') '# PKPdf observed'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
      do iev = 1,nev
         call depset (depthp(iev,it), usrc)
         do ird = 1,nst(iev)
            if (delt(iev,ird) .lt. 135. .or. delt(iev,ird) .gt. 160.) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPdf   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
               reduction_tt = 0.
               if (phcd(1) .eq. 'PKPdf   ') then
                  reduction_tt = tt(1)
               else
				  do np = 1,nphase
					 if (phcd(np) .eq. 'PKPdf   ') then
						reduction_tt = tt(np)
						exit
					 end if
				  end do
			   end if
               if (reduction_tt .ge. 1000.) then
				  ttred = tto(iev,ird) - reduction_tt
				  write (io_gmt,'(3f10.3)') ttred, delt_plot, size
			   else
			      write (msg,'(a,i3,3(a,1x),i5)') 'tt_pkp_caustic2: no reduction tt found for event ',&
			       iev, evtnam(iev), stname(iev,ird), phase(iev,ird), mnf_line(iev,ird)
			      call warnings (trim(msg))
			   end if
            end if
         end do
      end do      
      write (io_gmt,'(a)') 'END'
      
      ! PKPbc in red crosses
      write (io_gmt,'(a)') '# PKPbc observed'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         call depset (depthp(iev,it), usrc)
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPbc   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
               reduction_tt = 0.
               if (phcd(1) .eq. 'PKPdf   ') then
                  reduction_tt = tt(1)
               else
				  do np = 1,nphase
					 if (phcd(np) .eq. 'PKPdf   ') then
						reduction_tt = tt(np)
						exit
					 end if
				  end do
			   end if
               if (reduction_tt .ge. 1000.) then
				  ttred = tto(iev,ird) - reduction_tt
				  write (io_gmt,'(3f10.3)') ttred, delt_plot, size
			   else
			      write (msg,'(a,i3,3(a,1x),i5)') 'tt_pkp_caustic2: no reduction tt found for event ',&
			       iev, evtnam(iev), stname(iev,ird), phase(iev,ird), mnf_line(iev,ird)
			      call warnings (trim(msg))
			   end if
            end if
         end do
      end do      
      write (io_gmt,'(a)') 'END'
      
      
      ! PKPab in blue crosses
      write (io_gmt,'(a)') '# PKPab observed'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         call depset (depthp(iev,it), usrc)
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKPab   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
               reduction_tt = 0.
               if (phcd(1) .eq. 'PKPdf   ') then
                  reduction_tt = tt(1)
               else
				  do np = 1,nphase
					 if (phcd(np) .eq. 'PKPdf   ') then
						reduction_tt = tt(np)
						exit
					 end if
				  end do
			   end if
               if (reduction_tt .ge. 1000.) then
				  ttred = tto(iev,ird) - reduction_tt
				  write (io_gmt,'(3f10.3)') ttred, delt_plot, size
			   else
			      write (msg,'(a,i3,3(a,1x),i5)') 'tt_pkp_caustic2: no reduction tt found for event ',&
			       iev, evtnam(iev), stname(iev,ird), phase(iev,ird), mnf_line(iev,ird)
			      call warnings (trim(msg))
			   end if
            end if
         end do
      end do      
      write (io_gmt,'(a)') 'END'
      
      ! PKiKP in green crosses
      write (io_gmt,'(a)') '# PKiKP observed'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         call depset (depthp(iev,it), usrc)
         do ird = 1,nst(iev)
            if (delt(iev,ird) .lt. 135. .or. delt(iev,ird) .gt. 160.) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PKiKP   ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
               reduction_tt = 0.
               if (phcd(1) .eq. 'PKPdf   ') then
                  reduction_tt = tt(1)
               else
				  do np = 1,nphase
					 if (phcd(np) .eq. 'PKPdf   ') then
						reduction_tt = tt(np)
						exit
					 end if
				  end do
			   end if
               if (reduction_tt .ge. 1000.) then
				  ttred = tto(iev,ird) - reduction_tt
				  write (io_gmt,'(3f10.3)') ttred, delt_plot, size
			   else
			      write (msg,'(a,i3,3(a,1x),i5)') 'tt_pkp_caustic2: no reduction tt found for event ',&
			       iev, evtnam(iev), stname(iev,ird), phase(iev,ird), mnf_line(iev,ird)
			      call warnings (trim(msg))
			   end if
            end if
         end do
      end do      
      write (io_gmt,'(a)') 'END'
      
     ! Legend
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 19., 136., 'All times reduced by theoretical PKPdf travel time'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,green+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 18., 136., 'PKiKP in green (top layer)'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,blue+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 17., 136., 'PKPab in blue'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,red+a0.+jBL -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 16., 136., 'PKPbc in red'
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,black+a0.+jBL -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') 15., 136., 'PKPdf in black (bottom layer)'
      write (io_gmt,'(a)') 'END'

      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine tt_pkp_caustic2
      

!*****************************************************************************************
      subroutine tt_local_regional (it)
      
      ! Creates a GMT script to plot travel times at local and regional distances.
      ! This plot can be done reduced.
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      
      implicit none
      
      include 'mloc.inc'
      
      integer max
      parameter (max=60)
      real tt(max), dtdd(max), dtdh(max), dddp(max)
      integer nphase
      character*8 phcd(max)
      
      integer iev, ird, it, it1, i1
      real size, vred, ttred, dincrement, hp, usrc(2), delt_plot, delta_label, tt_label
      character(len=180) :: command_line
      character*100 gmt_script, psfile, plot_title, gmt_script_path
      character*4 shell
      logical pass
      character(len=132) :: msg
      
      call fyi ('tt_local_regional: tt6 plot')

      dincrement = 0.5
      it1 = it + 1
            
      if (reduced) then
         vred = 11.67 ! inverse reduction velocity, in seconds per degree (350 sec at 30 degress)
      else
         vred = 0.
      end if
            
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_tt6_local_regional.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt6_local_regional_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
    
      ! Basemap and associated variables
      psfile = trim(basename)//'_tt6_local_regional.ps'
      plot_title = "'Local-Regional "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'region=-R0/30/0/70'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya10f1+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            else
               write (io_gmt,'(a)') 'region=-R0/30/0/400'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            end if
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'set region = -R0/30/0/70'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya10f1+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
            else
               write (io_gmt,'(a)') 'set region = -R0/30/0/400'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
            end if
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'region=-R0/30/0/70'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya10f1+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            else
               write (io_gmt,'(a)') 'region=-R0/30/0/400'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            end if
      end select
      
      ! Reduction velocity
      if (reduced) then
         write (io_gmt,'(a)') '# Reduction velocity'
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBR -K -O << END >> $psfile'
         write (msg,'(a,f5.2,a)') 'Inverse reduction velocity: ', vred, ' sec/deg'
         write (io_gmt,'(2f10.3,1x,a)') 2., 27.5, trim(msg)
         write (io_gmt,'(a)') 'END'
      end if

      ! Theoretical TT curves, using hypocentroid depth
      hp = depthh(it1)
      call depset (hp, usrc)

      ! P in black
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
      call ttdat ('P       ', 1, 60, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# P label'
      delta_label = 28.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jTR -K -O << END >> $psfile'
      call ttdat2 ('P       ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-3., delta_label, 'P'
      write (io_gmt,'(a)') 'END'

      ! Pn in green
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('Pn      ', 1, 60, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Pn label'
      delta_label = 13.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Pn      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-3., delta_label, 'Pn'
      write (io_gmt,'(a)') 'END'

      ! Pb in blue
	  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O -Ve << END >> $psfile'      
	  call ttdat ('Pb      ', 1, 12, dincrement, vred, hp)
	  write (io_gmt,'(a)') 'END'
      
      ! P_ in cyan
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,cyan -K -O << END >> $psfile'
      i1 = nint(p__min/dincrement)
      call ttdat ('P_      ', i1, 10, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# P_ label'
      delta_label = 4.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBR -K -O << END >> $psfile'
      call ttdat2 ('P_      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label+3., delta_label, 'P_'
      write (io_gmt,'(a)') 'END'
      
      ! Pg in red
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('Pg      ', 1, 12, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Pg label'
      delta_label = 5.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Pg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-2., delta_label, 'Pg'
      write (io_gmt,'(a)') 'END'

      ! Sn in green
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('Sn      ', 1, 60, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sn label'
      delta_label = 4.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Sn      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-2., delta_label, 'Sn'
      write (io_gmt,'(a)') 'END'

      ! Sb in blue
	  write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O -Ve << END >> $psfile'      
	  call ttdat ('Sb      ', 1, 8, dincrement, vred, hp)
	  write (io_gmt,'(a)') 'END'
      
      ! Sg in red
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('Sg      ', 1, 8, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sg label'
      delta_label = 3.5
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Sg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-2., delta_label, 'Sg'
      write (io_gmt,'(a)') 'END'

      ! Lg in cyan
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,cyan -K -O << END >> $psfile' 
      i1 = nint(lg_min/dincrement)     
      call ttdat ('Lg      ', i1, 8, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Lg label'
      delta_label = 3.0
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBR -K -O << END >> $psfile'
      call ttdat2 ('Lg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label+2., delta_label, 'Lg'
      write (io_gmt,'(a)') 'END'

      size = 0.2 ! symbol size in cm
            
      ! Anything else in orange diamonds
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sd -Wthin,orange -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (phase(iev,ird) .ne. 'P       ' .and.&
                phase(iev,ird) .ne. 'Pn      ' .and.&
                phase(iev,ird) .ne. 'Pb      ' .and.&
                phase(iev,ird) .ne. 'Pg      ' .and.&
                phase(iev,ird) .ne. 'P_      ' .and.&
                phase(iev,ird) .ne. 'Sn      ' .and.&
                phase(iev,ird) .ne. 'Sb      ' .and.&
                phase(iev,ird) .ne. 'Sg      ' .and.&
                phase(iev,ird) .ne. 'Lg      ' .and.&
                phase(iev,ird) .ne. 'S-P     ' .and.&
                delt(iev,ird) .le. 30.) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               if (pass(fcode(iev,ird))) write (io_gmt,'(3f10.3)') ttred, delt_plot, 0.15
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! P in black crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'P       ' .and. delt(iev,ird) .le. 30.) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Pn in green crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pn      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Pb in blue crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pb      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! P_ in cyan crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'P_      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Pg in red crosses
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Sn in green circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sn      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Sb in blue circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sb      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Lg in cyan circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Lg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Sg in red circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! S-P in red circles
      ! The S-P time is added to the direct P travel time for that distance.
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'S-P     ') then
            if (.not.locmod) then
               call trtm (delt(iev,ird), max, nphase, tt, dtdd, dtdh, dddp, phcd)
            else
               if (verbose_log) write (io_log,'(a)') 'Calling tt_mixed_model from gmt_tt3'
               call tt_mixed_model (hp, delt(iev,ird), nphase, tt, dtdd, dtdh, dddp, phcd)
!               if (delt(iev,ird) .le. dlimlocmod .and. hp .le. zlimlocmod) then
!                  call ttloc2 (hp, delt(iev,ird), 'D', nphase, tt, dtdd, dtdh, dddp, phcd, ierr, 30000)
!               else
!                  call trtm (delt(iev,ird), max, nphase, tt, dtdd, dtdh, dddp, phcd)
!               end if
            end if
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tt(1) + tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine tt_local_regional
      

!*****************************************************************************************
      subroutine tt_local (it, evt_tt5e, sta_tt5s, psfile, gmt_script)
      
      ! Creates a GMT script to plot travel times at local distances (Delta < 4.0 degrees).
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      
      implicit none
      
      include 'mloc.inc'
      
      integer max
      parameter (max=60)
      real tt(max), dtdd(max), dtdh(max), dddp(max)
      integer nphase
      character*8 phcd(max)
      
      integer iev, ird, it, it1, min_index
      real size, vred, ttred, dincrement, hp, hmin, hmax, usrc(2), delt_plot, tt_label,&
       delta_label, depth_test
      character*4 shell
      logical pass, single_station, single_event
      character(len=180) :: command_line
      character(len=132) :: msg, gmt_script, psfile, plot_title, gmt_script_path
      character(len=5) :: sta_tt5s
      character(len=30) :: evt_tt5e
      
      dincrement = 0.1
      if (it .eq. 0) then
         it1 = 0
      else
         it1 = it + 1
      end if
      vred = 0.
      delta_label = 3.6
      
      single_station = (sta_tt5s .ne. '      ')
      if (verbose_screen .and. single_station) then
         write (msg,'(2a)') 'tt_local: single station plot for ', sta_tt5s
         call fyi (trim(msg))
      end if
      
      single_event = (evt_tt5e .ne. '                              ')
      if (verbose_screen .and. single_event) then
         write (msg,'(2a)') 'tt_local: single event plot for ', evt_tt5e
         call fyi (trim(msg))
      end if
      
      if (single_event .and. single_station) then
         write (msg,'(5a)') 'tt_local: Single event (', trim(evt_tt5e), ') and single station (',&
          trim(sta_tt5s), ') not allowed at the same time'
         call oops (trim(msg))
      end if
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      if (single_station) then
         gmt_script = trim(basename)//'_tt5s_local_'//trim(sta_tt5s)//'.'//trim(shell)
      else if (single_event) then
         gmt_script = trim(basename)//'_tt5e_local_'//trim(evt_tt5e)//'.'//trim(shell)
      else
         gmt_script = trim(basename)//'_tt5_local.'//trim(shell)
         call fyi ('tt_local: tt5 plot')
      end if
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt5_local_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
    
      ! Basemap and associated variables
      if (single_station) then
         psfile = trim(basename)//'_tt5s_local_'//trim(sta_tt5s)//'.ps'
      else if (single_event) then
         psfile = trim(basename)//'_tt5e_local_'//trim(evt_tt5e)//'.ps'
      else
         psfile = trim(basename)//'_tt5_local.ps'
      end if
      plot_title = "'Local Distance "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            write (io_gmt,'(a)') 'region=-R0/4.0/0/120'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX18/12'
            write (io_gmt,'(a)') 'set region = -R0/4.0/0/120'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            write (io_gmt,'(a)') 'region=-R0/4.0/0/120'
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
            '-Bya50f10+l'//"'Travel Time (s)'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! For single-event plot, event name
      if (single_event) then
         write (io_gmt,'(a)') '# Event name'
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
         write (io_gmt,'(2f10.3,1x,a)') 110., 0.2, 'Single event: '//evt_tt5e
         write (io_gmt,'(a)') 'END'
      end if

      ! For single-station plot, station code
      if (single_station) then
         write (io_gmt,'(a)') '# Station code'
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
         write (io_gmt,'(2f10.3,1x,a)') 110., 0.2, 'Single station: '//sta_tt5s
         write (io_gmt,'(a)') 'END'
      end if
      
      ! Distance cutoff for use in the hypocentroid during direct calibration 
      If (direct_cal) then
         if (hlim(1,2) .gt. 4.0) then
            call warnings ('tt_local: Distance limit for hypocentroid is outside the plot limit')
         else
            write (io_gmt,'(a)') '# Distance limit for hypocentroid'
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black,- -O -K << END >> $psfile'
            write (io_gmt,'(a,3x,f6.3)') ' 0.000', hlim(1,2)
            write (io_gmt,'(a,3x,f6.3)') '90.000', hlim(1,2)
            write (io_gmt,'(a)') 'END'
         end if
      end if
      
      ! Travel time curves
      ! Solid lines are drawn for each phase at the depth of the hypocentroid, or at the event depth for a single event plot.
      ! Dashed lines are drawn for each phase at the minimum and maximum event depths in the cluster
      
      if (single_event) then
         hp = 0.
         do iev = 1,nev
            if (evtnam(iev) .eq. evt_tt5e) then
               hp = depthp(iev,it1)
               exit
            end if
         end do
      else
         hp = depthh(it1)
      end if
      call depset (hp, usrc)
      depth_test = hp
             
      ! Pn in green
      write (io_gmt,'(a)') '# Pn TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('Pn      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Pn label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Pn      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 2.) write (io_gmt,'(2f10.3,1x,a)') tt_label-2., delta_label, 'Pn'
      write (io_gmt,'(a)') 'END'
      
      ! Pb in blue
      write (io_gmt,'(a)') '# Pb TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O -Ve << END >> $psfile'      
      call ttdat ('Pb      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! Pg in red
      write (io_gmt,'(a)') '# Pg TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('Pg      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Pg label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Pg      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 1.) write (io_gmt,'(2f10.3,1x,a)') tt_label-1., delta_label, 'Pg'
      write (io_gmt,'(a)') 'END'
      
      ! P_ in cyan
      write (io_gmt,'(a)') '# P_ TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,cyan -K -O << END >> $psfile' 
      min_index = nint(p__min/dincrement) ! Only plot the TT curve from the minimum distance at which it is defined    
      if (min_index .le. 40) call ttdat ('P_      ', min_index, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# P_ label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBR -K -O << END >> $psfile'
      call ttdat2 ('P_      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 0.) write (io_gmt,'(2f10.3,1x,a)') tt_label+2., delta_label, 'P_'
      write (io_gmt,'(a)') 'END'
      
      ! Sn in green
      write (io_gmt,'(a)') '# Sn TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
      call ttdat ('Sn      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sn label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Sn      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 2.) write (io_gmt,'(2f10.3,1x,a)') tt_label-2., delta_label, 'Sn'
      write (io_gmt,'(a)') 'END'
      
      ! Sb in blue
      write (io_gmt,'(a)') '# Sb TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O -Ve << END >> $psfile'      
      call ttdat ('Sb      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      
      ! Sg in red
      write (io_gmt,'(a)') '# Sg TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      call ttdat ('Sg      ', 1, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sg label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Sg      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 1.) write (io_gmt,'(2f10.3,1x,a)') tt_label-1., delta_label, 'Sg'
      write (io_gmt,'(a)') 'END'
         
      ! Lg in cyan
      write (io_gmt,'(a)') '# Lg TT curve at hypocentroid depth'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,cyan -K -O << END >> $psfile'      
      min_index = nint(lg_min/dincrement) ! Only plot the TT curve from the minimum distance at which it is defined    
      if (min_index .le. 40) call ttdat ('Lg      ', min_index, 40, dincrement, 0., hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Lg label'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBR -K -O << END >> $psfile'
      call ttdat2 ('Lg      ', delta_label, vred, hp, tt_label)
      if (tt_label .gt. 0.) write (io_gmt,'(2f10.3,1x,a)') tt_label+2., delta_label, 'Lg'
      write (io_gmt,'(a)') 'END'
         
      if (.not. single_event) then
         hmin = 999.
         do iev = 1,nev
            hmin = min1(hmin,depthp(iev,it1))
         end do
         call depset (hmin, usrc)
      
         ! Pn in green
         write (io_gmt,'(a)') '# Pn TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green,- -K -O << END >> $psfile'      
         call ttdat ('Pn      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'
      
         ! Pb in blue
         write (io_gmt,'(a)') '# Pb TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,blue,- -K -O -Ve << END >> $psfile'      
         call ttdat ('Pb      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'
      
         ! Pg in red
         write (io_gmt,'(a)') '# Pg TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red,- -K -O << END >> $psfile'      
         call ttdat ('Pg      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'
      
         ! Sn in green
         write (io_gmt,'(a)') '# Sn TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green,- -K -O << END >> $psfile'      
         call ttdat ('Sn      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'

         ! Sb in blue
         write (io_gmt,'(a)') '# Sb TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,blue,- -K -O -Ve << END >> $psfile'      
         call ttdat ('Sb      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'
      
         ! Sg in red
         write (io_gmt,'(a)') '# Sg TT curve at minimum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red,- -K -O << END >> $psfile'      
         call ttdat ('Sg      ', 1, 40, dincrement, 0., hmin)
         write (io_gmt,'(a)') 'END'
         call depset (hp, usrc)
      
         hmax = -999.
         do iev = 1,nev
            hmax = max1(hmax,depthp(iev,it1))
         end do
         call depset (hmax, usrc)

         ! Pn in green
         write (io_gmt,'(a)') '# Pn TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green,- -K -O << END >> $psfile'      
         call ttdat ('Pn      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'
      
         ! Pb in blue
         write (io_gmt,'(a)') '# Pb TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,blue,- -K -O -Ve << END >> $psfile'      
         call ttdat ('Pb      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'
      
         ! Pg in red
         write (io_gmt,'(a)') '# Pg TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red,- -K -O << END >> $psfile'      
         call ttdat ('Pg      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'
      
         ! Sn in green
         write (io_gmt,'(a)') '# Sn TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green,- -K -O << END >> $psfile'      
         call ttdat ('Sn      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'

         ! Sb in blue
         write (io_gmt,'(a)') '# Sb TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,blue,- -K -O -Ve << END >> $psfile'      
         call ttdat ('Sb      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'
      
         ! Sg in red
         write (io_gmt,'(a)') '# Sg TT curve at maximum depth'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red,- -K -O << END >> $psfile'      
         call ttdat ('Sg      ', 1, 40, dincrement, 0., hmax)
         write (io_gmt,'(a)') 'END'
         
      end if
      
      ! Phase readings
      
      size = 0.2 ! symbol size in cm
            
      ! Anything else in orange diamonds
      write (io_gmt,'(a)') '# Phases other than the standard crustal phases'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sd -Wthin,orange -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (phase(iev,ird) .ne. 'Pn      ' .and.&
                phase(iev,ird) .ne. 'Pb      ' .and.&
                phase(iev,ird) .ne. 'Pg      ' .and.&
                phase(iev,ird) .ne. 'P_      ' .and.&
                phase(iev,ird) .ne. 'Sn      ' .and.&
                phase(iev,ird) .ne. 'Sb      ' .and.&
                phase(iev,ird) .ne. 'Sg      ' .and.&
                phase(iev,ird) .ne. 'Lg      ' .and.&
                phase(iev,ird) .ne. 'S-P     ' .and.&
                delt(iev,ird) .le. 4.0) then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               if (pass(fcode(iev,ird))) write (io_gmt,'(3f10.3)') ttred, delt_plot, 0.15
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
            
      ! Pn in green crosses
      write (io_gmt,'(a)') '# Pn arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pn      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Pb in blue crosses
      write (io_gmt,'(a)') '# Pb arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pb      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! P_ in cyan crosses
      write (io_gmt,'(a)') '# P_ arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'P_      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Pg in red crosses
      write (io_gmt,'(a)') '# Pg arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

       ! Sn in green circles
      write (io_gmt,'(a)') '# Sn arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sn      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Sb in blue circles
      write (io_gmt,'(a)') '# Sb arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sb      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'

      ! Sg in red circles
      write (io_gmt,'(a)') '# Sg arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Lg in cyan circles
      write (io_gmt,'(a)') '# Lg arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Lg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Sg in red circles
      write (io_gmt,'(a)') '# Sg arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -K -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! S-P in larger red circles
      ! The S-P time is added to the direct P travel time for that distance.
      size = size + 0.1
      write (io_gmt,'(a)') '# S-P arrivals'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -O << END >> $psfile'
      do iev = 1,nev
         if (single_event .and. evtnam(iev) .ne. evt_tt5e) cycle
         do ird = 1,nst(iev)
            if (single_station .and. stname(iev,ird) .ne. sta_tt5s) cycle
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'S-P     ') then
            if (.not.locmod) then
               call trtm (delt(iev,ird), max, nphase, tt, dtdd, dtdh, dddp, phcd)
            else
               if (verbose_log) write (io_log,'(a)') 'Calling tt_mixed_model from tt_local'
               call tt_mixed_model (hp, delt(iev,ird), nphase, tt, dtdd, dtdh, dddp, phcd)
!               if (delt(iev,ird) .le. dlimlocmod .and. hp .le. zlimlocmod) then
!                  call ttloc2 (hp, delt(iev,ird), 'D', nphase, tt, dtdd, dtdh, dddp, phcd, ierr, 30000)
!               else
!                  call trtm (delt(iev,ird), max, nphase, tt, dtdd, dtdh, dddp, phcd)
!               end if
            end if
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tt(1) + tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the script into the script directory
      if (.not.single_event .and. .not.single_station) then
         command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
         call system (trim(command_line))
      end if
      
      return
      end subroutine tt_local


!*****************************************************************************************
subroutine single_event_tt5 (it)
      
   ! Creates a GMT script to plot travel times at local distances (Delta < 4.0 degrees)
   ! for a single event (see subroutine tt_local). The plot files are stored in
   ! a subdirectory with suffix '_tt5e' created for the plots. The GMT scripts are deleted
   ! after creating the postscript files.
      
   implicit none
   
   include 'mloc.inc'

   integer :: i, it, lps, iev, ird
   logical :: pass, tt5e_plot
   character(len=132) :: plot_folder, psfile, gmt_script, pdf_file, gmt_script_path
   character(len=180) :: command_line
   character(len=5) :: blank5
   character(len=132) :: msg
      
   data blank5/'     '/
      
   call fyi ('tt_single_event_tt5: single event tt5 plots')

   ! Create the subdirectory for tt5e plots
   plot_folder = trim(datadir)//dirsym//trim(basename)//'_tt5e'
   command_line = 'mkdir '//trim(plot_folder)
   call system (trim(command_line))
   
   ! Loop over plots
   do iev = 1,nev
   
      ! Check if this event is in the list of requested plots
      tt5e_plot = .false.
      do i = 1,n_tt5e
         if (evtnam(iev) .eq. tt5e_evt(i)) then
            tt5e_plot = .true.
            exit
         end if
      end do
      if (.not.tt5e_plot) cycle

      ! Determine if there are local-distance data to be plotted for this event
      tt5e_plot = .false.
      do ird = 1,nst(iev)
         if (delt(iev,ird) .lt. 4.0 .and. pass(fcode(iev,ird))) then
            tt5e_plot = .true.
            exit
         end if
      end do
      if (tt5e_plot) then
         write (msg,'(a,i3)') 'tt5e_single: event ', iev
         call fyi (trim(msg))     
      else
         if (verbose_screen) then
            write (msg,'(a,i3,1x,a)') 'tt5e_single: local distance data found for event ', iev, evtnam(iev)
            call fyi (trim(msg))
         end if
         cycle
      end if      
   
      call tt_local (it, tt5e_evt(iev), blank5, psfile, gmt_script)
      lps = len_trim(psfile)
      pdf_file = psfile(1:lps-2)//'pdf'
      ! Move PDF files into the plot folder
      command_line = 'mv '//trim(datadir)//dirsym//trim(pdf_file)//' '//trim(plot_folder)//dirsym//trim(pdf_file)
      call system (trim(command_line))
      ! Move the scripts into the script directory
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
   end do
   
   return
   
end subroutine single_event_tt5


!*****************************************************************************************
subroutine single_station_tt5 (it)
      
   ! Creates a GMT script to plot travel times at local distances (Delta < 4.0 degrees)
   ! for a single station (see subroutine tt_local). The plot files are stored in
   ! a subdirectory with suffix '_tt5s' created for the plots. The GMT scripts are deleted
   ! after creating the postscript files.
      
   implicit none
   
   include 'mloc.inc'

   integer :: i, it, lps
   character(len=132) :: plot_folder, psfile, gmt_script, pdf_file, gmt_script_path
   character(len=180) :: command_line
   character(len=30) :: blank30
   
   data blank30 /'                              '/
      
   call fyi ('tt_single_station_tt5: single station tt5 plots')

   ! Create the subdirectory for tt5s plots
   plot_folder = trim(datadir)//dirsym//trim(basename)//'_tt5s'
   command_line = 'mkdir '//trim(plot_folder)
   call system (trim(command_line))
   
   ! Loop over plots
   do i = 1,n_tt5s
      call tt_local (it, blank30, tt5s_sta(i), psfile, gmt_script)
      lps = len_trim(psfile)
      pdf_file = psfile(1:lps-2)//'pdf'
      ! Move PDF files into the plot folder
      command_line = 'mv '//trim(datadir)//dirsym//trim(pdf_file)//' '//trim(plot_folder)//dirsym//trim(pdf_file)
      call system (trim(command_line))
      ! Move the scripts into the script directory
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
   end do
   
   return
   
end subroutine single_station_tt5


!*****************************************************************************************
      subroutine tt_local_regional_s (it)
      
      ! Creates a GMT script to plot crustal S, Sn, and Lg travel times at local and regional distances.
      ! This plot can be done reduced.
      ! For indirect calibration, the shifted travel time and epicentral distances are used.
      
      implicit none
      
      include 'mloc.inc'
      
      integer iev, ird, it, it1, i1
      real size, vred, ttred, dincrement, hp, usrc(2), delt_plot, delta_label, tt_label
      character(len=180) :: command_line
      character*100 gmt_script, psfile, plot_title, gmt_script_path
      character*4 shell
      logical pass
      character(len=132) :: msg
      
      call fyi ('tt_local_regional_s: tt7 plot')

      dincrement = 0.5
      it1 = it + 1
            
      if (reduced) then
         vred = 31.7 ! inverse reduction velocity, in seconds per degree (Lg)
      else
         vred = 0.
      end if
      
      select case (ishell)
         case (1)
            shell = 'bash'
         case (2)
            shell = 'csh '
         case (3)
            shell = 'zsh '
      end select
      gmt_script = trim(basename)//'_tt7_local_regional_s.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'tt7_local_regional_s_5: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
      
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      
      ! Set some GMT parameters (shell-independent)
      
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
    
      ! Basemap and associated variables
      psfile = trim(basename)//'_tt7_local_regional_s.ps'
      plot_title = "'Local-Regional Shear Phases "//trim(basename)//"'"
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'region=-R0/15/-120/30'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            else
               write (io_gmt,'(a)') 'region=-R0/15/0/500'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya100f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            end if
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'set region = -R0/15/-120/30'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
            else
               write (io_gmt,'(a)') 'set region = -R0/15/0/500'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya100f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
            end if
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            if (reduced) then
               write (io_gmt,'(a)') 'region=-R0/15/-120/30'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya50f10+l'//"'Reduced Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            else
               write (io_gmt,'(a)') 'region=-R0/15/0/500'
               write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
               '-Bxa5f1+l'//"'Epicentral Distance (deg)'"//' ',&
               '-Bya100f10+l'//"'Travel Time (s)'"//' ',&
               '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
            end if
      end select
      
      ! Reduction velocity
      if (reduced) then
         write (io_gmt,'(a)') '# Reduction velocity'
         write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
         write (msg,'(a,f5.2,a)') 'Inverse reduction velocity: ', vred, ' sec/deg'
         write (io_gmt,'(2f10.3,1x,a)') -115., 1.0, trim(msg)
         write (io_gmt,'(a)') 'END'
      end if

      ! Theoretical TT curves, using hypocentroid depth
      hp = depthh(it1)
      call depset (hp, usrc)
      
      ! Rg in black
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'
      i1 = nint(rg_min/dincrement)
      call ttdat ('Rg      ', i1, 10, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Rg label'
      delta_label = 3.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jBR -K -O << END >> $psfile'
      call ttdat2 ('Rg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label+3., delta_label, 'Rg'
      write (io_gmt,'(a)') 'END'
      
      ! Lg in cyan
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,cyan -K -O << END >> $psfile'
      i1 = nint(lg_min/dincrement)
      call ttdat ('Lg      ', i1, 30, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Lg label'
      delta_label = 13.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,cyan+a0.+jBL -K -O << END >> $psfile'
      call ttdat2 ('Lg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label+3., delta_label, 'Lg'
      write (io_gmt,'(a)') 'END'
      
      ! Sn in green
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'
      call ttdat ('Sn      ', 1, 30, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sn label'
      delta_label = 13.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jBL -K -O << END >> $psfile'
      call ttdat2 ('Sn      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label+3., delta_label, 'Sn'
      write (io_gmt,'(a)') 'END'
      
      ! Sb in blue
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O -Ve << END >> $psfile'
      call ttdat ('Sb      ', 1, 8, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      
      ! Sg in red
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'
      call ttdat ('Sg      ', 1, 8, dincrement, vred, hp)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') '# Sg label'
      delta_label = 4.
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jTL -K -O << END >> $psfile'
      call ttdat2 ('Sg      ', delta_label, vred, hp, tt_label)
      write (io_gmt,'(2f10.3,1x,a)') tt_label-3., delta_label, 'Sg'
      write (io_gmt,'(a)') 'END'
      
      size = 0.2 ! symbol size in cm
      
      ! Lg in cyan circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,cyan -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Lg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Sn in green circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,green -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sn      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Sb in blue circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,blue -K -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sb      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Sg in red circles
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -O << END >> $psfile'
      do iev = 1,nev
         do ird = 1,nst(iev)
            if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sg      ') then
               if (calibration) then
                  delt_plot = delt_cal(iev,ird)
               else
                  delt_plot = delt(iev,ird)
               end if
               ttred = tto(iev,ird) - vred*delt_plot
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      
      ! Move the script into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
      return
      end subroutine tt_local_regional_s
      

!*****************************************************************************************
subroutine rdp_single (it)
   
! Creates a GMT script to make a plot of the focal depth analysis, using
! relative depth phases, for a single event. The analysis is done
! elsewhere. Two measures of misfit are plotted, the raw RMS and the zM
! statistic. The boundaries of each plot are adjusted according to the
! depth range around the depth of minimum residual.

   implicit none
   
   include 'mloc.inc'

   integer :: h, iev, ird, it, it1
   real :: fdp, fdm

   integer :: i, j, lps, max_depth_plot, min_depth_plot, max_rms_plot, idep
   real :: current_depth, ref_rms
   logical :: pass, rdp_plot
   character(len=4) :: shell
   character(len=3) :: iev_pr
   character(len=12) :: region, region_base
   character(len=132) :: msg, gmt_script, psfile, plot_folder, plot_title, pdf_file, gmt_script_path
   character(len=180) :: command_line
     
   call fyi ('rdp_single: relative depth phase plots for single events')

   it1 = it + 1

   ! Make a folder for the plots
   plot_folder = trim(datadir)//dirsym//trim(basename)//'_rdp'
   command_line = 'mkdir '//trim(plot_folder)
   call system (trim(command_line))
               
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
       
   ! Loop over events
   do iev = 1,nev
   
      ! Check if this event is in the list of requested plots
      rdp_plot = .false.
      do i = 1,n_rdpp
         if (evtnam(iev) .eq. rdpp_evt(i)) then
            rdp_plot = .true.
            exit
         end if
      end do
      if (.not.rdp_plot) cycle
   
      ! Determine if there are relative depth phases data to be plotted for this event
      rdp_plot = .false.
      do ird = 1,nst(iev)
         if (rel_depth_phase(iev,ird) .and. pass(fcode(iev,ird))) then
            rdp_plot = .true.
            exit
         end if
      end do
      if (rdp_plot) then
         write (msg,'(a,i3)') 'rdp_single: event ', iev
         call fyi (trim(msg))     
      else
         if (verbose_screen) then
            write (msg,'(a,i3,1x,a)') 'rdp_single: no relative depth phase data found for event ', iev, evtnam(iev)
            call fyi (trim(msg))
         end if
         cycle
      end if
      
      write (iev_pr,'(i3.3)') iev
      gmt_script = trim(basename)//'_rdp_'//iev_pr//'.'//trim(shell)
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      if (verbose_screen) then
         write (msg,'(3a,i3)') 'rdp_single: opening ', trim(gmt_script_path), ' on unit ', io_gmt
         call fyi (trim(msg))
      end if
      open (io_gmt,file=gmt_script_path,status='new')
   
      ! Begin the GMT script      
      psfile = trim(basename)//'_rdp_'//iev_pr//'.ps' 
      write (io_gmt,'(a)') '#!/bin/'//trim(shell)
      write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
      write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
      write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 

      ! Basemap and associated variables
      plot_title = "'Relative Depth Phases "//trim(basename)//' Event '//iev_pr//"'"
      max_depth_plot = h_rdp(iev,3) + 20
      min_depth_plot = max(h_rdp(iev,1)-20,1)
      max_rms_plot = int(z_test(iev) + 10.)
      write (region_base,'(i3,a1,i3,a3,i2)') min_depth_plot, '/', max_depth_plot, '/0/', max_rms_plot
      ! Text string for the region boundaries
      j = 0
      region = ' '
      do i = 1,12
         if (region_base(i:i) .ne. ' ') then
            j = j + 1
            region(j:j) = region_base(i:i)
         end if
      end do
      select case (ishell)
         case (1)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            write (io_gmt,'(a,i2,a,i2,a,i2)') 'region=-R'//trim(region)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5f1+l'//"'Focal Depth (km)'"//' ',&
            '-Bya5f1+l'//"'RMS Misfit'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
         case (2)
            write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
            write (io_gmt,'(a)') 'set projection = -JX18/12'
            write (io_gmt,'(a,i2,a,i2,a,i2)') 'set region = -R'//trim(region)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5f1+l'//"'Focal Depth (km)'"//' ',&
            '-Bya5f1+l'//"'RMS Misfit'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
         case (3)
            write (io_gmt,'(2a)') 'psfile=', trim(psfile)
            write (io_gmt,'(a)') 'projection=-JX18/12'
            write (io_gmt,'(a,i2,a,i2,a,i2)') 'region=-R'//trim(region)
            write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
            '-Bxa5f1+l'//"'Focal Depth (km)'"//' ',&
            '-Bya5f1+l'//"'RMS Misfit'"//' ',&
            '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      end select
      
      ! RMS error curve, in black
      if (calibration) then
         current_depth = depthp_cal(iev)
      else
         current_depth = depthp(iev,it+1)
      end if
      idep = nint(current_depth)
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
      do h = min_depth_plot,max_depth_plot
         write (io_gmt,'(2f10.3)') hrmsi(iev,h), real(h)
      end do
      write (io_gmt,'(a)') 'END'
      
      ! z-values (used to estimate uncertainty in depth, in red
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red -K -O << END >> $psfile'      
      do h = min_depth_plot,max_depth_plot
         write (io_gmt,'(2f10.3)') z_hrdp(iev,h), real(h)
      end do
      write (io_gmt,'(a)') 'END'
      
      ! Mark current focal depth and uncertainty range, in blue
      ref_rms = z_test(iev) + 2.0
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,blue+a0.+jBC -K -O << END >> $psfile'
      write (io_gmt,'(2f10.3,1x,a)') ref_rms+0.1, current_depth, 'Current Depth'
      write (io_gmt,'(a)') 'END'         
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthicker,blue -K -O << END >> $psfile'      
      write (io_gmt,'(2f10.3)') z_test(iev), current_depth
      write (io_gmt,'(2f10.3)') ref_rms, current_depth
      write (io_gmt,'(a)') 'END'
      if (mindx(iev,3) .gt. 0) then ! Free depth solution
         if (direct_cal) then
            fdp = ddepdc(iev)
         else
            fdp = sdxhatc(iev,3)
         end if
         fdm = fdp
      else
         fdp = depthp_plus(iev)
         fdm = depthp_minus(iev)
      end if
      if (depset_pr(iev) .ne. 'c') then ! No uncertainty range for default depths
         if (fdp .gt. 0) then
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O << END >> $psfile'      
            write (io_gmt,'(2f10.3)') ref_rms, current_depth
            if ((current_depth + fdp) .le. real(max_depth_plot)) then
               write (io_gmt,'(2f10.3)') ref_rms, current_depth + fdp
               write (io_gmt,'(2f10.3)') z_test(iev), current_depth + fdp
            else
               write (io_gmt,'(2f10.3)') ref_rms, real(max_depth_plot)
            end if
            write (io_gmt,'(a)') 'END'
         end if
         if (fdm .gt. 0) then
            write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,blue -K -O << END >> $psfile'      
            write (io_gmt,'(2f10.3)') ref_rms, current_depth
            if ((current_depth - fdm) .ge. real(min_depth_plot)) then
               write (io_gmt,'(2f10.3)') ref_rms, current_depth - fdm
               write (io_gmt,'(2f10.3)') z_test(iev), current_depth - fdm
            else
               write (io_gmt,'(2f10.3)') ref_rms, real(min_depth_plot)
            end if
            write (io_gmt,'(a)') 'END'
         end if
      end if
      
      ! Preferred depth uncertainty range (in red)
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthicker,red -K -O << END >> $psfile'      
      write (io_gmt,'(2f10.3)') 0., real(h_rdp(iev,2))
      write (io_gmt,'(2f10.3)') z_test(iev), real(h_rdp(iev,2))
      write (io_gmt,'(a)') 'END'
      ! Critical value of z-statistic
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      write (io_gmt,'(2f10.3)') z_test(iev), real(h_rdp(iev,1))
      write (io_gmt,'(2f10.3)') z_test(iev), real(h_rdp(iev,3))
      write (io_gmt,'(a)') 'END'
      ! Shallow limit
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      write (io_gmt,'(2f10.3)') 0., real(h_rdp(iev,1))
      write (io_gmt,'(2f10.3)') z_test(iev), real(h_rdp(iev,1))
      write (io_gmt,'(a)') 'END'
      ! Deep limit
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'      
      write (io_gmt,'(2f10.3)') 0., real(h_rdp(iev,3))
      write (io_gmt,'(2f10.3)') z_test(iev), real(h_rdp(iev,3))
      write (io_gmt,'(a)') 'END'
      
      ! Event name and depth of minimum misfit printed
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
      write (msg,'(a)') 'Event '//evtnam(iev)
      write (io_gmt,'(2f10.3,1x,a)') real(max_rms_plot)*0.94, real(min_depth_plot+1), trim(msg)
      write (msg,'(a,i3,a,i3,a)') 'Depth of minimum misfit = ', h_rdp(iev,2), ' km on', n_samples(iev), ' samples'
      write (io_gmt,'(2f10.3,1x,a)') real(max_rms_plot)*0.88, real(min_depth_plot+1), trim(msg)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,black+a0.+jBL -K -O << END >> $psfile'
      write (msg,'(a)') 'RMS error in black'
      write (io_gmt,'(2f10.3,1x,a)') real(max_rms_plot)*0.80, real(min_depth_plot+1), trim(msg)
      write (io_gmt,'(a)') 'END'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,red+a0.+jBL -O << END >> $psfile'
      write (msg,'(a)') 'z statistic for depth uncertainty range in red'
      write (io_gmt,'(2f10.3,1x,a)') real(max_rms_plot)*0.76, real(min_depth_plot+1), trim(msg)
      write (io_gmt,'(a)') 'END'
                  
      close (io_gmt)
      
      call run_gmt_script (gmt_script_path, psfile)
      lps = len_trim(psfile)
      pdf_file = psfile(1:lps-2)//'pdf'
   
      ! Move PDF files into the plot folder
      command_line = 'mv '//trim(datadir)//dirsym//trim(pdf_file)//' '//trim(plot_folder)//dirsym//trim(pdf_file)
      call system (trim(command_line))
      ! Move the scripts into the script directory
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
      
   end do
   
   return
   
end subroutine rdp_single


!*****************************************************************************************
subroutine tt_rdp_summary (it)

! Creates a GMT script for a plot of relative depth phase data for the entire cluster

   implicit none
   
   include 'mloc.inc'

   integer, parameter :: delt_min = 25 ! minimum epicentral distance to plot
   integer, parameter :: delt_max = 102 ! maximum epicentral distance to plot

   integer, parameter :: max = 60
   real :: tt(max), dtdd(max), dtdh(max), dddp(max)
   integer :: nphase
   character(len=8) :: phcd(max)
   
   integer :: i, j, k, ird, iev, it, it1, rdp_min, rdp_max, kmin, kmax
   real :: ttred, usrc(2), tt_p, size, ed, fd, delt_plot, depth_min, depth_max, tt_pp, tt_sp
   logical :: pass, bdp
   character(len=3) :: depth_label
   character(len=4) :: shell
   character(len=16) :: region, region_base
   character(len=100) :: gmt_script, psfile, plot_title, gmt_script_path
   character(len=132) :: msg
   character(len=180) :: command_line
   
   it1 = it + 1
   
   call fyi ('tt_rdp_summary: relative depth phase summary plot')
   
   ! Deepest event in the cluster
   depth_min = 999.
   depth_max = -999.
   do iev = 1,nev
      if (depthp(iev,it1) .lt. depth_min) depth_min = depthp(iev,it1)
      if (depthp(iev,it1) .gt. depth_max) depth_max = depthp(iev,it1)
   end do
   if (depth_min .lt. 5.) depth_min = 5. ! Depth phases for depth less than 5 km are not of interest in this plot
   if (verbose_log) write (io_log,'(a,f5.1,a,f5.1,a)') 'tt_rdp_summary: depth range = ', depth_min, ' to ', depth_max, ' km'
   
   ! Limits for the time axis
   ! Max based on sP-P time for the deepest event at 90° distance
   ! Min based on pP-P time for the shallowest event at 30° distance
   call depset (depth_min, usrc)
   call trtm (30., max, nphase, tt, dtdd, dtdh, dddp, phcd)
   tt_p = tt(1) ! P arrival time
   do j = 1,nphase
      if (phcd(j) .eq. 'pP      ') then
         tt_pp = tt(j)
         exit
      end if
   end do
   rdp_min = nint(tt_pp - tt_p)
   rdp_min = rdp_min - 5
   if (rdp_min .lt. 0) rdp_min = 0
   call depset (depth_max, usrc)
   call trtm (90., max, nphase, tt, dtdd, dtdh, dddp, phcd)
   tt_p = tt(1) ! P arrival time
   do j = 1,nphase
      if (phcd(j) .eq. 'sP      ') then
         tt_sp = tt(j)
         exit
      end if
   end do
   rdp_max = nint(tt_sp - tt_p)
   rdp_max = rdp_max + 5
   if (verbose_log) write (io_log,'(a,i3,a,i3,a)') 'tt_rdp_summary: rdp range = ', rdp_min, ' to ', rdp_max, ' s'
         
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   gmt_script = trim(basename)//'_tt8_rdp_summary.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'tt_rdp_summary: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')
   
   write (io_gmt,'(a)') '#!/bin/'//trim(shell)
   
   ! Set some GMT parameters (shell-independent)
   
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
 
   ! Basemap and associated variables
   if (verbose_screen) call fyi('tt_rdp_summary: Basemap and associated variables')
   psfile = trim(basename)//'_tt8_rdp_summary.ps'
   plot_title = "'Relative Depth Phase Summary "//trim(basename)//"'"
   write (region_base,'(i2,a1,i3,a1,i3,a1,i3)') delt_min, '/', delt_max, '/', rdp_min, '/', rdp_max
   ! Text string for the region boundaries
   j = 0
   region = ' '
   do i = 1,16
      if (region_base(i:i) .ne. ' ') then
         j = j + 1
         region(j:j) = region_base(i:i)
      end if
   end do
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R'//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JX18/12'
         write (io_gmt,'(a)') 'set region = -R'//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R'//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
   end select
   
   ! Theoretical times
   if (verbose_screen) call fyi('tt_rdp_summary: pP-P theoretical times')
   ! pP-P branch in green
   kmin = int(depth_min*1.e-1)*10
   kmin = max0(kmin,10)
   kmax = int(depth_max*1.e-1)*10 + 10
   kmax = max0(kmax,10)
   do k = kmin,kmax,10 ! loop over depth
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'
      do i = delt_min,delt_max-5 ! loop over epicentral distance
         ed = real(i) ! epicentral distance
         fd = real(k) ! focal depth
         call depset (fd, usrc)
         call trtm (ed, max, nphase, tt, dtdd, dtdh, dddp, phcd)
         tt_p = tt(1) ! P arrival time
         do j = 1,nphase
            if (phcd(j) .eq. 'pP      ') then
               ttred = tt(j) - tt_p
               write (io_gmt,'(2f10.3)') ttred, ed
               exit
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      ! Depth curve label
      write (io_gmt,'(a)') '# Labels for pP-P depth curve'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,green+a0.+jML -K -O << END >> $psfile'
      write (depth_label,'(i3)') k
      write (io_gmt,'(2f10.3,1x,a)') ttred, float(delt_max-5), depth_label
      write (io_gmt,'(a)') 'END'
   end do
   
   ! sP-P branch in red
   if (verbose_screen) call fyi('tt_rdp_summary: sP-P theoretical times')
   kmin = int(depth_min*1.e-1)*10
   kmin = max0(kmin,10)
   kmax = int(depth_max*1.e-1)*10 + 10
   kmax = max0(kmax,10)
   do k = kmin,kmax,10 ! loop over depth
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,red -K -O << END >> $psfile'
      do i = delt_min,delt_max-3 ! loop over epicentral distance
         ed = real(i) ! epicentral distance
         fd = real(k) ! focal depth
         call depset (fd, usrc)
         call trtm (ed, max, nphase, tt, dtdd, dtdh, dddp, phcd)
         tt_p = tt(1) ! P arrival time
         do j = 1,nphase
            if (phcd(j) .eq. 'sP      ') then
               ttred = tt(j) - tt_p
               write (io_gmt,'(2f10.3)') ttred, ed
               exit
            end if
         end do
      end do
      write (io_gmt,'(a)') 'END'
      ! Depth curve label
      write (io_gmt,'(a)') '# Labels for sP-P depth curve'
      write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,red+a0.+jML -K -O << END >> $psfile'
      write (depth_label,'(i3)') k
      write (io_gmt,'(2f10.3,1x,a)') ttred, float(delt_max-3), depth_label
      write (io_gmt,'(a)') 'END'
   end do   
   
   ! Observed arrivals
   if (verbose_screen) call fyi('tt_rdp_summary: observed arrival times')
   size = 0.2 ! symbol size in cm
   do iev =1,nev
      do ird = 1,nst(iev)
         if (rel_depth_phase(iev,ird) .and. pass(fcode(iev,ird))) then  
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            if (phase(iev,ird) .eq. 'pP-P    ') then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,green -K -O << END >> $psfile'
            else if (phase(iev,ird) .eq. 'sP-P    ') then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -K -O << END >> $psfile'
            else if (phase(iev,ird) .eq. 'pwP-P   ') then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,blue -K -O << END >> $psfile'
            else
               cycle
            end if
            if (.not.bdp(iev,ird)) then
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
            else
               write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size*0.6
            end if
            write (io_gmt,'(a)') 'END'
         end if
      end do
   end do
   
   ! Legend                
   if (verbose_screen) call fyi('tt_rdp_summary: legend')
   write (io_gmt,'(a)') '# Legend'
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica,green+a0.+jBL -K -O << END >> $psfile'
   write (io_gmt,'(2f10.3,1x,a)') float(rdp_max)*0.94, float(delt_min)+1., 'Green for pP-P'
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica,red+a0.+jBL -O << END >> $psfile'
   write (io_gmt,'(2f10.3,1x,a)') float(rdp_max)*0.88, float(delt_min)+1., 'Red for sP-P'
   write (io_gmt,'(a)') 'END'

   close (io_gmt)

   if (verbose_screen) call fyi('tt_rdp_summary: run script')
   call run_gmt_script (gmt_script_path, psfile)
   
   if (verbose_screen) call fyi('tt_rdp_summary: move the scripts into the script directory')
   ! Move the scripts into the script directory
   command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
   call system (trim(command_line))
      
   return

end subroutine tt_rdp_summary


!*****************************************************************************************
subroutine tt_teleseismic_p (it)

! Creates a GMT script to plot the entire P branch, plus Pdiff and PcP.
! All data are reduced to the theoretical P time.
! For indirect calibration, the shifted travel time and epicentral distances are used.

   implicit none

   include 'mloc.inc'

   integer max
   parameter (max=60)
   real tt(max), dtdd(max), dtdh(max), dddp(max)
   integer nphase
   character*8 phcd(max)

   integer iev, ird, it, it1, i, j
   real size, vred, ttred, dincrement, hp, usrc(2), delt_plot, tt_p, d
   character(len=180) :: command_line
   character*100 gmt_script, psfile, plot_title, gmt_script_path
   character*4 shell
   logical pass
   character(len=132) :: msg

   call fyi ('tt_teleseismic_p: tt2 plot')

   dincrement = 0.5
   it1 = it + 1
      
   vred = 0.
      
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   gmt_script = trim(basename)//'_tt2_teleseismic_p.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'tt_teleseismic_p: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')

   write (io_gmt,'(a)') '#!/bin/'//trim(shell)

   ! Set some GMT parameters (shell-independent)

   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 

   ! Basemap and associated variables
   psfile = trim(basename)//'_tt2_teleseismic_p.ps'
   plot_title = "'Teleseismic P "//trim(basename)//"'"
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R10/120/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JX18/12'
         write (io_gmt,'(a)') 'set region = -R10/120/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R10/120/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa10f5+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya10f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
   end select

   ! Theoretical TT curves, using hypocentroid depth
   hp = depthh(it1)
   call depset (hp, usrc)

   ! PcP branch in green
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,green -K -O << END >> $psfile'      
   do i = 10,120
      d = real(i)
      call trtm (d, max, nphase, tt, dtdd, dtdh, dddp, phcd)
      tt_p = tt(1)
      do j = 1,nphase
         if (phcd(j) .eq. 'PcP     ') then
            ttred = tt(j) - tt_p
            if (abs(ttred) .le. 10.) write (io_gmt,'(2f10.3)') ttred, d
            exit
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   size = 0.2 ! symbol size in cm
            
   ! Observed P in black crosses
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
   do iev = 1,nev
      call depset (depthp(iev,it), usrc)
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'P       ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
            ttred = tto(iev,ird) - tt(1)
            write (io_gmt,'(3f10.3)') ttred, delt_plot, size
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Observed Pdiff in red crosses
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,red -K -O << END >> $psfile'
   do iev = 1,nev
      call depset (depthp(iev,it), usrc)
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pdiff   ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
            ttred = tto(iev,ird) - tt(1)
            write (io_gmt,'(3f10.3)') ttred, delt_plot, size
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Observed PcP in green crosses
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,green -K -O << END >> $psfile'
   do iev = 1,nev
      call depset (depthp(iev,it), usrc)
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'PcP    ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
            ttred = tto(iev,ird) - tt(1)
            write (io_gmt,'(3f10.3)') ttred, delt_plot, size
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'
   
   ! Legend
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,green+a0.+jBL -K -O << END >> $psfile'
   write (io_gmt,'(2f10.3,1x,a)') -8.5, 12., 'PcP in green'
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica-Bold,red+a0.+jBL -O << END >> $psfile'
   write (io_gmt,'(2f10.3,1x,a)') -9.5, 12., 'Pdiff in red'
   write (io_gmt,'(a)') 'END'

   close (io_gmt)

   call run_gmt_script (gmt_script_path, psfile)

   ! Move the scripts into the script directory
   command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
   call system (trim(command_line))
      
   return
   
end subroutine tt_teleseismic_p
      
      
!*****************************************************************************************
subroutine tt_s_minus_p (it)
   
! Creates a GMT script to plot S-P data against epicentral distance.
! S-P travel-time curves are plotted for four depths (5, 10, 15 and 20 km).
   
   implicit none
   
   include 'mloc.inc'
   
   integer iev, ird, it, it1
   real size, dincrement, hp, usrc(2), delt_plot
   character(len=180) :: command_line
   character*100 gmt_script, psfile, plot_title, gmt_script_path
   character*4 shell
   logical pass
   character(len=132) :: msg
   
   call fyi ('tt_s_minus_p: tt9 plot')

   dincrement = 0.1
   it1 = it + 1
   
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   gmt_script = trim(basename)//'_tt9_s_minus_p.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'tt_s_minus_p: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')
   
   write (io_gmt,'(a)') '#!/bin/'//trim(shell)
   
   ! Set some GMT parameters (shell-independent)
   
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
 
   ! Basemap and associated variables
   psfile = trim(basename)//'_tt9_s_minus_p.ps'
   plot_title = "'S-P "//trim(basename)//"'"
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R0/1.0/0/20'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JX18/12'
         write (io_gmt,'(a)') 'set region = -R0/1.0/0/20'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a)') 'region=-R0/1.0/0/20'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Time Difference (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
   end select
      
   ! Travel time curves at 5, 10, 15 and 20 km depth
   
   hp = 5.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 5.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
   
   hp = 10.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 10.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
   
   hp = 15.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 15.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
   
   hp = 20.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 20.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
      
   hp = 25.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 25.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
      
   hp = 30.
   call depset (hp, usrc)
   write (io_gmt,'(a)') '# S-P curve at 30.0 km focal depth'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black -K -O << END >> $psfile'      
   call ttdat ('S-P     ', 1, 10, dincrement, 0., hp)
   write (io_gmt,'(a)') 'END'
      
   ! Phase readings
   
   size = 0.2 ! symbol size in cm
            
   ! S-P in larger red circles
   write (io_gmt,'(a)') '# S-P arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthin,red -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'S-P     ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            write (io_gmt,'(3f10.3)') tto(iev,ird), delt_plot, size
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'
   
   close (io_gmt)
   
   call run_gmt_script (gmt_script_path, psfile)
   
   ! Move the scripts into the script directory
   command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
   call system (trim(command_line))
      
   return
   
end subroutine tt_s_minus_p


!*****************************************************************************************
subroutine tt_near_source (it)

! Time-distance for near-source arrivals. Residuals for direct crustal phases are
! plotted against theoretical times. Average values are calculated from 0. to the distance
! limit for the hypocentroid.

   implicit none
   
   include 'mloc.inc'
   
   integer iev, ird, it, n_pg, n_pb, n_pn, n_sg, n_sb, n_sn
   real size, tt_res, delt_plot, delt_average, delt_limit
   real sum_pg, sum_pb, sum_pn, sum_sg, sum_sb, sum_sn
   real average_pg, average_pb, average_pn, average_sg, average_sb, average_sn
   character(len=180) :: command_line
   character*100 gmt_script, psfile, plot_title, gmt_script_path
   character*4 shell
   logical pass
   character(len=132) :: msg
   
   call fyi ('tt_near_source: tt4 plot')

   delt_average = hlim(1,2) ! Distance limit for averaging residuals
   delt_limit = max(1.0, hlim(1,2)) ! Plot width
   delt_limit = min(delt_limit,3.0) ! To prevent errors when teleseimic limits are used for the hypocentroid
      
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   gmt_script = trim(basename)//'_tt4_near_source.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'tt_near_source: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')
   
   write (io_gmt,'(a)') '#!/bin/'//trim(shell)
   
   ! Set some GMT parameters (shell-independent)
   
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
 
   ! Basemap and associated variables
   psfile = trim(basename)//'_tt4_near_source.ps'
   plot_title = "'Near-Source "//trim(basename)//"'"
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a,f3.1,a)') 'region=-R0/',delt_limit,'/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa0.1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JX18/12'
         write (io_gmt,'(a,f3.1,a)') 'set region = -R0/',delt_limit,'/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa0.1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX18/12'
         write (io_gmt,'(a,f3.1,a)') 'region=-R0/',delt_limit,'/-10/10'
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bxa0.1f0.1+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1g5+l'//"'Travel Time Residual (s)'"//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
   end select
         
   ! Distance cutoff for use in the hypocentroid during direct calibration 
   If (direct_cal) then
      if (hlim(1,2) .gt. delt_limit) then
         call warnings ('tt_local: Distance limit for hypocentroid is outside the plot limit')
      else
         write (io_gmt,'(a)') '# Distance limit for hypocentroid'
         write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthick,black,- -O -K << END >> $psfile'
         write (io_gmt,'(a,3x,f6.3)') '-10.000', hlim(1,2)
         write (io_gmt,'(a,3x,f6.3)') '10.000', hlim(1,2)
         write (io_gmt,'(a)') 'END'
      end if
   end if
      
   ! Phase readings
   
   size = 0.2 ! symbol size in cm
   n_pg = 0
   n_pb = 0
   n_pn = 0
   n_sg = 0
   n_sb = 0
   n_sn = 0
   sum_pg = 0.
   sum_pb = 0.
   sum_pn = 0.
   sum_sg = 0.
   sum_sb = 0.
   sum_sn = 0.
    
   ! Pg in red crosses
   write (io_gmt,'(a)') '# Pg arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthick,red -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pg      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_pg = n_pg + 1
               sum_pg = sum_pg + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Pb in blue crosses
   write (io_gmt,'(a)') '# Pb arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthick,blue -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pb      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections 
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_pb = n_pb + 1
               sum_pb = sum_pb + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Pn in green crosses
   ! Pn is a direct phase at close range for events below the Moho
   write (io_gmt,'(a)') '# Pn arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthick,green -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Pn      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_pn = n_pn + 1
               sum_pn = sum_pn + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Sg in red circles
   write (io_gmt,'(a)') '# Sg arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,red -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sg      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections 
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_sg = n_sg + 1
               sum_sg = sum_sg + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'
   
   ! Sb in blue circles
   write (io_gmt,'(a)') '# Sb arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,blue -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sb      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections 
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_sb = n_sb + 1
               sum_sb = sum_sb + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Sn in green circles
   ! Sn is a direct phase at close range for events below the Moho
   write (io_gmt,'(a)') '# Sn arrivals'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green -K -O << END >> $psfile'
   do iev = 1,nev
      do ird = 1,nst(iev)
         if (pass(fcode(iev,ird)) .and. phase(iev,ird) .eq. 'Sn      ') then
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
               tt_res = dt_cal(iev,ird) - s_cal(iev,ird) ! Shifted residual, with path corrections 
            else
               delt_plot = delt(iev,ird)
               tt_res = dt(iev,ird,it) - s(iev,ird,it) ! Residual, with path corrections 
            end if
            if (delt_plot .le. delt_limit) write (io_gmt,'(3f10.3)') tt_res, delt_plot, size
            if (delt_plot .le. delt_average) then
               n_sn = n_sn + 1
               sum_sn = sum_sn + tt_res
            end if
         end if
      end do
   end do
   write (io_gmt,'(a)') 'END'

   ! Average residuals
   average_pg = -999.
   average_pb = -999.
   average_pn = -999.
   average_sg = -999.
   average_sb = -999.
   average_sn = -999.
   if (n_pg .gt. 0) then
      average_pg = sum_pg/real(n_pg)
      write (io_gmt,'(a)') '# Average Pg residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthicker,red -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f6.3)') average_pg, 0.
      write (io_gmt,'(f5.2,3x,f6.3)') average_pg, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   if (n_pb .gt. 0) then
      average_pb = sum_pb/real(n_pb)
      write (io_gmt,'(a)') '# Average Pb residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthicker,blue -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f6.3)') average_pb, 0.
      write (io_gmt,'(f5.2,3x,f6.3)') average_pb, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   if (n_pn .gt. 0) then
      average_pn = sum_pn/real(n_pn)
      write (io_gmt,'(a)') '# Average Pn residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthicker,green -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f6.3)') average_pn, 0.
      write (io_gmt,'(f5.2,3x,f6.3)') average_pn, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   if (n_sg .gt. 0) then
      average_sg = sum_sg/real(n_sg)
      write (io_gmt,'(a)') '# Average Sg residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,red,- -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f4.1)') average_sg, 0.
      write (io_gmt,'(f5.2,3x,f4.1)') average_sg, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   if (n_sb .gt. 0) then
      average_sb = sum_sb/real(n_sb)
      write (io_gmt,'(a)') '# Average Sb residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,blue,- -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f4.1)') average_sb, 0.
      write (io_gmt,'(f5.2,3x,f4.1)') average_sb, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   if (n_sn .gt. 0) then
      average_sn = sum_sn/real(n_sn)
      write (io_gmt,'(a)') '# Average Sn residual'
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Wthin,green,- -K -O << END >> $psfile'
      write (io_gmt,'(f5.2,3x,f4.1)') average_sn, 0.
      write (io_gmt,'(f5.2,3x,f4.1)') average_sn, delt_average
      write (io_gmt,'(a)') 'END'
   end if
   
   ! Description
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f12p,Helvetica-Bold,black+a0.+jBL -O << END >> $psfile'
   write (msg,'(a,f3.1,a)') 'Residuals for crustal phases, average over (0-', delt_average, ')'
   write (io_gmt,'(2f10.3,3x,a)') 9., 0.025, trim(msg)
   if (average_pg .gt. -999) then
      write (msg,'(a,f5.1,a)') 'Pg = red x; average = ', average_pg, ' (solid red line)'
      write (io_gmt,'(2f10.3,3x,a)') 8., 0.05, trim(msg)
   end if
   if (average_pb .gt. -999) then
      write (msg,'(a,f5.1,a)') 'Pb = blue x; average = ', average_pb, ' (solid blue line)'
      write (io_gmt,'(2f10.3,3x,a)') 7., 0.05, trim(msg)
   end if
   if (average_pn .gt. -999) then
      write (msg,'(a,f5.1,a)') 'Pn = green x; average = ', average_pn, ' (solid green line)'
      write (io_gmt,'(2f10.3,3x,a)') 6., 0.05, trim(msg)
   end if
   if (average_sg .gt. -999.) then
      write (msg,'(a,f5.1,a)') 'Sg = red circles; average = ', average_sg, ' (dashed red line)'
      write (io_gmt,'(2f10.3,3x,a)') -7.5, 0.05, trim(msg)
   end if
   if (average_sb .gt. -999.) then
      write (msg,'(a,f5.1,a)') 'Sb = blue circles; average = ', average_sb, ' (dashed blue line)'
      write (io_gmt,'(2f10.3,3x,a)') -8.5, 0.05, trim(msg)
   end if
   if (average_sn .gt. -999.) then
      write (msg,'(a,f5.1,a)') 'Sn = green circles; average = ', average_sn, ' (dashed green line)'
      write (io_gmt,'(2f10.3,3x,a)') -9.5, 0.05, trim(msg)
   end if
   write (io_gmt,'(a)') 'END'
         
   close (io_gmt)
   
   call run_gmt_script (gmt_script_path, psfile)
   
   ! Move the scripts into the script directory
   command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
   call system (trim(command_line))
      
   return
   
end subroutine tt_near_source


!*****************************************************************************************
subroutine dem1_gmt (monochrome)
   
! GMT script commands for plotting topography at a regional scale
   
   implicit none
   
   include 'mloc.inc'
   
   logical :: monochrome
   character(len=132) ::msg
      
   select case (ishell)
      case (1)
         write (io_gmt,'(a)') 'palette=-C'//trim(cpt_path)//dirsym//trim(cpt_file)
      case (2)
         write (io_gmt,'(a)') 'set palette = -C'//trim(cpt_path)//dirsym//trim(cpt_file)
      case (3)
         write (io_gmt,'(a)') 'palette=-C'//trim(cpt_path)//dirsym//trim(cpt_file)
   end select
      
   call fyi ('dem1_gmt: ETOPO1 will be used')
   if (gmt_version .eq. 6) then
      write (io_gmt,'(a)') 'gmt grdcut @earth_relief_01m_g -Gmloc.grd $region'
   else if (gmt_version .eq. 5) then
      write (io_gmt,'(a)') 'gmt grdcut '//trim(dem_path)//dirsym//'ETOPO'//dirsym//'ETOPO1_Bed_g_gmt4.grd -Gmloc.grd $region'
   else
      write (msg,'(a,i1)') 'dem1_gmt: Only GMT v5 or v6 is supported for topography. gmt_version = ', gmt_version
      call warnings (trim(msg))
      return
   end if
   write (io_gmt,'(a)') 'gmt grdgradient mloc.grd -Gmloc_ilum.grd -A340 -Nt'
   if (monochrome) then
      write (io_gmt,'(a)') 'gmt grdimage mloc.grd $palette $projection -Imloc_ilum.grd -M -O -K >> $psfile'   
   else
      write (io_gmt,'(a)') 'gmt grdimage mloc.grd $palette $projection -Imloc_ilum.grd -O -K >> $psfile'
   end if
   write (io_gmt,'(a)') 'rm mloc.grd mloc_ilum.grd'
      
   return
   
end subroutine dem1_gmt


!*****************************************************************************************
subroutine dem2_gmt ()
   
! GMT script commands for plotting high-rez topography provided by the user.
! A temporary color palette table is derived from the grid to be plotted, and scaled
! from the base color palette table (program default or defined in the configuration file).
   
   implicit none
   
   include 'mloc.inc'
   
   character(len=132) :: base_cpt
   
   base_cpt = trim(cpt_path)//dirsym//trim(cpt_file)
   if (verbose_screen) call fyi ('dem2_gmt: base color table = '//trim(base_cpt))
      
   write (io_gmt,'(a)') 'gmt grdcut '//trim(dem2_filename)//' -Gmloc.grd $region'
   write (io_gmt,'(a)') 'gmt grdgradient mloc.grd -Gmloc_ilum.grd -A340 -Nt'
   write (io_gmt,'(a)') 'gmt grd2cpt mloc.grd -C'//trim(base_cpt)//' > mloc.cpt'
   select case (ishell)
      case (1)
         write (io_gmt,'(a)') 'palette=-Cmloc.cpt'
      case (2)
         write (io_gmt,'(a)') 'set palette = -Cmloc.cpt'
      case (3)
         write (io_gmt,'(a)') 'palette=-Cmloc.cpt'
   end select
   write (io_gmt,'(a)') 'gmt grdimage mloc.grd $palette $projection -Imloc_ilum.grd -O -K >> $psfile'
   write (io_gmt,'(a)') 'rm mloc.grd mloc_ilum.grd mloc.cpt'
      
   return
   
end subroutine dem2_gmt


!*****************************************************************************************
subroutine epa_plot_driver (it)

! Driver for empirical path anomaly plots

   implicit none
   
   include 'mloc.inc'

   integer :: i, it, lps
   character(len=132) :: plot_folder, psfile, gmt_script, pdf_file, gmt_script_path
   character(len=180) :: command_line
   
   call fyi ('epa_plot_driver: empirical path anomaly plots')   

   ! Create the subdirectory for plots
   plot_folder = trim(datadir)//dirsym//trim(basename)//'_epa'
   command_line = 'mkdir '//trim(plot_folder)
   call system (trim(command_line))
   
   ! Loop over plots
   do i = 1,n_epa_plot
      call make_epa_plot (i, it, psfile, gmt_script)
      lps = len_trim(psfile)
      pdf_file = psfile(1:lps-2)//'pdf'
      ! Move PDF files into the plot folder
      command_line = 'mv '//trim(datadir)//dirsym//trim(pdf_file)//' '//trim(plot_folder)//dirsym//trim(pdf_file)
      call system (trim(command_line))
      ! Move the scripts into the script directory
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
   end do
      
   return
   
end subroutine epa_plot_driver


!*****************************************************************************************
subroutine make_epa_plot (i_epa, it, psfile, gmt_script)

! Create the GMT script for an individual empirical path anomaly plot

   implicit none
   
   include 'mloc.inc'

   integer :: it, it1, i, j, i_epa, lenb
   real :: xlonmin, xlonmax, ylatmin, ylatmax, ylatcir, xloncir, xl, yl, xymax,&
    qlat_epa, lath_epa_g, plot_distance_km
   real :: ys, ymin, ymax, xs, xmin, xmax, dlat, dlon, dgkmlo
   character(len=132) :: psfile, gmt_script, msg, plot_title, gmt_script_path
   character(len=30) :: comline1, comline2, dashb
   character(len=4) :: shell
   character(len=1) :: n_epa
   logical :: epap_used
   
   if (verbose_screen) then
      write (msg,'(i1,1x,a,f4.1,1x,l1)') 'make_epa_plot: ', i_epa, epa_plot_phase(i_epa),&
       epa_plot_distance(i_epa), epa_plot_raypath(i_epa)
      call fyi (trim(msg))
   end if
   
   write (n_epa,'(i1)') i_epa
   dashb = ' '
   it1 = it + 1

   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   
   gmt_script = trim(basename)//'_epa_'//trim(n_epa)//'.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'make_epa_plot: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')
   
   write (io_gmt,'(a)') '#!/bin/'//trim(shell)
   
   ! Set some GMT parameters (shell-independent)
   
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset FORMAT_GEO_MAP D' ! Use '+D' for 0-360 longitude
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 

   ! Map boundaries

   psfile = trim(basename)//'_epa_'//trim(n_epa)//'.ps'
   plot_distance_km = epa_plot_distance(i_epa)*111.19 ! Convert to km

   call map_boundaries (it1, 0, xlonmin, xlonmax, ylatmin, ylatmax)
      plot_distance_km = epa_plot_distance(i_epa)*111.19 ! Convert to km
      dlat = plot_distance_km * dgkmla
      dlon = plot_distance_km * dgkmlo(lath(it1))
      ylatmin = ylatmin - dlat
      ylatmax = ylatmax + dlat
      xlonmin = xlonmin - dlon
      xlonmax = xlonmax + dlon
      comline1 = ' '
      comline2 = ' '
      write (comline1,'(f6.1,3(a,f6.1))') xlonmin, '/', xlonmax, '/', ylatmin, '/', ylatmax
      j = 1
      do i = 1,lenb(comline1)
         if (comline1(i:i) .ne. ' ') then
            comline2(j:j) = comline1(i:i)
            j = j + 1
         end if
      end do
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JM16.0c+' 
         write (io_gmt,'(2a)') 'region=-R', trim(comline2)
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JM16.0c+'
         write (io_gmt,'(2a)') 'set region = -R', trim(comline2)
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JM16.0c+' 
         write (io_gmt,'(2a)') 'region=-R', trim(comline2)
   end select

   ! Basemap
   xl = abs(xlonmax - xlonmin)
   yl = abs(ylatmax - ylatmin)
   xymax = max(xl, yl)
   if (xymax .gt. 10.) then
      dashb = "a5.0f1.0"
   else if (xymax .gt. 2.0) then
      dashb = "a1.0f0.1"
   else if (xymax .gt. 1.0) then
      dashb = "a0.5f0.1"         
   else
      dashb = "a0.2f0.1"
   end if
   plot_title = "'Empirical Path Anomalies: "//trim(epa_plot_phase(i_epa))//' '//trim(basename)//"'"
   select case (ishell)
      case (1)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(dashb)//' ',&
         '-By'//trim(dashb)//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
      case (2)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(dashb)//' ',&
         '-By'//trim(dashb)//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K >! $psfile'
      case (3)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(dashb)//' ',&
         '-By'//trim(dashb)//' ',&
         '-BWeSn+t'//trim(plot_title)//' -K > $psfile'
   end select

   ! Topography
   if (plot_dem1) call dem1_gmt (.true.)
   
   ! Ray paths
   if (epa_plot_raypath(i_epa)) then
      write (io_gmt,'(a)') '# Raypaths'
      ymin = ylatmin
      ymax = ylatmax
      xmin = xlonmin
      call set_longitude_range (xmin, longitude_range)
      xmax = xlonmax
      call set_longitude_range (xmax, longitude_range)
      call geogra (lath_epa,lath_epa_g)
      do i = 1,nqc
         if (qname1(i)(14:21) .eq. epa_plot_phase(i_epa)) then
            call geogra (qlat(i), qlat_epa)
            ys = qlat_epa
            xs = qlon(i)
            call set_longitude_range (xs, longitude_range)
            if (ys .ge. ymin .and. ys .le. ymax .and. xs .ge. xmin .and. xs .le. xmax) then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -W0.1p,black -O -K << END >> $psfile'  
               write (io_gmt,'(2f10.3)')  qlat_epa, qlon(i)
               write (io_gmt,'(2f10.3)')  lath_epa_g, lonh_epa
               write (io_gmt,'(a)') 'END'
            end if
         end if
      end do
   else
      call geogra (lath_epa,lath_epa_g)
      write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sa -Wthicker,red -Gred -O -K << END >> $psfile'
      write (io_gmt,'(3f10.3)') lath_epa_g, lonh_epa, 0.3 
      write (io_gmt,'(a)') 'END'     
   end if

   ! If direct calibration is not in effect, all symbols will be open
   if (.not.direct_cal) then
      nstn_used = 1
      stn_dcal_used(1) = ' '
   end if

   ! Station symbols 
   write (io_gmt,'(a)') '# Station symbols'
   do i = 1,nqc
      epap_used = .false.
      do j = 1,nstn_used
         if (qname1(i)(1:13) .eq. stn_dcal_used(j)) epap_used = .true.
      end do
      if (qname1(i)(14:21) .eq. epa_plot_phase(i_epa)) then
         if (epa(i) .gt. 0. .and. epa(i) .lt. 0.3) then
            if (epap_used) then
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green -Ggreen -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            if (.not.epap_used) then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green -K -O << END >> $psfile'
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            write (io_gmt,'(a)') 'END'
         end if
         if (epa(i) .gt. 0.3) then
            if (epap_used) then
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,red -Gred -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            if (.not.epap_used) then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,red -K -O << END >> $psfile'
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            write (io_gmt,'(a)') 'END'
         end if
         if (epa(i) .lt. 0. .and. epa(i) .gt. -0.3) then
            if (epap_used) then
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green -Ggreen -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            if (.not.epap_used) then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green -K -O << END >> $psfile'
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            write (io_gmt,'(a)') 'END'
         end if
         if (epa(i) .lt. -0.3) then
            if (epap_used) then
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,blue -Gblue -K -O << END >> $psfile'
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            if (.not.epap_used) then
               write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,blue -K -O << END >> $psfile'
               call geogra (qlat(i), qlat_epa)
               write (io_gmt,'(3f10.3)')  qlat_epa, qlon(i), epa(i)*0.25
            end if
            write (io_gmt,'(a)') 'END'
         end if
      end if
   end do

   ! Station names
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f5p,Helvetica,black+a0.+jBL -O -K << END >> $psfile'
   do i = 1,nqc
      ! if (indexq(i) .ge. 2 .and. idiff0(i) .eq. 0) then
      if (qname1(i)(14:21) .eq. epa_plot_phase(i_epa)) then
             call geogra (qlat(i), qlat_epa)
             write (io_gmt,'(2f10.3,3x,a)') qlat_epa, qlon(i), qname1(i)(1:5)
      end if
   end do
   write (io_gmt,'(a)') 'END'

   ! Legend
   xloncir = xlonmin+(0.1*epa_plot_distance(i_epa))
   ylatcir = ylatmin+(0.15*epa_plot_distance(i_epa))
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica,black+a0.+jBL -O -K << END >> $psfile'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir+(0.13*epa_plot_distance(i_epa)), xloncir+(0.017*epa_plot_distance(i_epa)),&
    'Closed circles: stations used in direct calibration'
!      write (io_gmt,'(2f10.3,3x,a)') ylatcir+0.40, xloncir+0.05, epa_plot_phase(i_epa)
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,blue  -O -K << END >> $psfile'
!      write (io_gmt,'(5f10.3)') ylatcir, xloncir,     -3.*0.25  
   write (io_gmt,'(5f10.3)') ylatcir, xloncir+(0.11*epa_plot_distance(i_epa)), -2.*0.25 
   write (io_gmt,'(5f10.3)') ylatcir, xloncir+(0.243*epa_plot_distance(i_epa)), -1.*0.25  
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,green  -K -O << END >> $psfile'
   write (io_gmt,'(5f10.3)') ylatcir, xloncir+(0.357*epa_plot_distance(i_epa)), 0.1  
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sc -Wthick,red  -K -O << END >> $psfile'
   write (io_gmt,'(5f10.3)') ylatcir, xloncir+(0.49*epa_plot_distance(i_epa)), 1.*0.25  
   write (io_gmt,'(5f10.3)') ylatcir, xloncir+(0.623*epa_plot_distance(i_epa)), 2.*0.25  
!      write (io_gmt,'(5f10.3)') ylatcir, xloncir+1.5,  3.*0.25 
   write (io_gmt,'(a)') 'END'
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica,black+a0.+jBL -O << END >> $psfile'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir+(0.067*epa_plot_distance(i_epa)), xloncir+(0.0167*epa_plot_distance(i_epa)),&
    'Station Residuals (sec.)'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir-(0.10*epa_plot_distance(i_epa)), xloncir+(0.05*epa_plot_distance(i_epa)), '-2'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir-(0.10*epa_plot_distance(i_epa)), xloncir+(0.19*epa_plot_distance(i_epa)), '-1'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir-(0.10*epa_plot_distance(i_epa)), xloncir+(0.34*epa_plot_distance(i_epa)), '0'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir-(0.10*epa_plot_distance(i_epa)), xloncir+(0.435*epa_plot_distance(i_epa)), '+1'
   write (io_gmt,'(2f10.3,3x,a)') ylatcir-(0.10*epa_plot_distance(i_epa)), xloncir+(0.570*epa_plot_distance(i_epa)), '+2'
   write (io_gmt,'(a)') 'END'

   close (io_gmt)

   call run_gmt_script (gmt_script_path, psfile)

   return
   
end subroutine make_epa_plot


!*****************************************************************************************
subroutine focal_depth_histogram (it)

! Histogram of focal depths

   implicit none
   
   include 'mloc.inc'
   
   integer :: i, j, it, it1, iev, count(0:n_hrdp_max), count_max, idep_min, idep_max, xmin, xmax, ymax
   real :: depth_min, depth_max, depth_range
   logical :: cluster_default
   character(len=180) :: command_line
   character(len=132) :: psfile, gmt_script, plot_title, gmt_script_path, msg
   character(len=16) :: region, region_base
   character(len=8) :: tics
   character(len=4) :: shell

   call fyi ('focal_depth_histogram: histogram of focal depths')
   
   it1 = it + 1

   ! Histogram limits
   depth_min = 999.
   depth_max = 0.
   count = 0
   do iev = 1,nev
      depth_min = min(depthp(iev,it1),depth_min)
      depth_max = max(depthp(iev,it1),depth_max)
      count(nint(depthp(iev,it1))) = count(nint(depthp(iev,it1))) + 1
   end do
   idep_min = nint(depth_min)
   idep_max = nint(depth_max)
   count_max = 0
   do i = idep_min,idep_max
      count_max = max(count_max,count(i))
   end do
   xmin = idep_min - 5
   if (xmin .lt. 0) xmin = 0
   xmax = idep_max + 5
   ymax = count_max + 5
   
   ! Depth axis tic spacing
   depth_range = depth_max - depth_min
   if (depth_range .le. 30.) then
      tics = 'a10f1' ! Major tics and labels at 5 km, minor tics at 1 km
   else if (depth_range .le. 150.) then
      tics = 'a25f5' ! Major tics and labels at 25 km, minor tics at 5 km
   else
      tics = 'a50f10' ! Major tics and labels at 50 km, minor tics at 10 km
   end if
     
   select case (ishell)
    case (1)
       shell = 'bash'
    case (2)
       shell = 'csh '
    case (3)
       shell = 'zsh '
   end select
   gmt_script = trim(basename)//'_depth_histogram.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
    write (msg,'(3a,i3)') 'focal_depth_histogram: opening ', trim(gmt_script_path), ' on unit ', io_gmt
    call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')

   write (io_gmt,'(a)') '#!/bin/'//trim(shell)

   ! Set some GMT parameters (shell-independent)
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
   
   psfile = trim(basename)//'_depth_histogram.ps'
   plot_title = "'Focal Depths "//trim(basename)//"'"
   
   write (region_base,'(i3,a1,i3,a3,i3)') xmin, '/', xmax, '/0/', ymax
   ! Text string for the region boundaries
   j = 0
   region = ' '
   do i = 1,16
      if (region_base(i:i) .ne. ' ') then
         j = j + 1
         region(j:j) = region_base(i:i)
      end if
   end do
   
   select case (ishell)
    case (1)
       write (io_gmt,'(2a)') 'psfile=', trim(psfile)
       write (io_gmt,'(a)') 'projection=-JX12/10'
       write (io_gmt,'(a)') 'region=-R'//trim(region)
       write (io_gmt,'(5a)') 'gmt pshistogram $projection $region ',&
       '-W1 -F -Gcyan -L1p -Z0 ',&
       '-Bx'//trim(tics)//'+l'//"'Depth (km)'"//' ',&
       '-Bya10f1+lCounts ',&
       '-BWeSn+t'//trim(plot_title)//' -K <<END>> $psfile'
    case (2)
       write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
       write (io_gmt,'(a)') 'set projection = -JX12/10'
       write (io_gmt,'(a)') 'set region = -R'//trim(region)
       write (io_gmt,'(5a)') 'gmt pshistogram $projection $region ',&
       '-W1 -F -Gcyan -L1p -Z0 ',&
       '-Bx'//trim(tics)//'+l'//"'Depth (km)'"//' ',&
       '-Bya10f1+lCounts ',&
       '-BWeSn+t'//trim(plot_title)//' -K <<END>>! $psfile'
    case (3)
       write (io_gmt,'(2a)') 'psfile=', trim(psfile)
       write (io_gmt,'(a)') 'projection=-JX12/10'
       write (io_gmt,'(a)') 'region=-R'//trim(region)
       write (io_gmt,'(5a)') 'gmt pshistogram $projection $region ',&
       '-W1 -F -Gcyan -L1p -Z0 ',&
       '-Bx'//trim(tics)//'+l'//"'Depth (km)'"//' ',&
       '-Bya10f1+lCounts ',&
       '-BWeSn+t'//trim(plot_title)//' -K <<END>> $psfile'
   end select
   
   ! Depth values
   cluster_default = .false.
   do iev = 1,nev
      if (depset_pr(iev) .eq. 'c') cluster_default = .true.
      if (calibration) then
         write (io_gmt,'(f10.3)') depthp_cal(iev)
      else
         write (io_gmt,'(f10.3)') depthp(iev,it1)
      end if
   end do
   write (io_gmt,'(a)') 'END'
   
   ! Overlay histogram of depths set by cluster default, in black
   if (cluster_default) then
      write (io_gmt,'(2a)') 'gmt pshistogram $projection $region -W1 -F -Gblack -K -O << END >> $psfile'
      do iev = 1,nev
         if (depset_pr(iev) .ne. 'c') cycle
         if (calibration) then
            write (io_gmt,'(f10.3)') depthp_cal(iev)
         else
            write (io_gmt,'(f10.3)') depthp(iev,it1)
         end if
      end do
      write (io_gmt,'(a)') 'END'
   end if
   
   ! Median of constrained focal depths (only available if there are at least 3 samples)   
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jBL -K -O << END >> $psfile'
   if (median_constrained_depths .gt. 0.) then
      write (msg,'(a,f5.1)') 'Median of constrained depths = ', median_constrained_depths
   else
      write (msg,'(a)') 'Median of constrained depths = N/A'
   end if
   write (io_gmt,'(2f10.3,1x,a)') ymax*0.94, float(xmin)+1., trim(msg)
   write (io_gmt,'(a)') 'END'

   ! Spread of constrained focal depths (only available if there are at least 3 samples)   
   write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f10p,Helvetica,black+a0.+jBL -O << END >> $psfile'
   if (n_cfd .ge. 3) then
      write (msg,'(a,f5.1)') 'Spread of constrained depths = ', rescfd
   else
      write (msg,'(a)') 'Spread of constrained depths = N/A'
   end if
   write (io_gmt,'(2f10.3,1x,a)') ymax*0.88, float(xmin)+1., trim(msg)
   write (io_gmt,'(a)') 'END'
   close (io_gmt)

   call run_gmt_script (gmt_script_path, psfile)

   ! Move the script into the script directory
   command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
   call system (trim(command_line))
      
   return

end subroutine focal_depth_histogram


!*****************************************************************************************
subroutine phase_residual_plot (i_phrp, it, phase_in, delta_min, delta_max, psfile, gmt_script)

! Plot of residuals for a specified phase, reduced by the theoretical travel time.
! The plot is made over a user-specified epicentral distance range.

   implicit none
   
   include 'mloc.inc'
   
   ! tau-p variables
   integer, parameter :: max = 60
   real :: tt(max), dtdd(max), dtdh(max), dddp(max)
   integer :: nphase
   character(len=8) :: phcd(max)

   integer :: i_phrp, it, it1, iev, ird, np, n_plot
   real :: hp, delta_min, delta_max, ttred, reduction_tt, size, usrc(2), delt_plot, delta_range
   character(len=1) :: index
   character(len=3) :: dmin, dmax
   character(len=4) :: shell
   character(len=8) :: phase_in, tics
   character(len=16) :: region
   character(len=132) :: msg, psfile, gmt_script, gmt_script_path, plot_title
   logical :: pass
   
   call fyi ('phase_residual_plot: '//phase_in)

   it1 = it + 1
   
   select case (ishell)
      case (1)
         shell = 'bash'
      case (2)
         shell = 'csh '
      case (3)
         shell = 'zsh '
   end select
   write (index,'(i1)') i_phrp
   
   ! Epicentral distance axis tics and annotation
   delta_range = delta_max - delta_min
   if (delta_range .le. 20.) then
      tics = 'a5f1' ! Major tics and labels at 5°, minor tics at 1°
   else if (delta_range .le. 50.) then
      tics = 'a10f5' ! Major tics and labels at 10°, minor tics at 5°
   else
      tics = 'a25f5' ! Major tics and labels at 25°, minor tics at 10°
   end if

   gmt_script = trim(basename)//'_phase_residual_plot_'//index//'_'//trim(phase_in)//'.'//trim(shell)
   gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
   if (verbose_screen) then
      write (msg,'(3a,i3)') 'phase_residual_plot: opening ', trim(gmt_script_path), ' on unit ', io_gmt
      call fyi (trim(msg))
   end if
   open (io_gmt,file=gmt_script_path,status='new')
   
   write (io_gmt,'(a)') '#!/bin/'//trim(shell)
   
   ! Set some GMT parameters (shell-independent)
   
   write (io_gmt,'(a)') 'gmt gmtset PS_MEDIA letter' 
   write (io_gmt,'(a)') 'gmt gmtset PROJ_LENGTH_UNIT cm' 
   write (io_gmt,'(a)') 'gmt gmtset PS_PAGE_ORIENTATION portrait' 
 
   ! Basemap and associated variables
   psfile = trim(basename)//'_phase_residual_plot_'//index//'_'//trim(phase_in)//'.ps'
   plot_title = trim(phase_in)//' Residuals '//trim(basename)
   write (dmin,'(i3)') nint(delta_min)
   write (dmax,'(i3)') nint(delta_max)
   dmin = adjustl(dmin)
   dmax = adjustl(dmax)
   region = '-R'//trim(dmin)//'/'//trim(dmax)//'/-15/15'
   select case (ishell)
      case (1)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX12'
         write (io_gmt,'(a)') 'region='//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(adjustl(tics))//'+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Residual (s)'"//' ',&
         '-BWeSn+t'//"'"//trim(plot_title)//"'"//' -K > $psfile'
      case (2)
         write (io_gmt,'(2a)') 'set psfile = ', trim(psfile)
         write (io_gmt,'(a)') 'set projection = -JX12'
         write (io_gmt,'(a)') 'set region = '//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(adjustl(tics))//'+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Residual (s)'"//' ',&
         '-BWeSn+t'//"'"//trim(plot_title)//"'"//' -K >! $psfile'
      case (3)
         write (io_gmt,'(2a)') 'psfile=', trim(psfile)
         write (io_gmt,'(a)') 'projection=-JX12'
         write (io_gmt,'(a)') 'region='//trim(region)
         write (io_gmt,'(4a)') 'gmt psbasemap $region $projection ',&
         '-Bx'//trim(adjustl(tics))//'+l'//"'Epicentral Distance (deg)'"//' ',&
         '-Bya5f1+l'//"'Residual (s)'"//' ',&
         '-BWeSn+t'//"'"//trim(plot_title)//"'"//' -K > $psfile'
   end select
         
   size = 0.2 ! symbol size in cm

   write (io_gmt,'(a)') 'gmt psxy -: -R $projection -Sx -Wthin,black -K -O << END >> $psfile'
   n_plot = 0
   do iev = 1,nev
      call depset (depthp(iev,it), usrc)
      do ird = 1,nst(iev)
         if (phase(iev,ird) .ne. phase_in) cycle
         if (.not.pass(fcode(iev,ird))) cycle
         if (delt(iev,ird) .ge. delta_min .and. delt(iev,ird) .le. delta_max) then
            reduction_tt = -1.
            if (calibration) then
               delt_plot = delt_cal(iev,ird)
            else
               delt_plot = delt(iev,ird)
            end if
            if (.not.locmod) then
               call trtm (delt_plot, max, nphase, tt, dtdd, dtdh, dddp, phcd)
            else
               hp = depthp(iev,it)
               if (verbose_log) write (io_log,'(a)') 'Calling tt_mixed_model from phase_residual_plot'
               call tt_mixed_model (hp, delt_plot, nphase, tt, dtdd, dtdh, dddp, phcd)
            end if
            do np=1,nphase
               if (phcd(np) .eq. phase_in) then
                  reduction_tt = tt(np)
                  exit
               end if
            end do
            if (reduction_tt .gt. 0.) then
               ttred = tto(iev,ird) - reduction_tt
               write (io_gmt,'(3f10.3)') ttred, delt_plot, size
               n_plot = n_plot + 1
            else
               write (msg,'(a,i3,3(a,1x),i5,a,f5.1,a)') 'phase_residual_plot: no reduction tt found for event ',&
                iev, evtnam(iev), stname(iev,ird), phase_in, mnf_line(iev,ird), ' at ', delt_plot, '°'
               call warnings (trim(msg))
            end if
         end if
      end do ! loop over phase readings
   end do ! loop over events
   write (io_gmt,'(a)') 'END'
   
   ! Legend
    write (io_gmt,'(a)') 'gmt pstext -: -R $projection -F+f8p,Helvetica-Bold,black+a0.+jBL -O << END >> $psfile'
    write (io_gmt,'(2f10.3,1x,a)') 14., delta_min+1.0, 'All times reduced by the theoretical travel time'
    write (io_gmt,'(a)') 'END'
   
   close (io_gmt)

   call run_gmt_script (gmt_script_path, psfile)
   
   write (msg,'(a,i5,a)') 'phase_residual_plot: ', n_plot, ' instances of '//trim(phase_in)//' plotted'
   if (verbose_screen) call fyi (trim(msg))
   if (verbose_log) write (io_log,'(/a)') trim(msg)

   return
   
end subroutine phase_residual_plot


!*****************************************************************************************
subroutine phrp_plot_driver (it)

! Driver for phase residual plots

   implicit none
   
   include 'mloc.inc'

   integer :: i, it, lps
   character(len=132) :: plot_folder, psfile, gmt_script, pdf_file, gmt_script_path
   character(len=180) :: command_line
   
   call fyi ('phrp_plot_driver: phase residual plots')   

   ! Create the subdirectory for plots
   plot_folder = trim(datadir)//dirsym//trim(basename)//'_phrp'
   command_line = 'mkdir '//trim(plot_folder)
   call system (trim(command_line))
   
   ! Loop over plots
   do i = 1,n_phrp
      call phase_residual_plot (i, it, phrp_phase(i), phrp_delt(i,1), phrp_delt(i,2), psfile, gmt_script)
      lps = len_trim(psfile)
      pdf_file = psfile(1:lps-2)//'pdf'
      ! Move PDF files into the plot folder
      command_line = 'mv '//trim(datadir)//dirsym//trim(pdf_file)//' '//trim(plot_folder)//dirsym//trim(pdf_file)
      call system (trim(command_line))
      ! Move the scripts into the script directory
      gmt_script_path = trim(datadir)//dirsym//trim(gmt_script)
      command_line = 'mv '//trim(gmt_script_path)//' '//trim(gmt_script_dir)//dirsym//trim(gmt_script)
      call system (trim(command_line))
   end do
      
   return
   
end subroutine phrp_plot_driver

