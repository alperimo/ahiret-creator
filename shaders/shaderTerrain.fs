#version 330 core

uniform sampler2D textures[4];

in vec2 texCoord;

out vec4 FragColor;  

void main()
{
    vec2 texCoord = texCoord * 120;
    vec3 result = texture(textures[0], texCoord).rgb;
    FragColor = vec4(result, 1.0); //vec4(1.0);
}
