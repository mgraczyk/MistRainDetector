#ifndef DETECTOR_HGUARD
#define DETECTOR_HGUARD

/* This Header file defines the available functions for the 
   DSP audio based rain detector.
   
   USAGE: 
   First create a ptr_detector_t by calling DTCreateDetector.
   If the system does not have a malloc function, you can supply
   an memory address at which the detector will be located by 
   defining a macro DTMalloc(size) which returns void* and is able
   to store at least 16 words of memory.  If you define DTMALLOC,
   you must also define a macro DTFREE which will be used to free
   the memory allocated by DTMalloc.
   
   Then begin passing nonoverlapping chunks of contiguous audio to 
   DTDetectChunk().  The value returned indicates the intensity
   of rain during that chunk.  The audio chunks passed to the 
   Detector must be of length DTChunkLength, and be contiguous
   chunks of real world data.
   
   When finished, pass the detector to DTDestroyDetector(1) to 
   prevent memory leaks.
   
   NOTES:
   The Detector currently only supports sampling frequencies of 
   Fs = 44100 Hz.
*/

/* Opaque Detector object type */
struct detector_t;
typedef detector_t* ptr_detector_t;

typedef double audio_value_t;

const size_t DTChunkSize = 4096;

/* Various rain intensity values */
typedef enum RainIntensity_t
{
   RainIntensity_NoRain = 0,
   RainIntensity_SomeRain = 1,
   /* TODO: Add more intensity values */
};
   
/* Creates a Detector object.
   A returned value of NULL indicates a failure. */
extern ptr_detector_t DTCreateDetector();

/* Destroys a Detector object. */
extern void DTDestroyDetector(ptr_detector_t toDestroy);

/* Performs rain detection on the specified chunk of audio 
   Note that the chunk size is assumed to be DTChunkSize.
   Passing a pointer to a chunk smaller than DTChunkSize will
   result in garbage data or a sementation fault.  Passing
   a value to a larger chunk will result in truncation.        */
extern RainIntensity_t DTDoDetection(ptr_detector_t detector,
                          audio_value_t *audio);

#endif
