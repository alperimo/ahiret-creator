#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
//layout (location = 1) in vec3 aColor;
//layout (location = 1) in vec2 aTexCoord;

//out vec3 ourColor;
//out vec2 texCoord;

out vec3 normalCoords;

out vec3 worldCoords;
out vec3 viewCoords;

out vec3 lightPos_inView;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

uniform mat4 modelMatrix_forNormal;

uniform vec3 lightPos_VS;

void main()
{
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(aPos, 1.0);
    worldCoords = vec3(modelMatrix * vec4(aPos, 1.0));
    normalCoords = mat3(modelMatrix_forNormal) * aNormal;
    viewCoords = vec3(viewMatrix * modelMatrix * vec4(aPos, 1.0))

    lightPos_inView = vec3(viewMatrix * vec4(lightPos, 1.0))
    //ourColor = aColor;
    //texCoord = aTexCoord;
}

// GLSL = openGL Shader Language
