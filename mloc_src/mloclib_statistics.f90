!***********************************************************************************************************************************
subroutine sort (n, ra)

! Heapsort, from Numerical Recipes p. 231

   implicit none

   real :: ra(n), rra
   integer :: n, l, ir, i, j

   l = n/2 + 1
   ir = n
10 continue
   if (l .gt. 1) then
      l = l - 1
      rra = ra(l)
   else
      rra = ra(ir)
      ra(ir) = ra(1)
      ir = ir -1
      if (ir .eq. 1) then
         ra(1) = rra
         return
      end if
   end if
   i = l
   j = l + l
20 if (j .le. ir) then
      if (j .lt. ir) then
         if (ra(j) .lt. ra(j+1)) j = j + 1
      end if
      if (rra .lt. ra(j)) then
         ra(i) = ra(j)
         i = j
         j = j + j
      else
         j = ir + 1
      end if
      go to 20
   end if
   ra(i) = rra
   go to 10

end subroutine sort


!***********************************************************************************************************************************
subroutine mdian1 (x, n, xmed)

! Median, from Numerical Recipes, p. 460

   implicit none
      
   real :: x(n), xmed
   integer :: n, n2

   call sort (n,x)
   n2 = n/2
   if (2*n2 .eq. n) then
      xmed = 0.5*(x(n2) + x(n2 + 1))
   else
      xmed = x(n2 + 1)
   end if

   return
   
end subroutine mdian1


!***********************************************************************************************************************************
subroutine fstat1 (nu1, nu2, p0, f)

!  Returns F(nu1,nu2) for confidence level p0.  This value of F will be
!  exceeded with a probability of 1-p0.
!  This version of fstat is the original one used since the initial coding of mloc

   implicit none
   
   real :: p(101), p0, f, a1, a2, xnu1, xnu2, factor, diff, ftest, x, betai
   integer :: nu1, nu2, i, j
   character(len=132) :: msg

   a1=real(nu1)/2.
   a2=real(nu2)/2.
   xnu1=real(nu1)
   xnu2=real(nu2)
   f=1.
   factor=1.
   diff=1.
   do while (diff .gt. .001)
      do i=0,100
         ftest=f+(i*factor)
         x=xnu2/(xnu2+(xnu1*ftest))
         if (x .lt. 0. .or. x .gt. 1.) then
            write (msg,'(4(a,f10.3,2x))') 'fstat1: x = ', x, 'xnu2 = ', xnu2, 'xnu1 = ',&
             xnu1, 'ftest = ', ftest
            call warnings (msg)
         end if
         p(i+1)=1.-betai(a2, a1, x)
      end do
      call locate (p, 101, p0, j)
      if (j .lt. 101) then
         diff=abs(p0-p(j))
         f=f+((j-1)*factor)
!          write (19,'(i3,4(1x,f10.4))') j, factor, p(j), diff, f
         factor=factor*0.01
      else
!          write (19,'(a)') ' j =101'
         factor=factor*100.                                       
      end if
   end do

   return
   
end subroutine fstat1


!***********************************************************************************************************************************
subroutine fstat2 (nu1, nu2, p0, f)

!  Returns F(nu1,nu2) for confidence level p0.  This value of F will be
!  exceeded with a probability of 1-p0.
! This version of fstat uses a different package of functions to calculate the incomplete 
! beta function, by EAB 8/28/2023.

   implicit none
   
   real :: p(101), p0, f, a1, a2, xnu1, xnu2, factor, diff, ftest, x, r4_betai
   integer :: nu1, nu2, i, j
   character(len=132) :: msg

   a1=real(nu1)/2.
   a2=real(nu2)/2.
   xnu1=real(nu1)
   xnu2=real(nu2)
   f=1.
   factor=1.
   diff=1.
   do while (diff .gt. .001)
      do i=0,100
         ftest=f+(i*factor)
         x=xnu2/(xnu2+(xnu1*ftest))
         if (x .lt. 0. .or. x .gt. 1.) then
            write (msg,'(4(a,f10.3,2x))') 'fstat2: x = ', x, 'xnu2 = ', xnu2, 'xnu1 = ',&
             xnu1, 'ftest = ', ftest
            call warnings (msg)
         end if
         p(i+1)=1.-r4_betai(x, a2, a1)
      end do
      call locate (p, 101, p0, j)
      if (j .lt. 101) then
         diff=abs(p0-p(j))
         f=f+((j-1)*factor)
!          write (19,'(i3,4(1x,f10.4))') j, factor, p(j), diff, f
         factor=factor*0.01
      else
!          write (19,'(a)') ' j =101'
         factor=factor*100.                                       
      end if
   end do

   return
   
end subroutine fstat2


!***********************************************************************************************************************************
subroutine locate (xx, n, x, j)
      
   implicit none

   real :: xx(n), x
   integer :: n, j, jl, ju, jm

   jl = 0
   ju = n + 1
10 if (ju-jl .gt. 1) then
      jm = (ju+jl)/2
      if ((xx(n) .gt. xx(1)) .eqv. (x .gt. xx(jm))) then   
         jl = jm
      else
         ju = jm
      end if
      go to 10   
   end if
   j = jl

   return
   
end subroutine locate


