extern float texelWidth;
extern float texelHeight;
extern float sigma;
extern float bloomIntensity;

const int kernelSize = 9;
float weights[kernelSize];

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 sum = vec4(0.0);

    // Calculate Gaussian weights
    float norm = 1.0 / (sqrt(2.0 * 3.141592653589793 * sigma * sigma));
    float coeff = 1.0 / (2.0 * sigma * sigma);
    for (int i = 0; i < kernelSize; ++i) {
        float x = float(i - kernelSize / 2);
        weights[i] = norm * exp(-x * x * coeff);
    }

    // Horizontal blur
    for (int i = 0; i < kernelSize; ++i) {
        float offset = float(i - kernelSize / 2) * texelWidth;
        sum += Texel(texture, vec2(texture_coords.x + offset, texture_coords.y));
    }

    vec4 horizontalBlur = sum;

    // Vertical blur
    sum = vec4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = float(i - kernelSize / 2) * texelHeight;
        sum += Texel(texture, vec2(texture_coords.x, texture_coords.y + offset));
    }

    vec4 verticalBlur = sum;

    vec4 finalColor = (horizontalBlur + verticalBlur) * 0.5 * bloomIntensity;
    return finalColor * vec4(1.0, 1.0, 1.0, 0.2);
}