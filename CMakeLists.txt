cmake_minimum_required(VERSION 2.8)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  if(DEFINED ENV{VITASDK})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VITASDK}/share/vita.toolchain.cmake" CACHE PATH "toolchain file")
  else()
    message(FATAL_ERROR "Please define VITASDK to point to your SDK path!")
  endif()
endif()

project(nosleep)
include("${VITASDK}/share/vita.cmake" REQUIRED)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wall -O3 -std=gnu99")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fno-rtti -fno-exceptions")

include_directories(
)

link_directories(
  ${CMAKE_CURRENT_BINARY_DIR}
)

add_executable(nosleep.elf
  main.c
)

target_link_libraries(nosleep.elf
  SceLibKernel_stub
  SceThreadmgrForDriver_stub
  SceIofilemgrForDriver_stub
  SceKernelSuspendForDriver_stub
  gcc
)

set_target_properties(nosleep.elf
	PROPERTIES LINK_FLAGS "-nostdlib"
	COMPILE_FLAGS "-D__VITA_KERNEL__"
)

add_custom_target(nosleep.skprx ALL
	COMMAND vita-elf-create -e ${CMAKE_SOURCE_DIR}/nosleep.yml nosleep.elf nosleep.velf ${CMAKE_SOURCE_DIR}/taihen.json
	COMMAND vita-make-fself -c nosleep.velf nosleep.skprx
)
add_dependencies(nosleep.skprx nosleep.elf)

add_custom_target(send
	COMMAND curl -T nosleep.skprx ftp://$(PSVITAIP):1337/ux0:/tai/
	DEPENDS nosleep.skprx
)