!***********************************************************************************************************************************
real function gammln (xx)

   implicit none

   double precision :: cof(6), stp, half, one, fpf, x, tmp, ser
   real :: xx
   integer :: j

   data cof,stp/76.18009173d0,-86.50532033d0,24.01409822d0, -1.231739516d0,.120858003d-2,-.536382d-5,2.50662827465d0/
   data half,one,fpf/0.5d0,1.0d0,5.5d0/

   x = xx - one
   tmp = x + fpf
   tmp = (x+half)*log(tmp) - tmp
   ser = one
   do j = 1,6
      x = x + one
      ser = ser + cof(j)/x
   end do
   gammln = sngl(tmp + log(stp*ser))

   return
   
end function gammln


!***********************************************************************************************************************************
real function betai (a, b, x)

! Incomplete beta function, based on BETAI (Section 6.3, Numerical Recipes). Modified to
! avoid FPU exceptions, equality tests for real numbers, etc.
      
   implicit none
      
   real :: a, b, x, bt, gammln, betacf, arg, eps
!   real, parameter :: eps = 3.e-7
   character(len=132) :: msg
   
   eps = 2.*epsilon(x)

   ! a,b > 0
   if (a .lt. eps .or. b .lt. eps .or. x .lt. 0. .or. x .gt. 1.) then
      write (msg,'(a,3e12.4)') 'betai: bad argument: a, b, x = ', a, b, x
      call oops (trim(msg))
   end if
   if (x .lt. eps .or. (1.-x) .lt. eps) then
      bt = 0.
   else
      arg = gammln(a+b) - gammln(a) - gammln(b) + a*log(x) + b*log(1.-x)
      if (arg .lt. -10.) then
         bt = 0.
      else
         bt = exp(arg)
      end if
   end if
   if (x .lt. (a + 1.)/(a + b + 2.)) then
      betai = bt*betacf(a,b,x)/a
   else
      betai = 1. - bt*betacf(b,a,1.-x)/b
   end if
   
   return

end function betai


!***********************************************************************************************************************************
real function betacf (a, b, x)

! Continued fraction for incomplete beta function, based on BETACF (section 6.3 of Numerical
! Recipes). Modified from original code to deal better with pathological situations, i.e.,
! failure to converge.

   implicit none
   
   integer, parameter :: itmax = 200
!   real, parameter :: eps = 3.e-7
   character(len=132) :: msg
   
   real :: a, b, x, am, bm, az, qab, qap, qam, bz, em, tem, d, ap, bp, app, bpp, aold, eps
   integer :: m
   
   eps = 2.*epsilon(x)

   am = 1.
   bm = 1.
   az = 1.
   qab = a + b
   qap = a + 1.
   qam = a - 1.
   bz = 1. - qab*x/qap
   do m = 1,itmax
      em = real(m)
      tem = em + em
      d = em*(b-em)*x/((qam+tem)*(a+tem))
      ap = az + d*am
      bp = bz + d*bm
      d = -(a+em)*(qab+em)*x/((a+tem)*(qap+tem))
      app = ap + d*az
      bpp = bp + d*bz
      aold = az
      am = ap/bpp
      bm = bp/bpp
      az = app/bpp
      bz = 1.
      betacf = az
      if (abs(az-aold) .lt. eps*abs(az)) return
   end do
   
   write (msg,'(a,3f10.3,2e10.3)') 'betacf: ', a, b, x, betacf, aold
   call logit (trim(msg))
   call warnings ('betacf: a or b too big, or itmax too small; check the log file for details')

   return
   
end function betacf


!***********************************************************************************************************************************
subroutine moment2 (data_in, n, adev, sdev)

! Basic statistical parameters for an input array. Adapted from
! Numerical Recipes subroutine MOMENT
      
   implicit none
   
   integer :: n, j 
   real :: data_in(n), s, ave, var, p, sdev, adev
   character(len=132) :: msg
   
   if (n .le. 1) then
      write (msg,'(a,i6)') 'moment2: illegal value for n: ', n
      call warnings (trim(msg))
      adev = 1.0
      sdev = 1.0
      return
   end if 
   
   s = 0.
   do j = 1,n
      s = s + data_in(j)
   end do
   
   ave=s/n
   adev=0.
   var=0.
   do j = 1,n
      s = data_in(j) - ave
      adev = adev + abs(s)
      p = s*s
      var = var + p
   end do
   adev = adev/n
   var = var/(n-1)
   sdev = sqrt(var)
   
   return
   
end subroutine moment2


!***********************************************************************************************************************************
subroutine croux (x, nin, sn)

! Implementation of the "naive" algorithm for Sn in:
! "Time Efficient algorithms for two highly robust estimators of scale" by Croux & Rousseuw
! Computational Statistics, V1 (1992), Dodge and Whittaker, ed., Physica-Verlag, Heidleberg, pp. 411-428.
! Sn is a robust estimator for the spread of a sample distribution that does not need an estimate
! of central location. It is well-behaved even with small sample size.

! The original formulation behaves badly with n=3 and two values close to each other. 
! the trivial difference (i = j) always yeilds a zero value and if one of the other
! differences is also small, the estimate of Sn implodes. After consulting
! Christophe Croux, I altered the algorithm for n=3 so that the inner loop takes the
! average instead of the lomed of the three differences.

