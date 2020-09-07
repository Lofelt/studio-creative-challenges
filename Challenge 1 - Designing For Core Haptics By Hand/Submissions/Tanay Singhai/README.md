# Lofelt Challenge
by Tanay Singhal

## Video
Part 1 (first designs): https://www.youtube.com/watch?v=MEvc9unmjpU

Part 2 (iterations): https://www.youtube.com/watch?v=Egw6pDfICSE

## Summary of Process
1. Create an XCode project with two buttons. See [XCodeProject.zip](XCodeProject.zip).
2. Examine the two audio clips I picked (Bow Release and Snow 1) in Adobe Audition.
3. Play the audio clip over and over to brainstorm out how the haptic should feel.
4. Write down notable times in the audio clips where I believe there should be transient feedback or some sort of continuous ramp up/down (or something else). See [timings.txt](timings.txt).
5. Based on the times I noted, create the AHAP file. I mostly start with by copying transient, continuous, and control curves from previous haptic files and modifying the times, intensity, and sharpness.
6. Try on my iPhone.
7. Iterate. Iterate. Iterate.

## Where I struggled
Typos: I sometimes made typos in the AHAP files (e.g. 0.9 instead of 0.09), and I wouldn't realize I did something wrong until I actually play it on device and realize that something is off. A visualization of the AHAP files would have helped me catch these mistakes instantly.

Iteration time: In general, iteration is a little slow. If I have a continuous event with intensity and sharpness controls, and if I decide to change their timings, I will have to manually change the numbers for each one. If I mess up during this process, I will end up with a typo/bug in the haptic feel.

Scalability: The haptic designs here were relatively simple, but creating intricate haptics longer than 5 seconds would be very challenging by hand because there would be so many numbers to keep track of. Some visualization is an absolute must.

## What went well
Quality: Even though I wrote everything by hand, the timing and quality of the haptic feedback in general felt really good, even on my first try.

Testing time: Running the app on my device is almost instant. No complaints here.
