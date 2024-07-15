vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texColor = Texel(texture, texture_coords);
    float brightness = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
    return brightness > 0.8 ? texColor : vec4(0.0);
}