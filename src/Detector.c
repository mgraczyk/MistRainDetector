#include "math.h"
#include "Detector.h"
#include "fdaLPcoeffs.h"
#include "fdaHPcoeffs.h"


#include "fft.h"
/* Must include a function fft(const double* input, double* output, size_t sz) */

#include "golden.h"

#ifndef DTMALLOC
#define DTMALLOC(sz) malloc((sz))
#define DTFREE(pDet) free((pDet))
#endif

typedef struct detector_t
{
   RainIntensity_t last_intensity = RainIntensity_NoRain;
   double confidence = 0;
      
   double hp_dly[MWSPT_NSEC][2] = {0};
   double lp_dly[][2] = {0};
      
   /* TODO: Implement heuristic to pause between
            large gaps in rain. */
};

/* Algorithm Parameters */
const size_t smooth_sz = 4;
const size_t window_sz = 8;
const size_t num_chunks = DTChunkSize/window_sz;
const double filter_threshold = 0.69;
const int confidence_max = 2;
const int confidence_min = -2;
const double raining_max = 0.8;
const double raining_min = -0.4;

const double hamming[smooth_sz/2] = {0.08, 0.77};

/* Taken from http://www.eas.uccs.edu/wickert/ece4680/lecture_notes/Lab5.pdf */
#define DECL_BQ_PROCESS(NAME, dly, a, b) inline double processBiquads#NAME(ptr_detector_t p, double input) { \
   double wn, input; \
   double result = 0;\
   size_t i = 0 \
   for (i = 0; i < STAGES; i++) { \
       wn = input - a[i][0] * (p->dly[i][0]) - a[i][1] * (p->dly[i][1]); \
       result = b[i][0]*wn + b[i][1]*(p->dly[i][0]) + b[i][2]*(p->dly[i][1]); \
       p->dly[i][1] = (p->dly[i][0]); \
       p->dly[i][0] = wn; \
       input = result; \
   } \
   return input; \
 } \
 
 DECL_BQ_PROCESS(HP, hp_dly, hp_DEN, hp_NUM)
 DECL_BQ_PROCESS(LP, lp_dly, lp_DEN, lp_NUM)


/* Creates a Detector object */
ptr_detector_t DTCreateDetector()
{
   ptr_detector_t pDet = (ptr_detector_t)DTMALLOC(sizeof(detector_t));

   return pDet;
}

/* Destroys a Detector object */
void DTDestroyDetector(ptr_detector_t toDestroy)
{
   DTFREE(toDestroy);
}

/* Performs rain detection on the specified chunk of audio 
   Note that the chunk size is assumed to be DTChunkSize.
   Passing a pointer to a chunk smaller than DTChunkSize will
   result in garbage data or a sementation fault.  Passing
   a value to a larger chunk will result in truncation.        */
RainIntensity_t DTDoDetection(ptr_detector_t detector,
                          audio_value_t *audio)
{
   double corr_sum = 0;
   RainIntensity_t retval = RainIntensity_NoRain;
   static int sleep_mask = 1;
   static int counter = 0;
   size_t i;
   size_t j;
   fft_tmp[DTChunkSize];
   
   /* "Sleeping" heuristic */
   /* The heuristic's implementation here is functionally equivalent
      to that found in the report, but is optimized to avoid checking 
      and incrementing the counter on each call */
   ++counter;
   if (counter < sleep_mask) {
      return detector->last_intensity;
   }
   
   /* First compute input LPF */
   for (i=0; i < DTChunkSize; ++i) {
      audio[i] = processBiquadsLP(detector, audio[i]);
   }
   
   /* Next compute HPF */
   for (i=0; i < DTChunkSize; ++i) {
      audio[i] = processBiquadsLP(detector, audio[i]);
   }
   
   /* Compute FFT */
   fft(audio, fft_tmp, DTChunkSize);
   
   /* Perform frequency domain filtering */
   audio[0] = hamming[0]*fft_tmp[0];
   audio[1] = hamming[0]*fft_tmp[1] + hamming[1]*fft_tmp[0];
   audio[2] = hamming[0]*fft_tmp[2] + hamming[1]*fft_tmp[1] + hamming[1]*fft_tmp[0];;
   for (i=3; i < DTChunkSize; ++i) {
      audio[i] = hamming[0]*fft_tmp[i-3] +
                 hamming[1]*fft_tmp[i-2] +
                 hamming[1]*fft_tmp[i-1] +
                 hamming[0]*fft_tmp[i];
   }
   
   /* Compute the block mean of the data */
   /* Do the correlation  */
   for (i=0, i < num_chunks; ++i) {
      for (j=0; j < window_sz; ++j) {
         corr_sum += golden[i]*audio[i*window_sz + j]/window_sz;
      }
   }
   
   /* Add to the accumulator */
   detector->confidence += corr_sum;
   
   /* Compute the thresholded values */
   if (detector->confidence > raining_max) {
      retval = RainIntensity_SomeRain;
      sleep_mask = 1;
      counter = 0;
      if (detector->confidence > confidence_max) {
         detector->confidence = confidence_max;
      }
   } else {
      if (detector->confidence < raining_min) {        
         if (detector->confidence < confidence_min) {
            sleep_mask<<=1;
            if (sleep_mask > 64) {
               sleep_mask = 64;
            }
            
            confidence = confidence_min;
         }
      } else {
         return detector->last_intensity;
      }
   }

   if (counter == 64) {
      counter = 0;
   }
   detector->last_intensity = retval;
   return retval;
}

