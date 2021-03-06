# DMFLSM
Development of a light-sheet fluorescence microscope employing an ALPAO deformable mirror to achieve video-rate remote refocusing and volumetric imaging.

Terence George Wright,
Photonics Group,
Department of Physics,
Imperial College London



There are numerous situations in microscopy where it is desirable to remotely refocus a microscope employing a high numerical aperture (NA) objective lens. This thesis describes the characterisation, development and implementation of an Alpao membrane deformable mirror-based system to achieve this goal for a light-sheet fluorescence microscope (LSFM). 
The Alpao deformable mirror (DM) DM97-15 used is this work has 97 actuators and was sufficiently fast to perform refocus sweeps at 25 Hz and faster. However, a known issue with using Alpao deformable mirrors in open-loop mode is that they exhibit viscoelastic creep and temperature-dependent variations in the mirror response.  The effect of visco-elastic creep was reduced by ensuring that the mirror profile was on average constant on timescales shorter than the characteristic time of the visco-elastic creep. The thermal effect was managed by ensuring that the electrical power delivered to the actuators was constant prior to optimisation and use. This was achieved by ensuring that the frequency and amplitude of oscillation of the mirror was constant prior to optimisation, so that it reached a thermal steady state, was approximately constant during optimisation and constant during use. 
The image-based optimisation procedure employed used an estimate of the Strehl ratio of the optical system calculated from an image of an array of 1 μm diameter holes. The optimisation procedure included optimising the amount of high-NA defocus and the Zernike modes from Noll indices 4 to 24. The system was tested at 26.3 refocus sweeps per second over a refocus range of -50 to 50 μm with a 40x/0.85 air objective and a 40x/0.80 water immersion objective. The air objective enabled a mean Strehl metric of more than 0.6 over a lateral field of view of 200x200 microns2 and for a refocus range of 45 microns. The water objective achieved a mean Strehl metric of more than 0.6 over a lateral field of view of 200x200 microns2 over a larger refocus range of 77 microns. 
The DM-based refocusing system was then incorporated into a LSFM setup. The spatial resolution of the system was characterised using fluorescent beads imaged volumetrically at 26.3 volumes per second. The performance of the system was also demonstrated for imaging fluorescence pollen grain samples. 
