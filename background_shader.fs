// GLSL	LÖVE shader language
// float	number
// sampler2D	Image
// uniform	extern
// texture2D(tex, uv)	Texel(tex, uv)

// vec4 love_ScreenSize
// The width and height of the screen (or canvas) currently being 
// rendered to, stored in the x and y components of the variable. 
// The z and w components are used internally by LÖVE.
// You can convert it to a vec2 with
// love_ScreenSize.xy or vec2(love_ScreenSize).

#define TAU 6.28318530718

extern float time;
// extern float uvOffset;
extern vec3 a;
extern vec3 b;
extern vec3 c;
extern vec3 d;

// https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    return a + b * cos(TAU * (c * t + d));
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    
    vec2 uv = (screen_coords * 2.0 - love_ScreenSize.xy) / love_ScreenSize.x;
    uv.x -= 1.0;
    vec3 finalColor = vec3(0.0);
    vec2 original_uv = uv;

    for (float i = 0.0; i < 4.0; i += 1.0) {
        uv = fract(uv * 1.5) - 0.5;
        float dist = length(uv) * exp(-length(original_uv));
        vec3 col = palette(length(original_uv) + i * 0.4 + time * 0.4);
        dist = sin(dist * 8.0 + time) / 8.0;
        dist = abs(dist);
        dist = pow(0.01 / dist, 1.2);
        finalColor += col * dist;
    }

    return vec4(finalColor, 1.0);
}