#version 330 core

struct Material{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 specularStrength;
    float specularShininess;
};

struct Light {
    vec3 position;

    vec3 lightColor;
    vec3 ambient;
    vec3 diffuseColor;
    vec3 specular;
};

out vec4 FragColor;
  
/*in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixRate;*/

in vec3 normalCoords; //in View Space
in vec3 worldCoords;
in vec3 viewCoords;

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 lightPos;

in vec3 lightPos_inView;

uniform Material material;
uniform Light light;

void main()
{
    //FragColor = mix(texture(texture1, texCoord), texture(texture2, texCoord), clamp(mixRate, 0.0, 1.0));
    //FragColor = vec4(0.8, 0.2, 0.1, 1);

    vec3 ambientFactor = material.ambient * (light.ambient * light.lightColor);//light.ambientColor * material.ambient;
    vec3 ambientLight = clamp(ambientFactor, 0.3, 1.0);

    vec3 normalized_normalCoords = normalize(normalCoords);

    vec3 toLightVector = normalize(lightPos_inView - viewCoords); // from viewCoords
    vec3 fromLightVector = -toLightVector; // to viewCoords
    float diffuseFactor = max(dot(normalized_normalCoords, toLightVector), 0.0);
    vec3 diffuseLight = diffuseFactor * material.diffuse * light.lightColor;//(diffuseFactor * material.diffuse) * light.diffuseColor;
    vec3 normalized_cameraDirection = normalize(-viewCoords); //cameraPos in View Space A = (0, 0, 0) camDirection = (0,0,0) - viewCoords;
    vec3 reflectedDirection = reflect(fromLightVector, normalized_normalCoords);

    vec3 specularStrength = material.specularStrength;
    float specularShininess = material.specularShininess;
    float specularFactor = pow(max(dot(normalized_cameraDirection, reflectedDirection), 0.0), specularShininess);
    vec3 specularLight = (specularStrength * specularFactor) * material.specular * light.lightColor;//(specularStrength * specularFactor) * light.specular;

    vec3 result = (ambientLight + diffuseLight + specularLight) * objectColor;
    FragColor = vec4(result, 1.0); // beyaz isigin objenin uzerine vurmasiyle yansitilan renkler.
}