! It follows that the constant cn(3) should be recalculated. I did the same experiment as
! reported in Croux & Rousseuw with the new algorithm and found cn(3) = 1.172.
      
   implicit none
   
   integer, parameter :: nmax = 1000 ! Maximum size of input array "x"
   
   integer :: i, j, n, nin, ihimed, ilomed, indx(nmax)
   real :: a1(nmax), a2(nmax), sn, cn, x(nin)
   character(len=132) :: msg
   external cn
   
   if (nin .le. nmax .and. nin .ge. 2) then
      n = nin
   else if (nin .lt. 2) then
      write (msg,'(a,i6)') 'croux: illegal value for n: ', nin
      call warnings (trim(msg))
      sn = 1.0
      return   
   else if (nin .gt. nmax) then
      write (msg,'(a,i6)') 'croux: nin exceeds maximum value, set to ', nmax
      call fyi (trim(msg))
      n = nmax
   end if
   
   ! Equation 1
   do i = 1,n
      do j = 1,n
         a1(j) = abs(x(i) - x(j))
      end do
      call indexx(n, a1, indx)
      ihimed = indx((n/2)+1)
      a2(i) = a1(ihimed)
      if (n .eq. 3) a2(i) = (a1(1)+a1(2)+a1(3))/3.
   end do
   
   call indexx(n, a2, indx)
   ilomed = indx((n+1)/2)
   sn = cn(n)*1.1926*a2(ilomed)
   
   return
   
end subroutine croux
      
      
!*****************************************************************************************
real function cn (n)

! Small sample correction terms for subroutine croux
      
   implicit none
   
   integer :: n
   
   if (n .eq. 2) then
      cn = 0.743
   else if (n .eq. 3) then
      ! cn = 1.851   
      cn = 1.172 ! Special correction for modified algorithm using average of differences
   else if (n .eq. 4) then
      cn = 0.954
   else if (n .eq. 5) then
      cn = 1.351
   else if (n .eq. 6) then
      cn = 0.993
   else if (n .eq. 7) then
      cn = 1.198
   else if (n .eq. 8) then
      cn = 1.005
   else if (n .eq. 9) then
      cn = 1.131
   else if (n .ge. 10) then
      if (mod(n,2) .eq. 0) then ! n even
         cn = 1.
      else ! n odd
         cn = real(n)/(real(n)-0.9)
      end if
   else
      cn = 1.
   end if
   
   return
   
end function cn


!*****************************************************************************************
function r4_betai ( x, pin, qin )

!! R4_BETAI evaluates the incomplete beta ratio of R4 (single precision) arguments.
!
!  Discussion:
!
!    The incomplete Beta function ratio is the probability that a
!    random variable from a beta distribution having parameters
!    P and Q will be less than or equal to X.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Nancy Bosten, EL Battiste,
!    Remark on Algorithm 179: 
!    Incomplete Beta Ratio,
!    Communications of the ACM,
!    Volume 17, Number 3, March 1974, pages 156-157.
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real X, the upper limit of integration.
!    0.0 <= X <= 1.0.
!
!    Input, real PIN, the first distribution parameter.
!    0.0 < PIN.
!
!    Input, real QIN, the second distribution parameter.
!    0.0 < QIN.
!
!    Output, real R4_BETAI, the incomplete beta function ratio.
!
  implicit none

  real alneps
  real alnsml
  real c
  real eps
  real finsum
  integer i
  integer ib
  integer n
  real p
  real p1
  real pin
  real ps
  real q
  real qin
  real r4_betai
  real r4_lbeta
  real r4_mach
  real sml
  real term
  real x
  real xb
  real y
  character(len=132) :: msg

  save alneps
  save alnsml
  save eps
  save sml

  data alneps / 0.0E+00 /
  data alnsml / 0.0E+00 /
  data eps / 0.0E+00 /
  data sml / 0.0E+00 /

  if ( eps == 0.0E+00 ) then
    eps = r4_mach ( 3 )
    alneps = log ( eps )
    sml = r4_mach ( 1 )
    alnsml = log ( sml )
  end if

  if ( x < 0.0E+00 .or. 1.0E+00 < x ) then
    write (msg,'(a,g14.6)') 'r4_betai: 0 <= x <= 1 is required; x = ', x
    call oops (trim(msg))
  end if

  if ( pin <= 0.0E+00 .or. qin <= 0.0E+00 ) then
    write (msg,'(2(a,g14.6))') 'r4_betai: p or q <= 0.0; p = ', pin, ', qin = ', qin
    call oops (trim(msg))
  end if

  y = x
  p = pin
  q = qin

  if ( p < q .or. 0.8E+00 <= x ) then

    if ( 0.2E+00 <= x ) then
      y = 1.0E+00 - y
      p = qin
      q = pin
    end if

  end if

  if ( ( p + q ) * y / ( p + 1.0E+00 ) < eps ) then

    r4_betai = 0.0E+00

    xb = p * log ( max ( y, sml ) ) - log ( p ) - r4_lbeta ( p, q )

    if ( alnsml < xb .and. y /= 0.0E+00 ) then
      r4_betai = exp ( xb )
    end if

    if ( y /= x .or. p /= pin ) then
      r4_betai = 1.0E+00 - r4_betai
    end if

    return

  end if
