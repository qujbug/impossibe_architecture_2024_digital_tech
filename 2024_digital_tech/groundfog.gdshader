shader_type fog;

uniform sampler2D noise_tex;
uniform float noise_scale = 1.0;

void fog() {

DENSITY = 1.0;
DENSITY *= step(0.0, -SDF);
ALBEDO = vec3(1.0, 0.87, 0.99);
EMISSION = vec3(0.99, 1.0, 0.78);
}
