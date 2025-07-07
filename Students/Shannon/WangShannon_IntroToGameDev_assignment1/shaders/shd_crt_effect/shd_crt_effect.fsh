/* NOT MINE!!! CRT SURFACE SHADER EFFECT TUTORIAL*/

// shd_crt_effect.fsh

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main() {
    vec2 uv = v_vTexcoord;

    // screen curvature
    uv = uv * 2.0 - 1.0;
    uv.x *= 1.02 + (uv.y * uv.y) * 0.05;
    uv.y *= 1.02 + (uv.x * uv.x) * 0.05;
    uv = uv * 0.5 + 0.5;

	// uv.x += sin(uv.y * freq + speed) * amp
    uv.x += sin(uv.y * 5.0 + u_time * 2.0) * 0.0015;

    vec4 col = texture2D(gm_BaseTexture, uv);

    col.rgb *= 0.9 + 0.1 * sin(uv.y * 600.0);

    gl_FragColor = v_vColour * col;
}