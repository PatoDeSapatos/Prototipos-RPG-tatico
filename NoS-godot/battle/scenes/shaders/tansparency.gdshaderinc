// transparency.gdshaderinc
render_mode depth_prepass_alpha;

global uniform vec2 player_screen_pos;
global uniform vec3 player_position;
global uniform vec3 camera_forward;

global uniform float radius;
global uniform float smoothness;
global uniform bool occlusion_active = false;

uniform sampler2D screen_space_texture : source_color, repeat_enable;

// Função que processa o efeito e retorna o ALBEDO e ALPHA finais
void apply_portal_effect(inout vec3 current_albedo, inout float current_alpha, sampler2D albedo_texture, vec2 screen_uv, vec2 uv, vec2 viewport_size, vec3 world_pos) {
    if (!occlusion_active) return;
	
	vec2 position_adjustment = vec2(0, -0.05);
    float aspect_ratio = viewport_size.x / viewport_size.y;
    vec2 correction = vec2(aspect_ratio, 1.0);
    
    float dist = length((screen_uv - player_screen_pos + position_adjustment) * correction);
    float inside_mask = 1.0 - smoothstep(radius - smoothness, radius, dist);

    vec4 tex_main = texture(albedo_texture, uv);
    
	float screen_aspect = viewport_size.x / viewport_size.y;
	
    vec2 scaled_screen_uv = screen_uv;
    scaled_screen_uv.x *= screen_aspect;
    vec4 tex_portal = texture(screen_space_texture, scaled_screen_uv);
	
    vec3 to_player = normalize(player_position - world_pos);

    current_albedo = mix(tex_main.rgb, tex_portal.rgb, inside_mask);
    current_alpha = mix(tex_main.a, tex_portal.a, inside_mask);

//
    //vec2 position_adjustment = vec2(0, -0.05);
    //
    //// 1. Cálculo do Círculo
    //float aspect_ratio = viewport_size.x / viewport_size.y;
    //vec2 correction = vec2(aspect_ratio, 1.0);
    //
    //float dist = length((screen_uv - player_screen_pos + position_adjustment) * correction);
    //float inside_mask = 1.0 - smoothstep(radius - smoothness, radius, dist);
//
    //// 2. Textura de Tela (Portal)
    //vec2 scaled_screen_uv = screen_uv;
    //scaled_screen_uv.x *= aspect_ratio;
    //vec4 tex_portal = texture(screen_space_texture, scaled_screen_uv);
    //
    //// 3. Mixagem
    //current_albedo = mix(current_albedo, tex_portal.rgb, inside_mask);
    //current_alpha = mix(current_alpha, tex_portal.a, inside_mask);
}