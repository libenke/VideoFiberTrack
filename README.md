# VideoFiberTrack
 Track fibers for the "Particle Tracking Velocity (PTV)" experiments during rheology and relative studies
## Tracking Fibers' Rotation and Movement in Video Recordings
This package was developped to track fibers for the "Particle Tracking Velocity (PTV)" methods of experiments during rheology studies. 

Author: Dr. Benke Li (李本科)

Author's ORCID: https://orcid.org/0000-0002-8830-0563

Author's ResearchGate: https://www.researchgate.net/profile/Benke-Li

> Please cite this paper if you use this package:
>
> Benke Li, Ying Guo, Paul Steeman, Markus Bulters, Wei Yu. "Wall effect on the rheology of short-fiber suspensions under shear" __Journal of Rheology__ 2021, 65 (6), 1169–1185.
> 
> @article{10.1122/8.0000292,
>     author = {Li, Benke and Guo, Ying and Steeman, Paul and Bulters, Markus and Yu, Wei},
>     title = "{Wall effect on the rheology of short-fiber suspensions under shear}",
>     journal = {Journal of Rheology},
>     volume = {65},
>     number = {6},
>     pages = {1169-1185},
>     year = {2021},
>     month = {11},
>     issn = {0148-6055},
>     doi = {10.1122/8.0000292},
>     url = {https://doi.org/10.1122/8.0000292}, }
## Issues and Background
Particle Tracking Velocity (PTV) methods are widely applied in rheology studies of non-Newtonian fluids. During which a small amount of tracking particles was added in the fluids to be captured by the camera, whose trajectories could be represented the fluid's flow fields. 
It is easy to follow the movement of the spherical particles by picture register algorithms, e.g. figure correlations. However, for fiber filled suspensions fluids, due to the invlovlement of fibers' rotation movements, it was hard to tracking the fiber's movement by simply applying the correlation register algorithms. Thus, we developped this package based on `MATLAB` during our studies  [wall effect on the rheology of short-fiber suspensions under shear](https://doi.org/10.1122/8.0000292). Now we open this package based on GPL3 license to benifit relative studies.
## Demo Data and Demo Tracking Results
The demo data and demo tracking results were stored in folder `data` of  this package.
## Usage
This package was tested in MATLAB2023 and MATLAB2016. 

- Start the app

Download this package, and run `main.m` in MATLAB.

- Overview of This package

![Packgae and Video Data Overview](docs/overview.png)

 - Open Videos, available in '.avi' and '.mp4' type of video

![How to Open Video](docs/open_video.png)

 - Play Videos
 
![How to Play Video](docs/play_video.png)

 - Label Fibers in the Video and Tracking Them, and Export Results

![How to Label Fibers, Tracking and Export '.txt' Results](docs/label_fiber_and_track.png)

 - Trim the Tracking Results by Hand if Needed, Delete the Tracking Results by Hand if Duplicated.

![How to Trim of Delete the Tracking Results by Hand if needed](docs/trim_tracking_results.png)
