//
//  Commons.h
//  29.10.2024
//

#ifndef Commons_h
#define Commons_h

#include <simd/simd.h>

typedef struct Color {
    simd_float4 values;
} Color;

typedef struct Painting {
    simd_ushort2 location;
    Color color;
} Painting;


#endif /* Commons_h */
