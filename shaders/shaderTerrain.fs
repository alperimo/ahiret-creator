#version 330 core

const int textureUnitLimit = 4;

struct Material{
    sampler2D texture_diffuse[textureUnitLimit];
    sampler2D texture_specular[textureUnitLimit];
    sampler2D texture_emission[textureUnitLimit];
    vec3 specularStrength;
    float specularShininess;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 emission;

    bool texture_activ[3]; // texture_diffuse, texture_specular, texture_emission
};

struct Light{
    vec3 position;
    vec4 direction; // from lightSource to object;

    vec3 lightColor;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    bool pointLight;
    float constant;
    float linear;
    float quadratic;

    // spotlight/flashlight
    bool spotLight;
    vec3 cameraFront;
    vec3 cameraPos;
    float cutOff; // range [0, 1] = cos(angle)
    float outCutOff; // range [0, 1] = cos(angle)
};

in vec2 texCoord;

out vec4 FragColor;
  
/*in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixRate;*/

in vec3 normalCoords; //in View Space
in vec3 worldCoords;
in vec3 viewCoords;

//uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 lightPos;

in vec3 lightPos_inView;

uniform Material material;
uniform Light light;

vec3 hsl2rgb( in vec3 c );
void calculatePhongLighting(inout vec3 phongLight[4]);
void calculatePointLight(inout vec3 phongLight[4]);
void calculateSpotLight(inout vec3 spotLight);

void main()
{
    vec3 phongLight[4]; //0:ambientLight, 1:diffuseLight, 2:specularLight, 3:toLightVector
    calculatePhongLighting(phongLight);

    vec3 emission = (material.texture_activ[2]) ? texture(material.texture_emission[0], texCoord).rgb : material.emission;
    vec3 emissionLight = emission;

    calculatePointLight(phongLight);

    vec3 phongLightResult = phongLight[0] + phongLight[1] + phongLight[2];

    vec3 spotLight = vec3(0.0f);
    calculateSpotLight(spotLight);

    //vec3 result = (ambientLight + diffuseLight + specularLight) * objectColor;
    vec3 result = (phongLightResult + spotLight); // emissionLight
    FragColor = vec4(result, 1.0); // beyaz isigin objenin uzerine vurmasiyle yansitilan renkler.
}

void calculatePhongLighting(inout vec3 phongLight[4]){
    vec3 ambient = (material.texture_activ[0]) ? texture(material.texture_diffuse[0], texCoord).rgb : material.ambient;

    vec3 ambientLight = ambient * (light.ambient);// material.ambient * (light.ambient)

    //vec3 ambientLight = clamp(ambientFactor, 0.1, 1.0);

    vec3 normalized_normalCoords = normalize(normalCoords);
    vec3 toLightVector;

    if (light.direction.w == 0.0) // use directional light
        toLightVector = normalize(vec3(-light.direction)); // negate für zum LigthVector, da light.direction von Lichtquelle zum Objekt
    else if(light.direction.w == 1.0) // use positional light
        toLightVector = normalize(lightPos_inView - viewCoords); // from viewCoords

    vec3 fromLightVector = -toLightVector; // to viewCoords
    float diffuseFactor = max(dot(normalized_normalCoords, toLightVector), 0.0);
    vec3 diffuse = (material.texture_activ[0]) ? texture(material.texture_diffuse[0], texCoord).rgb : material.diffuse;
    vec3 diffuseLight = diffuseFactor * diffuse * light.diffuse; // diffuseFactor * material.diffuse * light.diffuse;
    vec3 normalized_cameraDirection = normalize(-viewCoords); //cameraPos in View Space A = (0, 0, 0) camDirection = (0,0,0) - viewCoords;
    vec3 reflectedDirection = reflect(fromLightVector, normalized_normalCoords);

    vec3 specularStrength = material.specularStrength;
    float specularShininess = material.specularShininess * 128.0f;
    float specularFactor = pow(max(dot(normalized_cameraDirection, reflectedDirection), 0.0), specularShininess);
    vec3 specular = (material.texture_activ[1]) ? texture(material.texture_specular[1], texCoord).rgb : material.specular;

    vec3 specularLight = (specularStrength * specularFactor) * specular * light.specular;//(specularStrength * specularFactor) * light.specular;

    phongLight[0] = ambientLight;
    phongLight[1] = diffuseLight;
    phongLight[2] = specularLight;
    phongLight[3] = toLightVector;
}

void calculatePointLight(inout vec3 phongLight[4]){
    vec3 toLightVector = phongLight[3];
    if (light.pointLight) {
        float distance_ = length(toLightVector);
        float attenuation = 1.0 / (light.constant + (light.linear * distance_) + (light.quadratic * (distance_ * distance_)));

        phongLight[0] *= attenuation;
        phongLight[1] *= attenuation;
        phongLight[2] *= attenuation;
    }
}

void calculateSpotLight(inout vec3 spotLight){
    if (light.spotLight)
    {
        vec3 spotLightDirection = normalize(worldCoords - light.cameraPos);
        float theta = dot(spotLightDirection, normalize(light.cameraFront));
        float epsilon = light.outCutOff - light.cutOff;
        float spotlightFactor = clamp( ( (light.outCutOff - theta) / epsilon ), 0.0, 1.0);
        spotLight = (texture(material.texture_diffuse[0], texCoord).rgb)/2 * spotlightFactor;
    }
}

vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}
