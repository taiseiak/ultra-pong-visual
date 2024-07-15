// This uniform sets the color of anything drawn in the shader.
extern Image environmentMap;
extern vec2 viewPosition;
extern float metallic;
// extern float roughness;
extern float dispersionStrength;

vec2 refractLight(vec2 incident, vec2 normal, float eta) {
    float cosi = clamp(dot(incident, normal), -1.0, 1.0);
    float etai = 1.0, etat = eta;
    vec2 n = normal;
    if (cosi < 0.0) {
        cosi = -cosi;
    } else {
        float temp = etai;
        etai = etat;
        etat = temp;
        n = -normal;
    }
    float etaRatio = etai / etat;
    float k = 1.0 - etaRatio * etaRatio * (1.0 - cosi * cosi);
    return k < 0.0 ? vec2(0.0) : etaRatio * incident + (etaRatio * cosi - sqrt(k)) * n;
}

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}


// Love2D shaders work in the effect function
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 viewDir = normalize(viewPosition - screen_coords);
    vec2 normal = vec2(0.0, 0.0); // Default normal for a flat surface

    // Dispersion for RGB channels
    vec2 refractDirR = refractLight(viewDir, normal, 1.0 + dispersionStrength);
    vec2 refractDirG = refractLight(viewDir, normal, 1.0);
    vec2 refractDirB = refractLight(viewDir, normal, 1.0 - dispersionStrength);

    vec2 reflectDir = reflect(viewDir, normal);

    vec3 refractColorR = Texel(environmentMap, refractDirR * 0.5 + 0.5).rgb;
    vec3 refractColorG = Texel(environmentMap, refractDirG * 0.5 + 0.5).rgb;
    vec3 refractColorB = Texel(environmentMap, refractDirB * 0.5 + 0.5).rgb;

    vec3 refractColor = vec3(refractColorR.r, refractColorG.g, refractColorB.b);
    vec3 reflectColor = Texel(environmentMap, reflectDir * 0.5 + 0.5).rgb;

    float cosTheta = clamp(dot(viewDir, normal), 0.0, 1.0);
    vec3 F0 = vec3(0.04); // Fresnel reflectance at normal incidence
    F0 = mix(F0, color.rgb, metallic); // Mix with base color if metallic
    vec3 fresnel = fresnelSchlick(cosTheta, F0);

    vec3 finalColor = mix(refractColor, reflectColor, fresnel);

    return vec4(finalColor, 1.0);
}