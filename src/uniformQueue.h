#ifndef UNIFORM_QUEUE_H
#define UNIFORM_QUEUE_H

#include "common.h"

#include <iostream>
#include <vector>
#include <variant>
#include <algorithm>
#include <memory>
#include <string>
#include <unordered_map>
#include <typeinfo>
#include <cstdlib>
#include <new>
#include <any>
#include <map>
#include <utility>

#ifdef _IS_ANDROID_

#include <EGL/egl.h>
#include "GLES3/gl3.h"
#include "glm.hpp"

#endif
#ifdef _IS_LINUX_
#include <EGL/egl.h>
#include <GL/glew.h>
#include <glm/glm.hpp>
#endif
#ifdef _IS_WIN_
#include <EGL/egl.h>
#include <GLES3/gl3.h>
#include <GL/glew.h>
#include <glm/glm.hpp>
#endif


using namespace std;

typedef enum {
    UNIFORM_BOOL,
    UNIFORM_INT,
    UNIFORM_FLOAT,
    UNIFORM_VEC2,
    UNIFORM_VEC3,
    UNIFORM_VEC4,
    UNIFORM_MAT2,
    UNIFORM_MAT3,
    UNIFORM_MAT4
} UniformType;

void setBool(const string &name, GLuint po, bool value);

void setInt(const string &name, GLuint po, int value);

void setFloat(const string &name, GLuint po, float value);

void setVec2(const string &name, GLuint po, const glm::vec2 &value);

void setVec2(const string &name, GLuint po, float x, float y);

void setVec3(const string &name, GLuint po, const glm::vec3 &value);

void setVec3(const string &name, GLuint po, float x, float y, float z);

void setVec4(const string &name, GLuint po, const glm::vec4 &value);

void setVec4(const string &name, GLuint po, float x, float y, float z, float w);

void setMat2(const string &name, GLuint po, const glm::mat2 &mat);

void setMat3(const string &name, GLuint po, const glm::mat3 &mat);

void setMat4(const string &name, GLuint po, const glm::mat4 &mat);

class UniformQueue {
public:
    UniformQueue();

    ~UniformQueue();

    void debug(const string &name);

    void setProgram(GLuint po) { this->programObject = po; }

    void addUniform(string name, UniformType type, void *val);

    bool setUniformValue(const string &, void *val);

    void sendAllUniforms();

    template<typename T>
    struct UniformStruct {
        UniformType type;
        T val;

        UniformStruct(UniformType type, const T &data)
                : type(type), val(data) {};
    };

    typedef UniformStruct<float> UNIFORM_FLOAT_t;
    typedef UniformStruct<glm::vec3> UNIFORM_VEC3_t;
    typedef UniformStruct<glm::vec4> UNIFORM_VEC4_t;

    map<string, any> uniforms;

private:
    static GLuint programObject;
};

#endif // UNIFORM_QUEUE_H