!
!  Evaluate the infinite sum first.
!  TERM will equal y^p/beta(ps,p) * (1.-ps)i * y^i / fac(i)
!
  ps = q - aint ( q )
  if ( ps == 0.0E+00 ) then
    ps = 1.0E+00
  end if

  xb = p * log ( y ) - r4_lbeta ( ps, p ) - log ( p )

  if ( xb < alnsml ) then

    r4_betai = 0.0E+00

  else

    r4_betai = exp ( xb )
    term = r4_betai * p

    if ( ps /= 1.0E+00 ) then

      n = int ( max ( alneps / log ( y ), 4.0E+00 ) )
      do i = 1, n
        term = term * ( real ( i ) - ps ) * y / real ( i )
        r4_betai = r4_betai + term / ( p + real ( i ) )
      end do

    end if

  end if
!
!  Now evaluate the finite sum.
!
  if  ( 1.0E+00 < q ) then

    xb = p * log ( y ) + q * log ( 1.0E+00 - y ) - r4_lbeta ( p, q ) - log ( q )
    ib = int ( max ( xb / alnsml, 0.0E+00 ) )
    term = exp ( xb - real ( ib ) * alnsml )
    c = 1.0E+00 / ( 1.0E+00 - y )
    p1 = q * c / ( p + q - 1.0E+00 )

    finsum = 0.0E+00
    n = int ( q )
    if ( q == real ( n ) ) then
      n = n - 1
    end if

    do i = 1, n

      if ( p1 <= 1.0E+00 .and. term / eps <= finsum ) then
        exit
      end if

      term = ( q - real ( i - 1 ) ) * c * term &
        / ( p + q - real ( i ) )

      if ( 1.0E+00 < term ) then
        ib = ib - 1
        term = term * sml
      end if

      if ( ib == 0 ) then
        finsum = finsum + term
      end if

    end do

    r4_betai = r4_betai + finsum

  end if

  if ( y /= x .or. p /= pin ) then
    r4_betai = 1.0E+00 - r4_betai
  end if

  if ( r4_betai < 0.0E+00 ) then
    r4_betai =  0.0E+00
  end if

  if ( 1.0E+00 < r4_betai ) then
    r4_betai = 1.0E+00
  end if

  return
  
end function r4_betai


!*****************************************************************************************
function r4_beta ( a, b )

!! R4_BETA evaluates the beta function of R4 (single precision) arguments.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real A, B, the arguments.
!
!    Output, real R4_BETA, the beta function of A and B.
!
  implicit none

  real a
  real alnsml
  real b
  real r4_beta
  real r4_gamma
  real r4_lbeta
  real r4_mach
  real xmax
  real xmin
  character(len=132) :: msg

  save alnsml
  save xmax

  data alnsml / 0.0E+00 /
  data xmax / 0.0E+00 /

  if ( xmax == 0.0E+00 ) then
    call r4_gaml ( xmin, xmax )
    alnsml = log ( r4_mach ( 1 ) )
  end if

  if ( a <= 0.0E+00 .or. b <= 0.0E+00 ) then
    write (msg,'(2(a,g14.6))') 'r4_beta: a and b must be greater than 0; a = ',&
     a, ', b = ', b
    call oops (trim(msg))
  end if

  if ( a + b < xmax ) then
    r4_beta = r4_gamma ( a ) * r4_gamma ( b ) / r4_gamma ( a + b )
    return
  end if

  r4_beta = r4_lbeta ( a, b )

  r4_beta = exp ( r4_beta )

  return
  
end function r4_beta


!*****************************************************************************************
function r4_gamma ( x )

