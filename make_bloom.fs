extern vec2 pixelSize;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 sum = vec4(0.0);
    float totalWeight = 0.0;
    float sigma = 4.0; // Standard deviation for the Gaussian
    float twoSigmaSq = 2.0 * sigma * sigma;

    // Horizontal blur
    for (int i = -5; i <= 5; i++) {
        float offset = float(i) * pixelSize.x;
        float weight = exp(-float(i * i) / twoSigmaSq);
        sum += Texel(texture, texture_coords + vec2(offset, 0.0)) * weight;
        totalWeight += weight;
    }
    
    // Vertical blur
    for (int j = -5; j <= 5; j++) {
        float offset = float(j) * pixelSize.y;
        float weight = exp(-float(j * j) / twoSigmaSq);
        sum += Texel(texture, texture_coords + vec2(0.0, offset)) * weight;
        totalWeight += weight;
    }

    return sum / totalWeight;
}
