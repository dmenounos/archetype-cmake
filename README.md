# CMake project archetype

This project creates project prototypes that use the CMAKE build system.

### Motivation

In the C and C++ world, especially the unix / linux / free / open source world, 
there is a great disparity in the build systems of many and well known projects.

In spite of unquestionable technicall excelence in developing algorithms it 
seems that people don't always put a lot of thought in the organization and 
structure of their projects.

Files representing sources, headers, resources, build configuration and all 
kinds of stuff thrown all together, many times in the same directory with the 
build artifacts. This situation is stressed with larger projects that consist 
of multiple modules.

Now, personally being a multi platform programmer, I have encountered and used 
a handful of different build systems with C/C++, Java, JavaScript and other 
languages. Thereby I have developed a sense of important properties that a 
build system should have - or would be great to have.

My favorite build system is Maven from Java. Before it became the dominant 
tool in its space, the picture in the Java world was pretty much similar to 
what I described above. But now all that is changed. Nearly 99% of the Java 
projects follow the principles that Maven put in place, even if they choose to 
use other newer competitive tools.

Lets see some of them in brief.

### Convention over Configuration

The build system endorses a common organization for its directory and file 
structure. Having this, reduces the required build configuration to a minimum.
People can deviate if they desire so, however that means that they take over 
the responsibility and the burden of configuring and maintaining their custom 
structure.

### Project Aggregation

Projects are composed of multiple modules in a hierarchical manner. The modules 
are aggregated in parent modules. We can think of the parent modules as groups 
or projects.

Individual modules can be built separately, but also holistically. This is done 
simply by invoking the same build commands from either the module directory or 
the project directory respectively.

### Project Inheritance

Each of the sub modules inherits configuration definitions, dependencies and 
resources from their parent module. This brings further down the amount of 
necessary configuration and applies the concept of reuse to the build system.

---

There are a ton of other features that Maven brings to the table, automatic 
dependencies management, declarative build definition language, standarized 
multi phase build pipeline, and so forth. However, these are advanced things 
and are not in the scope of this project. Instead it focuses on realizing the 3 
characteristics described above, in the simplest way possible, using nothing 
more but a reassonable structure.

---

Under the root directory we use the following project structure.

```
/root
|
+-- /module-a [1]
|   +-- /src
|   +-- CMakeLists.txt
|
+-- /module-b [1]
|   +-- /src
|   +-- CMakeLists.txt
|
+-- /cmake
|   +-- CMakeIncludes.txt [2]
|
+-- CMakeLists.txt [3]
```

---

At the root directory we find directories for each module of the project. In 
addition we find files that relate to the project build system and other meta 
information, such as instructions, descriptions, licences etc.

Under each module directory we find at least a directory where the source code 
resides, notably "src", and a configuration file for the build system. Here 
more directories can exist ofcourse for other purposes. For example we could 
have a "doc" directory with documentation for our module code.

[1] This structure covers the *convention over configuration* attribute.

---

Under the "cmake" directory we also find a file "CMakeIncludes.txt". In this 
file we define shared and project wide definitions and dependencies. Later on, 
this directory can contain more CMake utility files.

This file is included by the individual "CMakeLists.txt" files of each module 
of the project. For example.

```
include(../cmake/CMakeInclude.txt)
```

[2] This structure covers the *project inheritance* attribute.

---

Finally, in the root "CMakeLists.txt" file we aggregate the individual modules 
of the project. For example.

```
add_subdirectory(module-a)
add_subdirectory(module-b)
```

[3] This structure covers the *project aggregation* attribute.