!! R4_GAMMA evaluates the gamma function of an R4 (single precision) argument.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real X, the argument.
!
!    Output, real R4_GAMMA, the gamma function of X.
!
  implicit none

  real dxrel
  real gcs(23)
  integer i
  integer n
  integer ngcs
  real, save :: pi = 3.14159265358979323846E+00
  real r4_csevl
  real r4_gamma
  integer r4_inits
  real r4_lgmc
  real r4_mach
  real sinpiy
  real sq2pil
  real x
  real xmax
  real xmin
  real xsml
  real y
  character(len=132) :: msg

  save dxrel
  save gcs
  save ngcs
  save sq2pil
  save xmax
  save xmin
  save xsml

  data gcs( 1) / 0.008571195590989331E+00 /
  data gcs( 2) / 0.004415381324841007E+00 /
  data gcs( 3) / 0.05685043681599363E+00 /
  data gcs( 4) /-0.004219835396418561E+00 /
  data gcs( 5) / 0.001326808181212460E+00 /
  data gcs( 6) /-0.0001893024529798880E+00 /
  data gcs( 7) / 0.0000360692532744124E+00 /
  data gcs( 8) /-0.0000060567619044608E+00 /
  data gcs( 9) / 0.0000010558295463022E+00 /
  data gcs(10) /-0.0000001811967365542E+00 /
  data gcs(11) / 0.0000000311772496471E+00 /
  data gcs(12) /-0.0000000053542196390E+00 /
  data gcs(13) / 0.0000000009193275519E+00 /
  data gcs(14) /-0.0000000001577941280E+00 /
  data gcs(15) / 0.0000000000270798062E+00 /
  data gcs(16) /-0.0000000000046468186E+00 /
  data gcs(17) / 0.0000000000007973350E+00 /
  data gcs(18) /-0.0000000000001368078E+00 /
  data gcs(19) / 0.0000000000000234731E+00 /
  data gcs(20) /-0.0000000000000040274E+00 /
  data gcs(21) / 0.0000000000000006910E+00 /
  data gcs(22) /-0.0000000000000001185E+00 /
  data gcs(23) / 0.0000000000000000203E+00 /

  data dxrel / 0.0E+00 /
  data ngcs / 0 /
  data sq2pil / 0.91893853320467274E+00 /
  data xmax / 0.0E+00 /
  data xmin / 0.0E+00 /
  data xsml / 0.0E+00 /

  if ( ngcs == 0 ) then
    ngcs = r4_inits ( gcs, 23, 0.1E+00 * r4_mach ( 3 ) )
    call r4_gaml ( xmin, xmax )
    xsml = exp ( max ( log ( r4_mach ( 1 ) ), &
      - log ( r4_mach ( 2 ) ) ) + 0.01E+00 )
    dxrel = sqrt ( r4_mach ( 4 ) )
  end if

  y = abs ( x )

  if ( y <= 10.0E+00 ) then

    n = int ( x )
    if ( x < 0.0E+00 ) then
      n = n - 1
    end if
    y = x - real ( n )
    n = n - 1
    r4_gamma = 0.9375E+00 + r4_csevl ( 2.0E+00 * y - 1.0E+00, gcs, ngcs )

    if ( n == 0 ) then

      return

    else if ( n < 0 ) then

      n = - n

      if ( x == 0.0E+00 ) then
        call oops ('r4_gamma: x is zero')
      end if

      if ( x < 0.0E+00 .and. x + real ( n - 2 ) == 0.0E+00 ) then
        write (msg,'(a,g14.6)') 'r4_gamma: x is a negative integer : ', x
        call oops (trim(msg))
      end if

      if ( x < - 0.5E+00 .and. &
        abs ( ( x - aint ( x - 0.5E+00 ) ) / x ) < dxrel ) then
        write (msg,'(a,g14.6)') 'r4_gamma: x too near a negative integer,&
         & answer is half precision; x = ', x
        call warnings (trim(msg))
      end if

      if ( y < xsml ) then
        write (msg,'(a,g14.6)') 'r4_gamma: x is so close to zero&
         & that Gamma overflows; x = ', x
        call oops (trim(msg))
      end if

      do i = 1, n
        r4_gamma = r4_gamma / ( x + real ( i - 1 ) )
      end do

    else if ( n == 0 ) then

    else

      do i = 1, n
        r4_gamma = ( y + real ( i ) ) * r4_gamma
      end do

    end if

  else

    if ( xmax < x ) then
      write (msg,'(a,g14.6)') 'r4_gamma: x so big that Gamma overflows; x = ', x
      call oops (trim(msg))
    end if
!
!  Underflow.
!
    if ( x < xmin ) then
      r4_gamma = 0.0E+00
      return
    end if

    r4_gamma = exp ( ( y - 0.5E+00 ) * log ( y ) - y + sq2pil &
      + r4_lgmc ( y ) )

    if ( 0.0E+00 < x ) then
      return
    end if

    if ( abs ( ( x - aint ( x - 0.5E+00 ) ) / x ) < dxrel ) then
      write (msg,'(a,g14.6)') 'r4_gamma: x too near a negative integer,&
       & answer is half precision; x = ', x
      call warnings (trim(msg))
    end if

    sinpiy = sin ( pi * y )

    if ( sinpiy == 0.0E+00 ) then
      write (msg,'(a,g14.6)') 'r4_gamma: X is a negative integer; x = ', x
      call oops (trim(msg))
    end if

    r4_gamma = - pi / ( y * sinpiy * r4_gamma )

  end if

  return
  
end function r4_gamma


!*****************************************************************************************
function r4_csevl ( x, cs, n )

!! R4_CSEVL evaluates a Chebyshev series.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Roger Broucke,
!    Algorithm 446:
!    Ten Subroutines for the Manipulation of Chebyshev Series,
!    Communications of the ACM,
!    Volume 16, Number 4, April 1973, pages 254-256.
!
!  Parameters:
!
!    Input, real X, the evaluation point.
!
!    Input, real CS(N), the Chebyshev coefficients.
!
!    Input, integer N, the number of Chebyshev coefficients.
!
!    Output, real R4_CSEVL, the Chebyshev series evaluated at X.
!
  implicit none

  integer n

  real b0
  real b1
  real b2
  real cs(n)
  integer i
  real r4_csevl
  real twox
  real x
  character(len=132) :: msg

  if ( n < 1 ) call oops ('r4_csevl: Number of terms <= 0')

  if ( 1000 < n ) call oops ('r4_csevl: Number of terms > 1000')

  if ( x < -1.1E+00 .or. 1.0E+00 < x ) then
    write (msg,'(a,g14.6)') 'r4_csevl: x outside (-1,+1); x = ', x
    call oops (trim(msg))
  end if

  b1 = 0.0E+00
  b0 = 0.0E+00
  twox = 2.0E+00 * x

  do i = n, 1, -1
    b2 = b1
    b1 = b0
    b0 = twox * b1 - b2 + cs(i)
  end do

  r4_csevl = 0.5E+00 * ( b0 - b2 )

  return
  
