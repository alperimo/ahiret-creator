#version 330 core

struct Material{
    //vec3 ambient; // es wird nicht mehr gebraucht, weil diffuse map(texture) auch ambient ist.
    sampler2D diffuse; //vec3 diffuse; // durch diffuse map(texture) wird ersetzt.
    sampler2D specular; //vec3 specular;
    sampler2D emission;
    vec3 specularStrength;
    float specularShininess;
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

void main()
{

    vec3 ambientLight = texture(material.diffuse, texCoord).rgb * (light.ambient);// material.ambient * (light.ambient)
    //vec3 ambientLight = clamp(ambientFactor, 0.1, 1.0);

    vec3 normalized_normalCoords = normalize(normalCoords);
    vec3 toLightVector;

    if (light.direction.w == 0.0) // use directional light
        toLightVector = normalize(vec3(-light.direction)); // negate für zum LigthVector, da light.direction von Lichtquelle zum Objekt
    else if(light.direction.w == 1.0) // use positional light
        toLightVector = normalize(lightPos_inView - viewCoords); // from viewCoords

    vec3 fromLightVector = -toLightVector; // to viewCoords
    float diffuseFactor = max(dot(normalized_normalCoords, toLightVector), 0.0);
    vec3 diffuseLight = diffuseFactor * texture(material.diffuse, texCoord).rgb * light.diffuse; // diffuseFactor * material.diffuse * light.diffuse;
    vec3 normalized_cameraDirection = normalize(-viewCoords); //cameraPos in View Space A = (0, 0, 0) camDirection = (0,0,0) - viewCoords;
    vec3 reflectedDirection = reflect(fromLightVector, normalized_normalCoords);

    vec3 specularStrength = material.specularStrength;
    float specularShininess = material.specularShininess * 128.0f;
    float specularFactor = pow(max(dot(normalized_cameraDirection, reflectedDirection), 0.0), specularShininess);
    vec3 specularLight = (specularStrength * specularFactor) * texture(material.specular, texCoord).rgb * light.specular;//(specularStrength * specularFactor) * light.specular;

    vec3 emissionLight = texture(material.emission, texCoord).rgb;

    if (light.pointLight) {
        float distance_ = length(toLightVector);
        float attenuation = 1.0 / (light.constant + (light.linear * distance_) + (light.quadratic * (distance_ * distance_)));

        ambientLight *= attenuation;
        diffuseLight *= attenuation;
        specularLight *= attenuation;
    }

    vec3 spotLight = vec3(0.0f);
    if (light.spotLight)
    {
        vec3 spotLightDirection = normalize(worldCoords - light.cameraPos);
        float theta = dot(spotLightDirection, normalize(light.cameraFront));
        float epsilon = light.outCutOff - light.cutOff;
        float spotlightFactor = clamp( ( (light.outCutOff - theta) / epsilon ), 0.0, 1.0);
        spotLight = (texture(material.diffuse, texCoord).rgb)/2 * spotlightFactor;
    }

    /*if (theta > light.cutOff) // angle olarak theta daha küçük olmalı ancak burada theta cosinus olduğu için angle küçük ise değeri büyük olmalı.
    {
        //
    }*/

    //vec3 result = (ambientLight + diffuseLight + specularLight) * objectColor;
    vec3 result = (ambientLight + diffuseLight + specularLight + spotLight); // emissionLight
    FragColor = vec4(result, 1.0); // beyaz isigin objenin uzerine vurmasiyle yansitilan renkler.
}

vec3 calculatePhongLight(){

}

vec3 hsl2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}
