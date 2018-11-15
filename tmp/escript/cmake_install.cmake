# Install script for directory: /home/travis/build/PADrend/Tutorials/Site/tmp/escript

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Instructions" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Instructions/Instruction.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Instructions/InstructionBlock.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Objects/Callables" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Callables/FnBinder.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Callables/Function.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Callables/UserFunction.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Objects/Collections" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Collections/Array.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Collections/Collection.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Collections/Map.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Objects/Values" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Values/Bool.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Values/Number.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Values/String.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Values/Void.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Objects" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Exception.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/ExtObject.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/ExtReferenceObject.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Identifier.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Iterator.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Namespace.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Object.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/ReferenceObject.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/Type.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/YieldIterator.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Objects/typeIds.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Runtime" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Runtime/FunctionCallContext.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Runtime/RtValue.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Runtime/Runtime.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Runtime/RuntimeInternals.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Utils/IO" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/IO/AbstractFileSystemHandler.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/IO/DefaultFileSystemHandler.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/IO/IO.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/IO/IOBase.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript/Utils" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/Attribute.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/AttributeContainer.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/CodeFragment.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/ConversionBasics.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/Debug.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/DeclarationHelper.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/DeprecatedMacros.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/EReferenceCounter.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/Hashing.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/Logger.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/Macros.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/ObjArray.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/ObjRef.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/RuntimeHelper.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/StdConversions.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/StdFactories.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/StringData.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/StringId.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/StringUtils.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Utils/TypeNameMacro.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "headers" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/EScript" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Basics.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Consts.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/EScript.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/StdObjects.h"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/Version.h"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "runtimelibraries" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/EScript" TYPE DIRECTORY FILES "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/Std" FILES_MATCHING REGEX "/[^/]*\\.escript$")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "developmentlibraries" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/libEScript.a")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "developmentlibraries" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript/EScriptTargets.cmake")
    file(DIFFERENT EXPORT_FILE_CHANGED FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript/EScriptTargets.cmake"
         "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/CMakeFiles/Export/lib/cmake/EScript/EScriptTargets.cmake")
    if(EXPORT_FILE_CHANGED)
      file(GLOB OLD_CONFIG_FILES "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript/EScriptTargets-*.cmake")
      if(OLD_CONFIG_FILES)
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript/EScriptTargets.cmake\" will be replaced.  Removing files [${OLD_CONFIG_FILES}].")
        file(REMOVE ${OLD_CONFIG_FILES})
      endif()
    endif()
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript" TYPE FILE FILES "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/CMakeFiles/Export/lib/cmake/EScript/EScriptTargets.cmake")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript" TYPE FILE FILES "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/CMakeFiles/Export/lib/cmake/EScript/EScriptTargets-release.cmake")
  endif()
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "developmentlibraries" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/EScript" TYPE FILE FILES
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScriptConfig.cmake"
    "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScriptConfigVersion.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/travis/build/PADrend/Tutorials/Site/tmp/escript/EScript/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/travis/build/PADrend/Tutorials/Site/tmp/escript/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
