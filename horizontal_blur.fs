extern float texelWidth;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 result = vec4(0.0);
    for (int i = -2; i <= 2; i++) {
        result += Texel(texture, vec2(texture_coords.x + i * texelWidth, texture_coords.y)) * 0.2;
    }
    return result;
}