end function r4_csevl


!*****************************************************************************************
subroutine r4_gaml ( xmin, xmax )

!! R4_GAML evaluates bounds for an R4 argument of the gamma function.
!
!  Discussion:
!
!    This function calculates the minimum and maximum legal bounds 
!    for X in the evaluation of GAMMA ( X ).
!
!    XMIN and XMAX are not the only bounds, but they are the only 
!    non-trivial ones to calculate.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Output, real XMIN, XMAX, the bounds.
!
  implicit none

  real alnbig
  real alnsml
  integer i
  integer j
  real r4_mach
  real xln
  real xmax
  real xmin
  real xold

  alnsml = log ( r4_mach ( 1 ) )
  xmin = - alnsml

  do i = 1, 10

    xold = xmin
    xln = log ( xmin )
    xmin = xmin - xmin * ( ( xmin + 0.5E+00 ) * xln - xmin &
      - 0.2258E+00 + alnsml ) / ( xmin * xln + 0.5E+00 )

    if ( abs ( xmin - xold ) < 0.005E+00 ) then

      xmin = - xmin + 0.01E+00

      alnbig = log ( r4_mach ( 2 ) )
      xmax = alnbig

      do j = 1, 10

        xold = xmax
        xln = log ( xmax )
        xmax = xmax - xmax * ( ( xmax - 0.5E+00 ) * xln - xmax &
          + 0.9189E+00 - alnbig ) / ( xmax * xln - 0.5E+00 )

        if ( abs ( xmax - xold ) < 0.005E+00 ) then
          xmax = xmax - 0.01E+00
          xmin = max ( xmin, - xmax + 1.0E+00 )
          return
        end if

      end do

      call oops ('r4_gaml: Unable to find xmax')

    end if

  end do

  call oops ('r4_gaml: Unable to find xmin')
  
end subroutine r4_gaml


!*****************************************************************************************
function r4_inits ( os, nos, eta )

!! R4_INITS initializes a Chebyshev series.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Roger Broucke,
!    Algorithm 446:
!    Ten Subroutines for the Manipulation of Chebyshev Series,
!    Communications of the ACM,
!    Volume 16, Number 4, April 1973, pages 254-256.
!
!  Parameters:
!
!    Input, real OS(NOS), the Chebyshev coefficients.
!
!    Input, integer NOS, the number of coefficients.
!
!    Input, real ETA, the desired accuracy.
!
!    Output, integer R8_INITS, the number of terms of the series 
!    needed to ensure the requested accuracy.
!
  implicit none

  integer nos

  real err
  real eta
  integer i
  real os(nos)
  integer r4_inits

  if ( nos < 1 ) call oops ('r4_inits: Number of coefficients < 1')

  err = 0.0E+00
  do i = nos, 1, -1
    err = err + abs ( os(i) )
    if ( eta < err ) then
      r4_inits = i
      return
    end if
  end do

  r4_inits = nos
  call warnings ('r4_inits: ETA may be too small')

  return
  
end function r4_inits


!*****************************************************************************************
function r4_lbeta ( a, b )

!! R4_LBETA evaluates the logarithm of the beta function of R4 arguments.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real A, B, the arguments.
!
!    Output, real R4_LBETA, the logarithm of the beta function
!    of A and B.
!
  implicit none

  real a
  real b
  real corr
  real p
  real q
  real r4_gamma
  real r4_lbeta
  real r4_lgmc
  real r4_lngam
  real r4_lnrel
  real sq2pil
  character(len=132) :: msg

  save sq2pil

  data sq2pil / 0.91893853320467274E+00 /

  p = min ( a, b )
  q = max ( a, b )

  if ( p <= 0.0E+00 ) then

    write (msg,'(a,g14.6)') 'r4_lbeta: Both arguments must be greater than 0; p = ', p
    call oops (trim(msg))

  else if ( p < 10.0E+00 .and. q <= 10.0E+00 ) then

    r4_lbeta = log ( r4_gamma ( p ) &
      * ( r4_gamma ( q ) / r4_gamma ( p + q ) ) )

  else if ( p < 10.0E+00 ) then

    corr = r4_lgmc ( q ) - r4_lgmc ( p + q )

    r4_lbeta = r4_lngam ( p ) + corr + p - p * log ( p + q ) + &
      ( q - 0.5E+00 ) * r4_lnrel ( - p / ( p + q ) )

  else

    corr = r4_lgmc ( p ) + r4_lgmc ( q ) - r4_lgmc ( p + q )

    r4_lbeta = - 0.5E+00 * log ( q ) + sq2pil + corr &
      + ( p - 0.5E+00 ) * log ( p / ( p + q ) ) &
      + q * r4_lnrel ( - p / ( p + q ) )

  end if

  return
  
end function r4_lbeta


