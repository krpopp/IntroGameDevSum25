/* NOT MINE!!! CRT SURFACE SHADER EFFECT TUTORIAL*/

// shd_crt_effect_min.fsh

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main() {
    vec2 uv = v_vTexcoord;

    uv = uv * 2.0 - 1.0;
    uv *= 1.001 + (uv * uv) * 0.01;
    uv = uv * 0.5 + 0.5;

    // horiz wave
    //uv.x += sin(uv.y * 8.0 + u_time * 2.0) * 0.0003;

    // scanlines
    float scanline = 0.96 + 0.03 * sin(uv.y * 960.0);
    
    vec4 col = texture2D(gm_BaseTexture, uv);
    col.rgb *= scanline;

    gl_FragColor = v_vColour * col;
}
