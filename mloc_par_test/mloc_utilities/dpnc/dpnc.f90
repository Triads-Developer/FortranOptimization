program dpnc

! Change the names of depth phases, based on a ~.dpnc output file from a run of mloc.

   implicit none

   integer, parameter :: line_max = 20000 ! Maximum number fo lines in an MNF file
   integer :: iev, imnf0, nline, i, ios
   character(len=20) :: infile0
   character(len=5) :: stname0, stname
   character(len=8) :: phase0, phase, readsrc0, readsrc, phase_new
   character(len=110) :: filein, command_line
   character(len=121) :: buffer(line_max), line

   write (*,'(a/)') 'Release date May 8, 2021'

   write (*,'(a)',advance='no') ' DPNC file: '
   read (*,'(a)') filein
   open (8,file=filein,status='old')

   do
      read (8,'(i3,1x,a5,1x,a8,1x,a8,1x,i5,1x,a8,1x,a20)',iostat=ios) iev, stname0,&
       readsrc0, phase0, imnf0, phase_new, infile0
      if (ios .lt. 0) exit
      print *, iev, stname0, readsrc0, phase0, imnf0, phase_new, infile0
   
      ! Do not process differential time data (imnf0 = 0)
      if (imnf0 .eq. 0) cycle
   
      ! Read all lines into buffer
      open (9,file=trim(infile0),status='old')
      nline = 0
      do
         read (9,'(a)',iostat=ios) line
         if (ios .lt. 0) exit
         nline = nline + 1
         buffer(nline) = line
         if (nline .eq. line_max) then
            write (*,'(//a,i5,a)') 'Maximum number of lines (', line_max, ') reached!'
            close (8)
            close (9)
            stop
         end if
      end do
      write (*,'(i4,2a)') nline, ' lines read from ', infile0
      close (9)
      
      ! Check that it is the right line
      if (imnf0 .gt. nline) then
         write (*,'(a,3i5, a20)') 'imnf0 larger than nline: ', imnf0, nline, iev, infile0
         close (8)
         stop
      end if         
      if (buffer(imnf0)(5:9) .ne. stname0 .or.&
          buffer(imnf0)(24:31) .ne. phase0 .or.&
          buffer(imnf0)(103:110) .ne. readsrc0) then
         write (*,'(a,i3,1x,a6,2(1x,a8),1x,i4)') 'Not found: ', iev, stname0, readsrc0, phase0, imnf0
         cycle
      end if
   
      ! Edit the appropriate line of the buffer, delete the original data file, write a new one from the buffer
	  if (phase_new(1:4) .eq. 'pP-P') then
		 buffer(imnf0)(24:31) = phase_new(1:2)//'      '
	  else if (phase_new(1:4) .eq. 'sP-P') then
		 buffer(imnf0)(24:31) = phase_new(1:2)//'      '
	  else if (phase_new(1:3) .eq. 'pwP') then
		 buffer(imnf0)(24:31) = phase_new(1:3)//'     '
	  end if         
	  write (*,'(a)') buffer(imnf0)
	  command_line = 'rm '//trim(infile0)
	  call system (trim(command_line))
	  open (9,file=trim(infile0),status='new')
	  do i = 1,nline
		 write (9,'(a)') buffer(i)
	  end do
	  close (9)
              
   end do

   close (8)
        
   stop
   
end program dpnc
        