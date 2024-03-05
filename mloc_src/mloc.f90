!***********************************************************************************************************************************
program mloc

! Main program and command processor to perform multiple event relocation on a cluster of
! earthquakes, using the Hypocentroidal Decomposition (HD) algorithm of Jordan
! and Sverdrup (BSSA, 71, 1105-1130, 1981). The code has been heavily modified
! to support research in calibrated locations, but the core HD algorithm is unchanged.

! See the file 'mloc version history' for documentation on major changes.
! There are also extensive comments in the code.

! Dr. Eric A. Bergman
! Global Seismological Services
! 1900 19th St., Golden, CO 80401, USA
! +1 (720) 400-7835
! bergman@seismo.com
! http://www.seismo.com

   implicit none

   include 'mloc.inc'
   include 'ttlim.inc'

   integer :: i, j, iev, ios, jev, luopen, io_psdre, lunit, io_bp
   integer :: year_oe1, month_oe1, day_oe1, year_oe2, month_oe2, day_oe2, jdate
   logical :: op, ex, cmndfil, command_help
   character(len=4) :: comd
   character(len=8) :: line8
   character(len=12) :: line12
   character(len=34) :: line34
   character(len=40) :: psdre_file, bp_file, junk_phases_file
   character(len=80) :: line
   character(len=94) :: line94
   character(len=100) :: plog_file, stn_log_file, taup_file, open_file_name, outfil,&
    psdre_path, bp_path, bptc_log_file, phases_path
   character(len=102) :: line102
   character(len=132) :: msg, line132, filename, command_line

   data line/' '/, params/' '/

   ! Initialization
   
   ! Path defaults
   dirsym = '/'
   mloc_path = ' '
   taup_path = 'tables/tau-p'
   ellip_path = 'tables/ellipticity'
   station_path = 'tables/stn'
   station_master = 'master_stn.dat'
   cpt_path = 'tables/gmt/cpt'
   cpt_file = 'topo.cpt'
   dem_path = 'tables/gmt/dem'
   psdre_path = 'tables/spread'
   psdre_file = 'psdre.dat' ! Phase-specific default reading errors
   bp_path = 'tables/tau-p'
   bp_file = 'etopo5_bed_g_i2.txt'
   nsmd_file = 'neic_stn.dat'
   ifsm_file = 'ISC-FDSN_stn.dat'
   phases_path = 'tables/phases'
   junk_phases_file = 'junk_phases.dat'
   gcat_folder = ' '
   
   ! Configuration defaults

   ! Relocation controls
   dflag = .true. ! Use data flags
   dflag_pr = 'on '
   fltrcdelt = .false.
   fltrcres = .false.
   fltrcflag = .false.
   fltrc = .false.
   fltrhdelt = .false.
   fltrhres = .false.
   fltrhflag = .false.
   fltrh = .false.
   connected = .false.
   bias_corr = .true. ! Correction for bias in hypocentroid from events with many more readings
   data_weight = .true. ! Weight inverse to reading error
   data_weight_pr = 'on '
   pttt = .false. ! Assume perfect theoretical travel times for hypocentroid
   pttt_pr = 'off'
   tt_corr = 1 ! Station correction to theoretical travel times (elevation correction)
   phid = .true. ! Phase re-identification
   no_phid = ' ' ! Flag to prevent phase re-identification for individual readings
   n_no_phreid = 0 ! Number of phases for which phase re-identification is prevented (PPRI)
   n_skip = 0 ! Number of SKIP commands
   skip = .false.
   ponly = .true. ! Use P only or all phase types for hypocentroid
   cmndfil = .false. ! Command file in use
   nstep = itmax ! Number of iterations to perform
   tikhonov_factor = 0.
   damping = .false.
   no_xflags = .false.

   ! TT models
   log_taup = .false. ! Log file for intermediate tau-p results
   taup_model = 'ak135'
   locmod = .false. ! Separate layered crustal model for local distances
   dlimlocmod = 0. ! Epicentral distance limit for local model
   zlimlocmod = 0. ! Focal depth limit for local model
   locmodfname = ' ' ! Pathname to local crustal model file
   bptc = .true. ! Bounce point topography correction, for pP, sP and pwP
   pcrvel = 5.8 ! P velocity for station elevation correction
   scrvel = 3.46 ! S velocity for station elevation correction
   timing_error_correction = .false.
   n_terr = 0 ! Number of stations with timing corrections
   terr_stn = ' ' ! Station codes with timing corrections
   terr_corr = 0. ! Timing corrections

   ! Epicentral distance limits
   nclim = 1 ! Number of distance windows in use for cluster vectors
   clim(1,1) = 0.
   clim(1,2) = 180.
   nhlim = 1 ! Number of distance windows in use for hypocentroid
   hlim(1,1) = 30.
   hlim(1,2) = 90.

   ! Free and fixed parameters
   fixpr = 'free '
   fixprh = 'free '
   depthf = .true.
   depthfh = .true.
   latf = .true.
   latfh = .true.
   lonf = .true.
   lonfh = .true.
   timef = .true.
   timefh = .true.
   depthpr = '     '
   latpr = '   '
   lonpr = '   '
   timepr = '           '
   mtiev = 0

   ! Differential time data
   cscale = 10. ! Spatial scale over which crustal velocities may vary
   vmr = 0.05 ! Percentage variation in crustal velocities

   ! Starting locations
   lat_cf = -999.
   lat_hdf = -999.
   lon_cf = -999.
   lon_hdf = -999.
   time_cf = -999.
   time_hdf = -999.
   hdepthshift = 0.
   hlatshift = 0.
   hlonshift = 0.
   htimeshift = 0.
   depthp_plus = 99.9
   depthp_minus = 99.9
   read_hdf = .false.
   nrhdf = 0
   depset_pr = ' '
   depth_inp_c = ' '
   depth_default_c = 'c' ! Depth code used for default cluster depth
   depth_hdf_c = ' '
   depth_cf_c = ' '
   depth_default = -999.
   do i = 1,nevmax
      depth_inp(i,1) = -999.
      depth_inp(i,2) = 99.9
      depth_inp(i,3) = 99.9
      depth_hdf(i,1) = -999.
      depth_hdf(i,2) = 99.9
      depth_hdf(i,3) = 99.9
      depth_cf(i,1) = -999.
      depth_cf(i,2) = 99.9
      depth_cf(i,3) = 99.9
   end do
   hdf_dep = -999.
   hdf_dep_code = 'u '
   hdf_dep_plus = 99.9
   hdf_dep_minus = 99.9
   
   ! MNF record fields
   hypo_author = ' '
   magnitude_author = ' '
   dist_az = ' '
   evid = ' '
   evid_source = ' '
   adslcaa = ' '

   ! Calibration events
   icaltype = 2
   icaltype_pr = 'systematic  '
   rdbt = 0.
   ncal = 0
   cal_dep = 0.
   calibration = .false.
   cal_event = .false.
   cal_hr = 0
   cal_lat = 0.
   cal_lon = 0.
   cal_min = 0
   cal_sec = 0.
   ccv = 0.
   rcv = 0.
   scv = 0.
   w12 = 0.
   w3 = 0.
   w4 = 0.
   ot_cal = .false.
   cal_par = ' '
   cal_level = 99

   ! Input files
   infile = ' '
   nev = 0
   iev = 0
   evtnam = ' '
   suppfilnam = ' '
   suppstn = .false. ! Supplementary station code files are used
   n_supp_stn_file = 0 ! Number of supplementary station files
   ttsprdfname = 'default'
   read_ttsprd = .false. ! Use a file of empirical travel-time spreads for different phases
   rderrfname = 'default'
   read_rderr = .false. ! Use a file of empirical reading errors for individual station-phases
   bdp_list = .false. ! List of stations known to report bad depth phases
   bdp_filnam = ' '
   n_bdp = 0 ! Number of entries in the 'bad depth phases' list
   bdp_station = ' '
   nsmd = .false. ! No search of NEIC station metadata for missing station codes
   ifsm = .false. ! No search of ISC-FDSN station metadata for missing station codes
   n_nsmd_read = 0 ! Number of entries read from the NEIC metadata file
   n_nsmd_written = 0 ! Number of entries written to the log file for potential use in a supplemental station file
   nsmd_on = 0
   nsmd_off = 0
   n_ifsm_read = 0 ! Number of entries read from the ISC-FDSN metadata file
   n_ifsm_written = 0 ! Number of entries written to the log file for potential use in a supplemental station file
   ifsm_on = 0
   ifsm_off = 0
   dslc = ' '

   ! Output files
   datfout = .false. ! ~.datf file of flagged, re-identified arrival time data
   plogout = .false. ! ~.plog file output, phase identification debugging
   gccelout = .false. ! data file for GCCEL
   commentary_fname = ' '
   blocout = .false. ! data file for import into BAYESLOC
   sp_out = .false. ! .sp file for S-P data
   lres = 3.0 ! Threshold for large cluster residuals
   lresout = .true. ! .lres file for large cluster residuals
   outfile = 'default' ! Base-name for all output files
   verbose_screen = .false. ! Verbose screen mode (VSCR)
   verbose_taup = verbose_screen
   verbose_log = .false. ! Verbose logging mode (VLOG)
   debug = .false. ! Print debugging information
   nitomo = 0 ! Number of TOMO commands given, max = 10.
   subc_set = .false. ! Criteria for selection of subclusters have not been set
   subc_delt = 0.0 ! Default distance for selection of subclusters
   subc_nmin = 999 ! Default number of readings within default distance for selection of subclusters
   subc_nconnect = 999 ! Default number of onnected readings within default distance for selection of subclusters
   oldr_out = .false. ! Output for limited distance range (oldr)
   dist1 = 0. ! Minimum distance for oldr
   dist2 = 180. ! Max distance for oldr
   ttou = .false. ! Output of empirical TTs for specific phases
   n_ttou = 0 ! Number of phase-specific empirical TT output files
   ttou_phase = ' ' ! List of phases for empirical TT output files

   ! GMT plots
   gmtp = .true. ! Enable GMT plotting
   gmt_version = 6
   plot = .false.
   do i = 1,nevmax
      plot(i,0) = .true.
   end do
   reduced = .true. ! Use reduced velocities in type 6 and 7 TT plots
   splt = .false.
   eplt = .false.
   tt1 = .false.
   tt2 = .false.
   tt3 = .false.
   tt4 = .false.
   tt5 = .false.
   tt6 = .false.
   tt7 = .false.
   tt8 = .false.
   fault_map = .false.
   fault_map_filename = ' '
   n_fault_map = 0
   ellipse_plot = .false.
   n_ellipse = 0
   ellipse_data = 0.
   stat_plot = .false.
   n_stat = 0
   stat_data = 0.
   star_plot = .false.
   n_star = 0
   iev_star = 0
   star_size = 0.
   plot_dem1 = .false.
   plot_dem2 = .false.
   dem2_filename = ' '
   vectors = .true.
   fault_plot_style = '-Wthick,red'
   ishell = 1 ! bash shell
   n_xsec = 0
