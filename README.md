# mmTrace: Millimeter Wave Propagation Simulation

### Purpose
mmTrace is a deterministic image-based ray-tracing simulation framework for mm-wave propagation developed in MATLAB. It supports the design of mm-wave specific protocols and, in contrast to common statistical models, deals with multiple transceivers. The strengths of mmTrace constitute signal variations at different receivers and interference of multiple transmitters, which are crucial in certain situations. It generates channel impulse responses and determines signal characteristics in arbitray scenarios. Results are validated against the statistical channel models for IEEE 802.11ad. Our analyses indicate that image-based ray-tracing, as applied in mmTrace, is a feasible approach to predict interference in mm-wave communication systems.

### Installation
Clone the repository and update the submodules. You might use the following statements:

```sh
$ git clone https://github.com/seemoo-lab/mmTrace.git
$ git submodule init
$ git submodule update
```

### Libraries
The following libraries are required for mmTrace to work properly. They are automatically configured during the setup process.
 - Implementation of 60 GHz WLAN Channel Model (available at [IEEE 802.11 TGAD])
 - [matGeom]: Matlab geometry toolbox for 2D/3D geometric computing 

### Setup
Execute the setup.m script in the main folder. It will download and setup the libraries and update your path environment.
```matlab
>> setup
```

### Usage
Check the example folder for examples on how to use mmTrace. All required operations are encapsulated in the ch_trace.m file. You can run it as follows:
```matlab
>>	trace = ch_trace(tx_pos, rx_pos);
>>	trace = ch_trace(tx_pos, rx_pos, tx_az, rx_az);
>>	trace = ch_trace(tx_pos, rx_pos, tx_az, rx_az, 'OptParName', 'OptParValue', ...);
```

Available parameters are:
-	tx_pos:			Position of transmitters	
-	tx_az:			Orientation of transmitters
-	rx_pos:			Positions of receivers
-	rx_az:			Orientation of receivers
-	room_dims:		Dimension of rooms			
-	permit_wall:	Permittivity of walls				
-	permit_ceiling:	Permittivity of ceiling	
-	ant_altitude:	Altitude of antenna mounting				
-	obstacles:		Structure of obstacles		
-	frequency:		Carrier frequency of signals
-	max_refl:		Maximum number of reflections to consider				
-	refl_model:		Function handle of reflection model		
-	tx_sectors:		Sectors at transmit antennas		
-	rx_sectors:		Sectors at receive antennas		
-	suppress_los:	Flag to suppress the line-of-sight			
-	blur_clusters:	Flag to blur the clusters				
-	interpl_3d:		Flag to interpolate to 3D and consider ceiling reflections
-	tx_radpat:		Function handle of transmitter radiation pattern		
-	rx_radpat:		Function handle of receiver radiation pattern

### Support
Our implementation is still under heavy development. Users are highly encouraged to report bugs and feature requests to the developers. Please do not hesitate to contact us in case of any questions.

### Citing mmTrace
You are working on a scientific publication? Please consider citing our paper:
- D. Steinmetzer, J. Classen, and M. Hollick, "mmTrace: Modeling Millimeter-wave Indoor Propagation with Image-based Ray-tracing", Millimeter-wave Networking Workshop (mmNet'16), April 2016, San Fransisco, USA. 

If you are using mmTrace in your project, please inform us on what your project is about. We are highly interested in learning how our channel simulation approach is applied.  


   [matGeom]: <https://github.com/dlegland/matGeom>
   [IEEE 802.11 TGAD]: <http://www.ieee802.org/11/Reports/tgad_update.htm>