!*****************************************************************************************
function r4_lgmc ( x )

!! R4_LGMC evaluates the log gamma correction factor for an R4 argument.
!
!  Discussion:
!
!    For 10 <= X, compute the log gamma correction factor so that
!
!      log ( gamma ( x ) ) = log ( sqrt ( 2 * pi ) ) 
!                          + ( x - 0.5 ) * log ( x ) - x 
!                          + r4_lgmc ( x )
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real X, the argument.
!
!    Output, real R4_LGMC, the correction factor.
!
  implicit none

  real algmcs(6)
  integer nalgm
  real r4_csevl
  integer r4_inits
  real r4_lgmc
  real r4_mach
  real x
  real xbig
  real xmax
  character(len=132) :: msg

  save algmcs
  save nalgm
  save xbig
  save xmax

  data algmcs( 1) /    0.166638948045186E+00 /
  data algmcs( 2) /   -0.0000138494817606E+00 /
  data algmcs( 3) /    0.0000000098108256E+00 /
  data algmcs( 4) /   -0.0000000000180912E+00 /
  data algmcs( 5) /    0.0000000000000622E+00 /
  data algmcs( 6) /   -0.0000000000000003E+00 /

  data nalgm / 0 /
  data xbig / 0.0E+00 /
  data xmax / 0.0E+00 /

  if ( nalgm == 0 ) then
    nalgm = r4_inits ( algmcs, 6, r4_mach ( 3 ) )
    xbig = 1.0E+00 / sqrt ( r4_mach ( 3 ) )
    xmax = exp ( min ( log ( r4_mach ( 2 ) / 12.0E+00 ), &
      - log ( 12.0E+00 * r4_mach ( 1 ) ) ) )
  end if

  if ( x < 10.0E+00 ) then

    write (msg,'(a,g14.6)') 'r4_lgmc: x must be at least 10; x = ', x
    call oops (trim(msg))

  else if ( x < xbig ) then

    r4_lgmc = r4_csevl ( 2.0E+00 * ( 10.0E+00 / x ) &
      * ( 10.0E+00 / x ) - 1.0E+00, algmcs, nalgm ) / x

  else if ( x < xmax ) then

    r4_lgmc = 1.0E+00 / ( 12.0E+00 * x )

  else

    r4_lgmc = 0.0E+00

  end if

  return
  
end function r4_lgmc


!*****************************************************************************************
function r4_mach ( i )

!! R4_MACH returns single precision real machine constants.
!
!  Discussion:
!
!    Assume that single precision real numbers are stored with a mantissa 
!    of T digits in base B, with an exponent whose value must lie 
!    between EMIN and EMAX.  Then for values of I between 1 and 5, 
!    R4_MACH will return the following values:
!
!      R4_MACH(1) = B**(EMIN-1), the smallest positive magnitude.
!      R4_MACH(2) = B**EMAX*(1-B**(-T)), the largest magnitude.
!      R4_MACH(3) = B**(-T), the smallest relative spacing.
!      R4_MACH(4) = B**(1-T), the largest relative spacing.
!      R4_MACH(5) = log10(B)
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    25 April 2007
!
!  Author:
!
!    Original FORTRAN77 version by Phyllis Fox, Andrew Hall, Norman Schryer.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Phyllis Fox, Andrew Hall, Norman Schryer,
!    Algorithm 528,
!    Framework for a Portable Library,
!    ACM Transactions on Mathematical Software,
!    Volume 4, Number 2, June 1978, page 176-188.
!
!  Parameters:
!
!    Input, integer I, chooses the parameter to be returned.
!    1 <= I <= 5.
!
!    Output, real R4_MACH, the value of the chosen parameter.
!
  implicit none

  integer i
  real r4_mach
  character(len=132) :: msg

  if ( i < 1 ) then
    r4_mach = 0.0E+00
    write (msg,'(a,i12)') 'r4_mach: The input argument i is out of bounds&
    & (1 <= i <= 5); i = ', i
    call oops (trim(msg))
  else if ( i == 1 ) then
    r4_mach = 1.1754944E-38
  else if ( i == 2 ) then
    r4_mach = 3.4028235E+38
  else if ( i == 3 ) then
    r4_mach = 5.9604645E-08
  else if ( i == 4 ) then
    r4_mach = 1.1920929E-07
  else if ( i == 5 ) then
    r4_mach = 0.3010300E+00
  else if ( 5 < i ) then
    r4_mach = 0.0E+00
    write (msg,'(a,i12)') 'r4_mach: The input argument i is out of bounds&
    & (1 <= i <= 5); i = ', i
    call oops (trim(msg))
  end if

  return
  
end function r4_mach


!*****************************************************************************************
function r4_lngam ( x )

