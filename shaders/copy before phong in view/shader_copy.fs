#version 330 core
out vec4 FragColor;
  
/*in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixRate;*/

in vec3 normalCoords;
in vec3 worldCoords;
in vec3 viewCoords;

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 lightPos;
uniform vec3 cameraPos;

uniform vec3 lightPos_inView;
uniform vec3 cameraPos_inView;

void main()
{
    //FragColor = mix(texture(texture1, texCoord), texture(texture2, texCoord), clamp(mixRate, 0.0, 1.0));
    //FragColor = vec4(0.8, 0.2, 0.1, 1);

    float ambientFactor = 0.1f;
    vec3 ambientLight = clamp(ambientFactor * lightColor, 0.2, 1.0);

    //vec3 normalized_worldCoords = normalize(worldCoords);
    //vec3 normalized_lightPos = normalize(lightPos);
    vec3 normalized_normalCoords = normalize(normalCoords);

    vec3 fromWorldToLightVector = normalize(lightPos - worldCoords); //lightDirection
    vec3 fromLightToWorldVector = normalize(worldCoords - lightPos);

    float diffuseFactor = max(dot(normalized_normalCoords, fromWorldToLightVector), 0.0);
    vec3 diffuseLight = diffuseFactor * lightColor;

    vec3 normalized_cameraDirection = normalize(cameraPos - worldCoords);
    vec3 reflectedDirection = reflect(fromLightToWorldVector, normalized_normalCoords);

    float specularStrength = 0.5;
    int specularShininess = 32;
    float specularFactor = pow(max(dot(normalized_cameraDirection, reflectedDirection), 0.0), specularShininess);
    vec3 specularLight = specularStrength * specularFactor * lightColor;

    //vec3 result = (ambientLight + diffuseLight + specularLight) * objectColor;
    vec3 result = (ambientLight + diffuseLight + specularLight) * objectColor;
    FragColor = vec4(result, 1.0); // beyaz isigin objenin uzerine vurmasiyle yansitilan renkler.
}
