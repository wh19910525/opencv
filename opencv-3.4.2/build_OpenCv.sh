#! /bin/bash
#############################
#author:nexgo
#############################

pc_out="pc_out"
android_out="android_out"

##########################################
#
# Wang Hai's commonly used linux commands.
#
if [ -z ${WANGHAI_USUAL_SHELL_CMD} ] || [ ! -e ${WANGHAI_USUAL_SHELL_CMD} ];then
    echo -en "\033[32m"
    echo "please import Wang Hai's commonly used linux commands."
    echo -en "\033[0m"

    exit 45
else
    echo "import [${WANGHAI_USUAL_SHELL_CMD}]"
    source ${WANGHAI_USUAL_SHELL_CMD}
fi

##########################################

pc_version_cmd="cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .."

android_version_cmd="cmake \
    -DANDROID_ABI=armeabi \
    -DCMAKE_TOOLCHAIN_FILE=../platforms/android/android.toolchain.cmake \
    -DANDROID_NDK=${NDK_ROOT} \
    -DANDROID_SDK_ROOT=${SDK_ROOT} \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
    -DBUILD_ANDROID_PROJECTS=OFF \
    .."

##########################################

##################### main #####################

echo -e "\033[2J"
print_color "1:android"
print_color "2:pc[default]"
echo

print_color "Please input your arch:"
read cpu_arch_name

if [ x${cpu_arch_name} == xandroid  -o x${cpu_arch_name} == x1 ];then
    if [ -z ${NDK_ROOT} ] || [ ! -e ${NDK_ROOT} ];then
        print_color "[${NDK_ROOT}] do not exist."
        exit 1
    fi
    print_color "start build [android] version ..."
    out_dir=${android_out}
    cmake_cmd=${android_version_cmd}
else
    print_color "start build [pc] version ..."
    out_dir=${pc_out}
    cmake_cmd=${pc_version_cmd}
fi

confirm_selection ${cpu_arch_name}

mkdir ${out_dir} -p
cd ${out_dir}

exec_cmd ${cmake_cmd}

exec_cmd "make -j28"

exec_cmd "sudo make install"

cd -