!! R4_LNGAM evaluates the log of the absolute value of gamma of an R4 argument.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real X, the argument.
!
!    Output, real R4_LNGAM, the logarithm of the absolute value of
!    the gamma function of X.
!
  implicit none

  real dxrel
  real, save :: pi = 3.14159265358979323846E+00
  real r4_gamma
  real r4_lgmc
  real r4_lngam
  real r4_mach
  real sinpiy
  real sq2pil
  real sqpi2l
  real x
  real xmax
  real y

  save dxrel
  save sq2pil
  save sqpi2l
  save xmax
  
  data dxrel / 0.0E+00 /
  data sq2pil / 0.91893853320467274E+00 /
  data sqpi2l / 0.22579135264472743E+00 /
  data xmax / 0.0E+00 /

  if ( xmax == 0.0E+00 ) then
    xmax = r4_mach ( 2 ) / log ( r4_mach ( 2 ) )
    dxrel = sqrt ( r4_mach ( 4 ) )
  end if

  y = abs ( x )

  if ( y <= 10.0E+00 ) then
    r4_lngam = log ( abs ( r4_gamma ( x ) ) )
    return
  end if

  if ( xmax < y )  call oops ('r4_lngam: Result overflows, |x| too big')

  if ( 0.0E+00 < x ) then
    r4_lngam = sq2pil + ( x - 0.5E+00 ) * log ( x ) - x + r4_lgmc ( y )
    return
  end if

  sinpiy = abs ( sin ( pi * y ) )

  if ( sinpiy == 0.0E+00 ) call oops('r4_lngam: x is a negative integer')

  r4_lngam = sqpi2l + ( x - 0.5E+00 ) * log ( y ) - x &
    - log ( sinpiy ) - r4_lgmc ( y )

  if ( abs ( ( x - aint ( x - 0.5E+00 ) ) * r4_lngam / x ) < dxrel ) then
    call warnings ('r4_lngam: Result is half precision because x is too near a negative&
    & integer')
  end if

  return
  
end function r4_lngam


!*****************************************************************************************
function r4_lnrel ( x )

!! R4_LNREL evaluates log ( 1 + X ) for an R4 argument.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  Modified:
!
!    10 September 2011
!
!  Author:
!
!    Original FORTRAN77 version by Wayne Fullerton.
!    FORTRAN90 version by John Burkardt.
!
!  Reference:
!
!    Wayne Fullerton,
!    Portable Special Function Routines,
!    in Portability of Numerical Software,
!    edited by Wayne Cowell,
!    Lecture Notes in Computer Science, Volume 57,
!    Springer 1977,
!    ISBN: 978-3-540-08446-4,
!    LC: QA297.W65.
!
!  Parameters:
!
!    Input, real X, the argument.
!
!    Output, real R4_LNREL, the value of LOG ( 1 + X ).
!
  implicit none

  real alnrcs(23)
  integer nlnrel
  real r4_csevl
  integer r4_inits
  real r4_lnrel
  real r4_mach
  real x
  real xmin
  character(len=132) :: msg

  save alnrcs
  save nlnrel
  save xmin

  data alnrcs( 1) /    1.0378693562743770E+00 /
  data alnrcs( 2) /   -0.13364301504908918E+00 /
  data alnrcs( 3) /    0.019408249135520563E+00 /
  data alnrcs( 4) /   -0.003010755112753577E+00 /
  data alnrcs( 5) /    0.000486946147971548E+00 /
  data alnrcs( 6) /   -0.000081054881893175E+00 /
  data alnrcs( 7) /    0.000013778847799559E+00 /
  data alnrcs( 8) /   -0.000002380221089435E+00 /
  data alnrcs( 9) /    0.000000416404162138E+00 /
  data alnrcs(10) /   -0.000000073595828378E+00 /
  data alnrcs(11) /    0.000000013117611876E+00 /
  data alnrcs(12) /   -0.000000002354670931E+00 /
  data alnrcs(13) /    0.000000000425227732E+00 /
  data alnrcs(14) /   -0.000000000077190894E+00 /
  data alnrcs(15) /    0.000000000014075746E+00 /
  data alnrcs(16) /   -0.000000000002576907E+00 /
  data alnrcs(17) /    0.000000000000473424E+00 /
  data alnrcs(18) /   -0.000000000000087249E+00 /
  data alnrcs(19) /    0.000000000000016124E+00 /
  data alnrcs(20) /   -0.000000000000002987E+00 /
  data alnrcs(21) /    0.000000000000000554E+00 /
  data alnrcs(22) /   -0.000000000000000103E+00 /
  data alnrcs(23) /    0.000000000000000019E+00 /

  data nlnrel / 0 /
  data xmin / 0.0E+00 /

  if ( nlnrel == 0 ) then
    nlnrel = r4_inits ( alnrcs, 23, 0.1E+00 * r4_mach ( 3 ) )
    xmin = - 1.0E+00 + sqrt ( r4_mach ( 4 ) )
  end if

  if ( x <= - 1.0E+00 ) then
    write (msg,'(a,g14.6)') 'r4_lnrel: X <= -1; x = ', x
    call oops (trim(msg))
  else if ( x < xmin ) then
    write (msg,'(a,g14.6)') 'r4_lnrel: Result is less than half precision because&
     & x is too close to - 1; x = ', x
    call warnings (trim(msg))
  end if

  if ( abs ( x ) <= 0.375E+00 ) then
    r4_lnrel = x * ( 1.0E+00 &
      - x * r4_csevl ( x / 0.375E+00, alnrcs, nlnrel ) )
  else
    r4_lnrel = log ( 1.0E+00 + x )
  end if
  return
  
end function r4_lnrel