!   xsec_lat1 = 0.
!   xsec_lon1 = 0.
!   xsec_lat2 = 0.
!   xsec_lon2 = 0.
!   xsec_depth = 0.
!   xsec_width = 0.
   tt5s = .false.
   n_tt5s = 0
   tt5s_sta = '     '
   tt5e = .false.
   tt5e_all = .false.
   n_tt5e = 0
   tt5e_evt = ' '
   epa_plot = .false.
   n_epa_plot = 0
   fdhp = .false.
   rpth = .true.

   ! Window
   wind1 = 3.
   wind2 = 4.
   windloclim = 1.2 ! Windows are expanded at epicentral distances less than this

   ! P_ travel times
   p__a = 0. ! Intercept, in sec
   p__b = 19.0 ! Slope, in sec/degree
   p__min = 2.5 ! Minimum epicentral distance (degrees) at which Lg travel times will be calculated

   ! Lg travel times
   lg_a = 0. ! Intercept, in sec
   lg_b = 31.5 ! Slope, in sec/degree
   lg_min = 2.5 ! Minimum epicentral distance (degrees) at which Lg travel times will be calculated

   ! Rg travel times
   rg_a = 0. ! Intercept, in sec
   rg_b = 36.5 ! Slope, in sec/degree
   rg_min = 2.5 ! Minimum epicentral distance (degrees) at which Rg travel times will be calculated

   ! T-phase travel times
   tphase_a = 15. ! Intercept, in sec
   tphase_b = 75. ! Slope, in sec/degree

   ! Station statistics
   nkstat = 0
   kstat = 0
   n_dupe = 0
   n_dupe_minor = 0
   n_dupe_significant = 0
   n_miss_sta_total = 0
   n_miss_sta_list = ' '
   n_failed_date_range = 0
   duplication = ' '

   ! Convergence limits
   cl_epi_h = 0.005 ! Hypocentroid lat-lon, degrees
   cl_epi_c = 0.5 ! Cluster vector lat-lon, km
   cl_dep_h = 0.5 ! Hypocentroid depth, km
   cl_dep_c = 0.5 ! Cluster vector depth, km
   cl_ot_h = 0.1 ! Hypocentroid OT, sec
   cl_ot_c = 0.1 ! Cluster vector OT, sec
   convergence_test_index = 1 ! Selection of type of test for convergence
   
   ! Relative depth phases
   rdpp = .false.
   rdpp_all = .false.
   n_rdpp = 0
   rdpp_evt = ' '
   h_rdp1 = 1
   h_rdp2 = n_hrdp_max - 1
   z_hrdp = 0.
   z_test = 0.
   
   ! Phase residual plots
   phrp = .false.
   n_phrp = 0
   phrp_phase = ' '
   phrp_delt = 0.

   ! Miscellaneous
   mloc_author = 'default '
   basename = 'mloc' ! This will be replaced for specific clusters
   rderr_min_loc = 0.10 ! Minimum value allowed for reading errors at local distance, can be changed with MARE
   rderr_min = 0.15 ! Minimum value allowed for reading errors, for phases beyond local distance (except depth phases), can be changed with MARE
   rderr_min_depth = 1.0 ! Minimum value allowed for reading errors of teleseismic depth phases, can be changed with MARE
   rels_set = .false. ! Status of setting of reading errors for local stations (RELS)
   rderr_loc_p = 0.25 ! Reading error for P at local stations, can be changed with RELS
   rderr_loc_s = 0.40 ! Reading error for S at local stations, can be changed with RELS
   rderr_loc_delt = 0.6 ! Distance limit for applying comand RELS
   radius_cvff = 0. ! cluster vector fudge factor, km
   dcal_pr = 'off'
   direct_cal = .false.
   annotation = ' ' ! Event annotations
   kill_one = .false.
   kill_all = .false.
   kill_count = 0
   kill_reason = ' '
   value = 0
   longitude_range = 0
   idiff = 0 ! Differential time data indices
   diff_line = 0 ! Differential time data line numbers
   sta_author = '        '
   read_ad = .false. ! Do not use agency and deployment fields to resolve station code conflicts
   median_constrained_depths = -99.
   rescfd = -99.
   n_cfd = 0
   rmag = 0.
   n_radf = 0
   n_junk = 0
   junk_phase = ' '
   perturbation = 0.
   cv_perturb = .false.
   
   ! Configuration file
   inquire (file='mloc.conf',exist=ex)
   if (ex) then
      open (1,file='mloc.conf',status='old')
   else
      call oops ('mloc_main: the configuration file (mloc.conf) was not found')
   end if
   do
      line132 = ' '
      line = ' '
      read (1,'(a)',iostat=ios) line132
      if (ios .lt. 0) exit
      j = len_trim(line132)
      if (line132(1:13) .eq. 'WORKING_DIR: ') then
         mloc_path = line132(14:j) ! Absolute pathname to the directory containing the mloc executable
      else if (line132(1:16) .eq. 'STATION_MASTER: ') then
         station_master = line132(17:j) ! master station list
      else if (line132(1:9) .eq. 'GMT_VER: ') then
         read (line132(10:10),'(i1)') gmt_version
         if (gmt_version .eq. 6) then
            continue
         else if (gmt_version .eq. 5) then
            call fyi ('mloc_main: GMT v5 is still supported but it would be advisable to upgrade to v6 soon.')
         else
            write (msg,'(a,i1,a)') 'mloc_main: illegal value (', gmt_version, ') for GMT version (GMT v5 or v6 is required)'
            call oops (trim(msg))
         end if
      else if (line132(1:8) .eq. 'AUTHOR: ') then
         line = line132(9:j) ! ID for the person running mloc (maximum 8 characters)
         mloc_author = '        '
         if (len_trim(line) .le. 8) then
            mloc_author = trim(line)
         else
            mloc_author = line(1:8)
            write (msg,'(a,a8)') 'mloc_main: "mloc_author" truncated to 8 characters: ', mloc_author
            call warnings (trim(msg))
         end if
      else if (line132(1:7) .eq. 'SHELL: ') then
         line = line132(8:j)
         if (line(1:4) .eq. 'bash') then
            ishell = 1
         else if (line(1:3) .eq. 'csh') then
            ishell = 2
         else if (line(1:3) .eq. 'zsh') then
            ishell = 3
         else
            write (msg,'(2a)') 'mloc_main: unknown argument for the SHELL parameter in mloc.conf: ', trim(line132)
            call oops (trim(msg))
         end if
      else if (line132(1:8) .eq. 'SAMPLE: ') then
         call oops ('mloc_main: mloc.conf must be edited prior to running mloc!') 
      else
         write (msg,'(2a)') 'mloc_main: unknown keyword in mloc.conf: ', trim(line132)
         call oops (trim(msg))
      end if
   end do
   close (1)

   ! Interactive start
   write (*,'(/a/)') version
   write (*,'(a,3(/,t3,a,i5))') 'Current program limits: ', 'nevmax = ', nevmax, 'nqmax  = ', nqmax, 'ntmax1 = ', ntmax1
   write (*,'(/a)',advance='no') 'Enter a basename for this run: '
   read (*,'(a)') basename
   write (*,'(a)',advance='no') 'Enter the name of the data directory: '
   read (*,'(a)') datadir
   outfile = trim(datadir)//dirsym//trim(basename)
   
   ! Check if this basename already exists, open log file
   logfile = trim(outfile)//'.log'
   inquire (file=logfile,exist=ex)
   if (ex) then
      msg = 'mloc main: basename '//trim(basename)//' already exists; re-run and choose a new basename'
      call oops (trim(msg))
   else
      open (io_log,file=logfile,status='new')
   end if

   ! Control of mloc is based on the use of 'commands' which can be entered interactively or
   ! through a command file (which is itself called by an interactive command). Commands all
   ! have three or four letter codes. Some commands require additional parameters, some can
   ! take additional parameters as options, some take no additional parameters. Multiple
   ! command files can be invoked, iterspersed with interactive commands, until the 'run'
   ! command is given.

   write (*,'(/a,21(/t3,a))') 'The commands are:',&
    'anno',&
    'bdps bias bloc bptc',&
    'cal  cfil clim comm corr cptf ctyp cvff cvid cvtt',&
    'damp datf dbug dcal dem1 dem2 dep  diff',&
    'ellp epap eplt even',&
    'fdhp flag fmap frec freh',&
    'gcat gmtp',&
    'help hlim',&
    'ifsm inpu',&
    'kill',&
    'lat  lgtt lmod long lonr lres',&
    'mare memb',&
    'noxf nsmd',&
    'oldr',&
    'p_tt pert phid phrp phyp plog plot pltt ppri pttt',&
    'radf rdpp rels revi rfil rgtt rhdf rpth run ',&
    'secv shcl skip splt sstn star stat step stop subc',&
    'taup terr tfil tikh time tlog tomo tptt tt5e tt5s ttou',&
    'vect vlog vscr',&
    'weig wind',&
    'xsec'
 
   write (*,'(/t3,a)') 'For more information, follow the "help" command with a command name'
   write (*,'(/a/)') 'Enter commands:'
   write (*,'(a)',advance='no') ': '

   do ! Loop for interactive commands

      ! Read a line from a command file or interactive input
      if (cmndfil) then ! Reading from a command file
         read (io_cfil,'(a)',iostat=ios) line
         if (ios .ge. 0) then
            if (line(1:1) .eq. '!') cycle ! alternative to the COMM command
            if (line(1:1) .eq. '#') cycle ! alternative to the COMM command
            call parse (line, comd, params)
         else
            cmndfil = .false.
            close (io_cfil)
         
            ! Summary of killed events
            if (kill_count .gt. 0) then
               write (msg,'(a,i3,a)') 'mloc_main: ', kill_count, ' events from the command file were killed'
               call fyi (trim(msg))
            end if
         
            ! If the last event in the command file was killed by memb/kill, turn killing off now
            if (kill_one) kill_one = .false.
         
            write (*,'(/a/)') '  End of command file reached, continue with interactive commands:'
            write (*,'(a)',advance='no') ': '
         
            ! Interactive input
            read (*,'(a)') line
            call parse (line, comd, params)
         end if
      else ! Interactive input
         read (*,'(a)') line
         call parse (line, comd, params)
      end if
      
      ! Log the "inpu" argument for killed events
      if ((kill_one .or. kill_all) .and. comd .eq. 'inpu') then ! Keep track of killed events
         kill_count = kill_count + 1
         if (kill_one) then
            write (io_log,'(2a,1x,a)') 'killed ', trim(params), trim(kill_reason)
         else if (kill_all) then
            write (io_log,'(2a,1x,a)') 'killed ', trim(params), 'block kill'
         end if
      end if
      
      ! Skip all commands except 'kill' when doing a block kill
      if (kill_all .and. comd .ne. 'kill') cycle
   
      ! Skip all commands except 'memb' and 'kill' when killing a single event with the 'memb' command
      if (kill_one .and. comd .ne. 'memb' .and. comd .ne. 'kill') cycle
   
      ! Help system for specific commands
      command_help = .false.
      if (comd .eq. 'help' .and. params .ne. ' ') then
         comd = params(1:4)
         command_help = .true.
      end if
      
      ! Process commands
      if (comd .eq. 'anno') then
         call proc_anno (iev, command_help)
      else if (comd .eq. 'bdps') then
         call proc_bdps (command_help)
      else if (comd .eq. 'bias') then
         call proc_bias (command_help)
      else if (comd .eq. 'bloc') then
         call proc_bloc (command_help)
      else if (comd .eq. 'bptc') then
         call proc_bptc (command_help)
      else if (comd(1:3) .eq. 'cal') then
         call proc_cal (iev, comd, command_help)
      else if (comd .eq. 'ccat') then
         call warnings ('mloc_main: "ccat" has been replaced by "gcat"')
      else if (comd .eq. 'cfil') then
         call proc_cfil (cmndfil, command_help)
      else if (comd .eq. 'clim') then
         call proc_clim (command_help)
      else if (comd .eq. 'comm') then
         call proc_comm (command_help)
      else if (comd .eq. 'corr') then
         call proc_corr (command_help)
      else if (comd .eq. 'cptf') then
         call proc_cptf (command_help)
      else if (comd .eq. 'ctyp') then
         call proc_ctyp (command_help)
      else if (comd .eq. 'cvff') then
         call proc_cvff (command_help)
      else if (comd .eq. 'cvid') then
         call proc_cvid (command_help)
      else if (comd .eq. 'cvtt') then
         call proc_cvtt (command_help)
      else if (comd .eq. 'damp') then
         call proc_damp (command_help)
      else if (comd .eq. 'datf') then
         call proc_datf (command_help)
      else if (comd .eq. 'dbug') then
         call proc_dbug (command_help)
      else if (comd .eq. 'dcal') then
         call proc_dcal (command_help)
      else if (comd .eq. 'dem1') then
         call proc_dem1 (command_help)
      else if (comd .eq. 'dem2') then
         call proc_dem2 (command_help)
      else if (comd(1:3) .eq. 'dep') then
         call proc_dep (iev, comd, command_help)
      else if (comd .eq. 'diff') then
         call proc_diff (command_help)
      else if (comd .eq. 'ellp') then
         call proc_ellp (command_help)
      else if (comd .eq. 'epap') then
         call proc_epap (command_help)
      else if (comd .eq. 'eplt') then
         call proc_eplt (command_help)
      else if (comd .eq. 'even') then
         call proc_even (iev, command_help)
      else if (comd .eq. 'fdhp') then
         call proc_fdhp (command_help)
      else if (comd .eq. 'flag') then
         call proc_flag (command_help)
      else if (comd .eq. 'fmap') then
         call proc_fmap (command_help)
      else if (comd .eq. 'frec') then
         call proc_frec (iev, command_help)
      else if (comd .eq. 'freh') then
         call proc_freh (command_help)
      else if (comd .eq. 'gcat') then
         call proc_gcat (command_help)
      else if (comd .eq. 'gmtp') then
         call proc_gmtp (command_help)
      else if (comd .eq. 'help') then
         call proc_help (command_help)
      else if (comd .eq. 'hlim') then
         call proc_hlim (command_help)
      else if (comd .eq. 'ifsm') then
         call proc_ifsm (command_help)
      else if (comd .eq. 'inpu') then
         call proc_inpu (iev, command_help)
      else if (comd .eq. 'kill') then
         call proc_kill (command_help)
      else if (comd(1:3) .eq. 'lat') then
         call proc_lat (iev, command_help)
      else if (comd .eq. 'lgou') then
         call warnings ('mloc_main: "lgou" has been replaced by "ttou"')
      else if (comd .eq. 'lgtt') then
         call proc_lgtt (command_help)
      else if (comd .eq. 'lmod') then
         call proc_lmod (command_help)
      else if (comd .eq. 'long') then
         call proc_long (iev, command_help)
      else if (comd .eq. 'lonr') then
         call proc_lonr (command_help)
      else if (comd .eq. 'lres') then
         call proc_lres (command_help)
      else if (comd .eq. 'mare') then
         call proc_mare (command_help)
      else if (comd .eq. 'memb') then
         call proc_memb (iev, command_help)
      else if (comd .eq. 'noxf') then
         call proc_noxf (command_help)
      else if (comd .eq. 'nsmd') then
         call proc_nsmd (command_help)
      else if (comd .eq. 'oldr') then
         call proc_oldr (command_help)
      else if (comd .eq. 'outp') then
         call warnings ('mloc main: command "outp" is no longer needed')
      else if (comd .eq. 'p_tt') then
         call proc_p_tt (command_help)
      else if (comd .eq. 'pert') then
         call proc_pert (command_help)
      else if (comd .eq. 'phid') then
         call proc_phid (command_help)
      else if (comd .eq. 'phrp') then
         call proc_phrp (command_help)
      else if (comd .eq. 'phyp') then
         call proc_phyp (command_help)
      else if (comd .eq. 'plog') then
         call proc_plog (iev, command_help)
      else if (comd .eq. 'plot') then
         call proc_plot (iev, command_help)
      else if (comd .eq. 'pltt') then
         call proc_pltt (command_help)
      else if (comd .eq. 'ppri') then
         call proc_ppri (command_help)
      else if (comd .eq. 'pttt') then
         call proc_pttt (command_help)
      else if (comd .eq. 'radf') then
         call proc_radf (command_help)
      else if (comd .eq. 'rdpp') then
         call proc_rdpp (command_help)
      else if (comd .eq. 'rels') then
         call proc_rels (command_help)
      else if (comd .eq. 'revi') then
         call proc_revi (command_help)
      else if (comd .eq. 'rfil') then
         call proc_rfil (command_help)
      else if (comd .eq. 'rgtt') then
         call proc_rgtt (command_help)
      else if (comd .eq. 'rhdf') then
         call proc_rhdf (command_help)
      else if (comd .eq. 'rpth') then
         call proc_rpth (command_help)
      else if (comd(1:3) .eq. 'run') then
         call proc_run (cmndfil, command_help)
         if (.not.command_help) exit ! Leave the interactive command loop and start the run
      else if (comd .eq. 'secv') then
         call proc_secv (command_help)
      else if (comd .eq. 'shcl') then
         call proc_shcl (command_help)
      else if (comd .eq. 'skip') then
         call proc_skip (command_help)
      else if (comd .eq. 'splt') then
         call proc_splt (command_help)
      else if (comd .eq. 'sstn') then
         call proc_sstn (command_help)
      else if (comd .eq. 'star') then
         call proc_star (iev, command_help)
      else if (comd .eq. 'stat') then
         call proc_stat (command_help)
      else if (comd .eq. 'step') then
         call proc_step (command_help)
      else if (comd .eq. 'subc') then
         call proc_subc (command_help)
      else if (comd .eq. 'stop') then
         call proc_stop (command_help)
      else if (comd .eq. 'taup') then
         call proc_taup (command_help)
      else if (comd .eq. 'terr') then
         call proc_terr (command_help)
      else if (comd .eq. 'tfil') then
         call proc_tfil (command_help)
      else if (comd .eq. 'tikh') then
         call proc_tikh (command_help)
      else if (comd .eq. 'time') then
         call proc_time (iev, command_help)
      else if (comd .eq. 'tlog') then
         call proc_tlog (command_help)
      else if (comd .eq. 'tomo') then
         call proc_tomo (command_help)
      else if (comd .eq. 'topo') then
         call warnings ('mloc_main: "topo" has been replaced by "dem1"')
         call proc_dem1 (command_help)
      else if (comd .eq. 'tpou') then
         call warnings ('mloc_main: "tpou" has been replaced by "ttou"')
      else if (comd .eq. 'tptt') then
         call proc_tptt (command_help)
      else if (comd .eq. 'tt5e') then
         call proc_tt5e (command_help)
      else if (comd .eq. 'tt5s') then
         call proc_tt5s (command_help)
      else if (comd .eq. 'ttou') then
         call proc_ttou (command_help)
      else if (comd .eq. 'vect') then
         call proc_vect (command_help)
      else if (comd .eq. 'vlog') then
         call proc_vlog (command_help)
      else if (comd .eq. 'vscr') then
         call proc_vscr (command_help)
      else if (comd .eq. 'weig') then
         call proc_weig (command_help) 
      else if (comd .eq. 'wind') then
         call proc_wind (command_help)      
      else if (comd .eq. 'xsec') then
         call proc_xsec (command_help)      
      else
         call warnings ('mloc_main: '//comd//' not found')
      end if

      if (.not.cmndfil) write (*,'(a)',advance='no') ': '
   
   end do
   
   write (*,'(/a/)') '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'

   write (msg,'(a,i3,a)') 'mloc_main: ', nev, ' events will be relocated'
   call fyi (trim(msg))
   
   ! Turn off ~.lres output file for a single event
   if (nev .eq. 1) lresout = .false.

   ! Make a directory for the GMT scripts
   gmt_script_dir = trim(datadir)//dirsym//trim(basename)//'_gmt_scripts'
   command_line = 'mkdir '//trim(gmt_script_dir)
   call system (trim(command_line))

   ! Check for necessary file specifications
   do jev = 1,nev
      if (infile(jev)(1:1) .eq. ' ') then
         write (msg,'(a,i3)') 'mloc_main: no input file specified for event ', jev
         call oops (trim(msg))
      end if
   end do
   
   ! Open the LRES file
   if (lresout) then
      outfil = trim(outfile)//'.lres'
      open (io_lres,file=outfil,status='new')
      inquire (unit=io_lres,opened=op)
      if (op) then
         write (io_lres,'(f6.2)') lres
         if (verbose_screen) then
            write (msg,'(3a)') 'mloc_main: ', trim(outfil), ' was opened'
            call fyi (trim(msg))
         end if
      else
         call oops ('mloc_main: file '//trim(outfil)//' was not opened')
      end if
   end if

   ! Log convergence limits
   write (io_log,'(/a)') 'Convergence limits'
   write (io_log,'(a,f6.3,a,2(f4.1,a))') 'Hypocentroid: ', cl_epi_h, ' (deg), ', cl_dep_h, '(km), ', cl_ot_h, ' (sec)'
   write (io_log,'(a,3(f4.1,a))') 'Cluster vectors: ', cl_epi_c, ' (km),  ', cl_dep_c, '(km), ', cl_ot_c, ' (sec)'
   
   ! Log the local velocity model
   if (locmod) then 
      open (io_locmod,file=trim(locmodfname),status='old')
      write (io_log,'(/2a)') 'Local velocity model: ', trim(locmodfname)
      ! Epicentral range line
      read (io_locmod,'(a)',iostat=ios) line34
      write (io_log,'(a)') line34
      ! Layer lines
      do
         read (io_locmod,'(a)',iostat=ios) line34
         if (ios .lt. 0) exit
         write (io_log,'(a)') line34
      end do
      close (io_locmod)
   end if

   ! Log file for phase reidentification
   if (phid .and. plogout) then
      plog_file = trim(outfile)//'.plog'
      open (io_plog,file=plog_file,status='new')
      inquire (file=plog_file,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(plog_file)//' was not opened!')
   end if

   ! Log file for station data
   stn_log_file = trim(outfile)//'.stn'
   open (io_stn_log,file=stn_log_file,status='new')
   inquire (file=stn_log_file,opened=op)
   if (.not.op) call oops ('mloc_main: file '//trim(stn_log_file)//' was not opened')
   
   ! Log file for tau-p intermediate results
   if (log_taup) then
      taup_file = trim(outfile)//'.taup'
      open (io_taup_log,file=taup_file,status='new')
      inquire (file=taup_file,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(taup_file)//' was not opened!')
   end if

   ! Skipped stations
   if (n_skip .gt. 0) then
      do i = 1,n_skip
         if (skip_params(i,1) .ne. '*') write (io_stn_log,'(a,1x,a,1x,a,1x,a)') 'skipping station ', (skip_params(i,j),j=1,3)
      end do
   end if
   
   ! Supplemental station files
   if (n_supp_stn_file .gt. 0) then
      write (io_stn_log,'(a)') 'Supplemental station files: '
      do i = 1,n_supp_stn_file
         write (io_stn_log,'(a,i1,1x,a)') 'SSTN-', i, trim(suppfilnam(i))
      end do
   end if
   
   ! NEIC station metadata
   If (nsmd) then
      filename = trim(station_path)//dirsym//trim(nsmd_file)
      open (io_nsmd,file=filename,status='old')
      inquire (file=filename,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(filename)//' was not opened')
      i = 0
      do
         if (i .gt. n_nsmd_max) then
            write (msg,'(a,i8)') 'main: maximum number of NEIC station metadata entries read: ', n_nsmd_max
            call warnings (trim(msg))
            exit
         end if
         read (io_nsmd,'(a)',iostat=ios) line102
         if (ios .lt. 0) exit
         i = i + 1
         nsmd_line(i) = line102
         dslc(i) = line102(1:2)//line102(4:8)//line102(10:11)//line102(13:15) ! Deployment, Station Code, Location, Channel
         if (line102(63:63) .eq. '.') then
            read (line102(66:75),'(i4,1x,i2,1x,i2)') year_oe1, month_oe1, day_oe1
            read (line102(86:95),'(i4,1x,i2,1x,i2)') year_oe2, month_oe2, day_oe2
         else if (line102(64:64) .eq. '.') then
            read (line102(67:76),'(i4,1x,i2,1x,i2)') year_oe1, month_oe1, day_oe1
            read (line102(87:96),'(i4,1x,i2,1x,i2)') year_oe2, month_oe2, day_oe2
         else
            write (msg,'(3a,i8)') 'mloc_main: Error reading ', trim(filename), ' line ', i
         end if         
         call juldat (year_oe1, month_oe1, day_oe1, jdate, 0)
         nsmd_on(i) = year_oe1*1000 + jdate
         call juldat (year_oe2, month_oe2, day_oe2, jdate, 0)
         nsmd_off(i) = year_oe2*1000 + jdate
         if (verbose_log) write (io_log,'(a,2i8)') dslc(i), nsmd_on(i), nsmd_off(i)
      end do
      n_nsmd_read = i
      write (msg,'(a,i8,a)') 'mloc_main: ', n_nsmd_read, ' NEIC station metadata entries read: '
      call fyi (trim(msg))
      close (io_nsmd)
      ! Open a new file for the selected station entries
      nsmd_stn_file = trim(outfile)//'_nsmd_stn.dat'
      open (io_nsmd,file=nsmd_stn_file,status='new')
      inquire (file=nsmd_stn_file,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(nsmd_stn_file)//' was not opened')
      write (io_nsmd,'(a)') '5 Supplemental station file from NEIC Station Metadata'
   end if
   
   ! ISC-FDSN station metadata
   If (ifsm) then
      filename = trim(station_path)//dirsym//trim(ifsm_file)
      open (io_ifsm,file=filename,status='old')
      inquire (file=filename,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(filename)//' was not opened')
      read (io_ifsm,'(a)') line94 ! First line is the file creation date    
      i = 0
      do
         if (i .gt. n_ifsm_max) then
            write (msg,'(a,i8)') 'mloc_main: maximum number of ISC-FDSN station metadata entries read: ', n_ifsm_max
            call warnings (trim(msg))
            exit
         end if
         read (io_ifsm,'(a)',iostat=ios) line94
         if (ios .lt. 0) exit
         i = i + 1
         ifsm_line(i) = line94
         ds(i) = line94(2:3)//line94(5:9) ! Deployment, Station Code
		 if (line94(49:49) .ne. ' ') then
		    read (line94(49:58),'(i4,1x,i2,1x,i2)') year_oe1, month_oe1, day_oe1
		 else
		    year_oe1 = 1900
		    month_oe1 = 1
		    day_oe1 = 1
		 end if
		 if (line94(75:75) .ne. ' ') then
		    read (line94(75:84),'(i4,1x,i2,1x,i2)') year_oe2, month_oe2, day_oe2
		 else
		    year_oe2 = 2099
		    month_oe2 = 12
		    day_oe2 = 31
		 end if
         call juldat (year_oe1, month_oe1, day_oe1, jdate, 0)
         ifsm_on(i) = year_oe1*1000 + jdate
         call juldat (year_oe2, month_oe2, day_oe2, jdate, 0)
         ifsm_off(i) = year_oe2*1000 + jdate
         if (verbose_log) write (io_log,'(a,2i8)') ds(i), ifsm_on(i), ifsm_off(i)
      end do
      n_ifsm_read = i
      write (msg,'(a,i8,a)') 'mloc_main: ', n_ifsm_read, ' ISC-FDSN station metadata entries read: '
      call fyi (trim(msg))
      close (io_ifsm)
      ! Open a new file for the selected station entries
      ifsm_stn_file = trim(outfile)//'_ifsm_stn.dat'
      open (io_ifsm,file=ifsm_stn_file,status='new')
      inquire (file=ifsm_stn_file,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(ifsm_stn_file)//' was not opened')
      write (io_ifsm,'(a)') '3 Supplemental station file from ISC-FDSN Station Metadata'
   end if

   ! Phase-specific default reading errors
   filename = trim(psdre_path)//dirsym//trim(psdre_file)
   inquire (file=filename,exist=ex)
   if (ex) then
      io_psdre = lunit()
      open (io_psdre,file=filename,status='old')
      i = 0
      do
         read (io_psdre,'(a)',iostat=ios) line12
         if (ios .ge. 0) then
            i = i + 1
            if (i .le. n_psdre_max) then
               psdre_phase(i) = line12(1:8) 
               read (line12(10:12),'(f3.1)') psdre(i)
            else
               call warnings ('mloc_main: maximum number of phase-specific default reading errors reached')
               n_psdre = i - 1
               exit
            end if
         else ! EOF
            n_psdre = i
            exit
         end if
      end do
      close (io_psdre)
      if (verbose_screen) then
         write (msg,'(a,i2,a)') 'mloc_main: ', n_psdre, ' phase-specific default reading errors read'
         call fyi (trim(msg))
      end if
   else
      call oops ('mloc_main: '//trim(filename)//' not found')
   end if
   
   ! Topography file used for bounce point corrections (pP, sP, pwP)
   filename = trim(bp_path)//dirsym//trim(bp_file)
   inquire (file=filename,exist=ex)
   if (ex) then
      io_bp = lunit()
      open (io_bp,file=filename,form='formatted',status='old')
      do j = 1,bp_nlat
         read (io_bp,'(4321i7)') (bp_topo(i,j),i=1,bp_nlon)
      end do
      close(io_bp)
      if (verbose_screen) call fyi ('mloc_main: bounce point topography data read from '//trim(filename))
   else
      call oops ('mloc_main: '//trim(filename)//' not found')
   end if
   
   ! Bounce point correction log file
   if (bptc) then
      bptc_log_file = trim(outfile)//'.bptc'
      open (io_bptc_log,file=bptc_log_file,status='new')
      inquire (file=bptc_log_file,opened=op)
      if (.not.op) call oops ('mloc_main: file '//trim(bptc_log_file)//' was not opened')
   end if
   
   ! Relative depth phase plots when the "all" argument is given
   if (rdpp_all) then
      n_rdpp = nev
      do iev = 1,nev
         rdpp_evt(iev) = evtnam(iev)
      end do
   end if
   
   ! tt5e plots when the "all" argument is given
   if (tt5e_all) then
      n_tt5e = nev
      do iev = 1,nev
         tt5e_evt(iev) = evtnam(iev)
      end do
   end if   
   
   ! Junk phase list
   filename = trim(phases_path)//dirsym//trim(junk_phases_file)
   open (io_junk,file=filename,form='formatted',status='old')
   inquire (file=filename,opened=op)
   if (.not.op)  then
      call warnings ('mloc_main: file '//trim(filename)//' was not opened; no filtering of junk phases will be done')
      n_junk = 0
   else
      do
        read (io_junk,'(a)',iostat=ios) line8
        if (ios .lt. 0) exit
        n_junk = n_junk + 1
        if (n_junk .gt. n_junk_max) then
           call warnings ('mloc_main: too many junk phases read; increase n_junk_max')
           n_junk = n_junk -1
           exit
        end if
        junk_phase(n_junk) = trim(line8)
      end do
      close (io_junk)
      if (verbose_screen) then
         write (msg,'(a,i3,a)') 'mloc_main: ', n_junk, ' junk phases read from '//trim(filename)
         call fyi (trim(msg))
      end if
   end if
  
   ! Set up forward problem and do linearized inversion
   call mlocset
   close (io_log)
   close (io_stn_log)
   close (io_taup)
   if (nsmd) close (io_nsmd)
   if (phid .and. plogout) close (io_plog)
   if (log_taup) close (io_taup_log)  
      
   write (*,'(/a/)') '*** Run completed ***'

   ! Catch any files still open
   do luopen = 10,40
      inquire (luopen,opened=op)
      if (op) then
         inquire (luopen,name=open_file_name)
         write (msg,'(a,i2,1x,a)') 'mloc_main: file still open on logical unit ', luopen, trim(open_file_name)
         call fyi (trim(msg))
         close (luopen)
      end if
   end do

   stop
   
end program mloc

!***********************************************************************************************************************************
block data mloc_init

   include 'mloc.inc'
   include 'ttlim.inc'

   data version /'mloc v10.6.3, release date October 18, 2023'/

   ! Logical unit numbers for I/O
   data io_taup /11/ ! .hed and .tbl files (ak135)
   data io_rderr /12/ ! .rderr (reading errors file)
   data io_gmt /14/ ! GMT scripts
   data io_xdat /15/ ! .xdat file
   data io_in /16/ ! Event data files
   data io_cfil/17/ ! command file
   data io_log /19/ ! log file
   data io_pdf /20/ ! Probability density function file
   data io_locmod /21/ ! Custom crustal velocity model
   data io_dat0 /22/ ! .dat0 file
   data io_datf /23/ ! .datf file
   data io_lres /24/ ! .lres file (large cluster residuals)
   data io_out /25/ ! Used for several output files
   data io_cal /26/ ! .cal file
   data io_diffdat /27/ ! Differential time data
   data io_rhdf /28/ ! HDF file to set starting locations
   data io_depth_phase /30/ ! depth phases output
   data io_ttsprd /31/ ! .ttsprd file
   data io_plog /32/ ! phase reidentification log
   data io_stn_log /33/ ! station data log
   data io_bdp /36/ ! Bad depth phase station list
   data io_bptc_log /37/ ! Bounce point correction log file
   data io_gccel /38/ ! GCCEL output
   data io_oldr /39/ ! Output for limited distance range
   data io_bayes /40/ ! BAYESLOC output
   data io_tt /41/ ! Empirical TT data for specific phases
   data io_taup_log /42/ ! Log file for tau-p debugging
   data io_junk /43/ ! Input file of junk phase names that will not be read
   data io_dpnc /44/ ! Output file for depth phase name changes
   data io_nsmd /45/ ! NEIC station metadata file
   data io_ifsm /46/ ! ISC-FDSN station metadata file

end
