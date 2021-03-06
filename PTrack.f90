!==============================================================================|
!              Lagrangian particle tracking off-line program                   |
!==============================================================================|
!  Usage:                                                                      |
!    PTrack run.dat                                                            |
!------------------------------------------------------------------------------|
!  Where run.dat is the name of the run configuration file                     |
!==============================================================================|

program particle_traj
  !==============================================================================|
  use mod_config
  use mod_flow_field
  use mod_tracking
  implicit none
  !------------------------------------------------------------------------------|
  logical :: fexist
  !==============================================================================|

  !------------------------------------------------------------------------------|
  !  Get CASENAME from command line                                              |
  !------------------------------------------------------------------------------|
  call getarg(1,CASENAME)

  inquire(file=CASENAME, exist=fexist)
  if (.not.fexist) then
    write(*,*) 'ERROR: Parameter file: ', CASENAME, ' does not exist'
    stop
  end if

  !------------------------------------------------------------------------------|
  !  Read configuration parameters controlling model run                         |
  !------------------------------------------------------------------------------|
  write(*,*) "== Initializing Tracking Simulation =="
  call init_model

  !------------------------------------------------------------------------------|
  !  Read domain information from NetCDF input file                              |
  !------------------------------------------------------------------------------|
  call init_flow_field

  write(*,*) "-- Domain Information --"
  write(*,*) "Nodes       : ", NODES
  write(*,*) "Elements    : ", ELEMENTS
  write(*,*) "Sigma layers: ", SIGLAY
  write(*,*) "-- Simulation Parameters --"
  write(*,*) "Fixed particle depth  : ", F_DEPTH
  write(*,*) "Random walk model     : ", P_RND_WALK
  if (P_RND_WALK) then
    write(*,*) "Horizontal diffusivity: ", K_XY
    write(*,*) "Vertical diffusivity  : ", K_Z
  end if

  !------------------------------------------------------------------------------|
  !  Run the Lagrangian particle tracking model                                  |
  !------------------------------------------------------------------------------|
  call init_tracking
  if (P_2D_MODEL) then
    call run_2d_tracking
  else
    call run_tracking
  end if

  close(0)
end program particle_traj

