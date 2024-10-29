//
//  DrawingFunctions.metal
//  29.10.2024
//

#include <metal_stdlib>
using namespace metal;

#import "Commons.h"

kernel void draw_paintings(texture2d<float, access::write> output [[texture(0)]], uint2 gid [[thread_position_in_grid]], constant Painting *paintings [[buffer(0)]], constant int &m_count [[buffer(1)]]) {
    
    int lower = 0;
    int upper = m_count - 1;
    const constant Painting *toBePainted = nullptr;
    while (lower <= upper) {
        int mid = (lower + upper) / 2;
        const constant Painting *current = paintings + mid;
        
        if (current->location[0] == gid[0] && current->location[1] == gid[1]) {
            toBePainted = current;
            break;
        } else if (current->location[0] < gid[0]) {
            upper = mid - 1;
        } else if (current->location[0] == gid[0] && current->location[1] < gid[1]) {
            upper = mid - 1;
        } else if (current->location[0] == gid[0] && current->location[1] > gid[1]) {
            lower = mid + 1;
        } else if (current->location[0] > gid[0]) {
            lower = mid + 1;
        }
    }
    
    if (toBePainted) {
        float4 color = float4(toBePainted->color.values);
        output.write(color, toBePainted->location);
    }
}
