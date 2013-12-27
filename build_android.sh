make clean
export SCRATCH=/Volumes/Fatty/workspace/scratch
export NDK=/Volumes/Fatty/workspace/android-ndk-r9b
export TOOLCHAIN=${SCRATCH}/ffmpeg_toolchain
# ${NDK}/build/tools/make-standalone-toolchain.sh --install-dir=$TOOLCHAIN
export SYSROOT=$TOOLCHAIN/sysroot
export PATH=$TOOLCHAIN/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar


# CFLAGS="-O3 -Wall -mthumb -pipe -fpic -fasm \
#   -finline-limit=300 -ffast-math \
#   -fstrict-aliasing -Werror=strict-aliasing \
#   -fmodulo-sched -fmodulo-sched-allow-regmoves \
#   -Wno-psabi -Wa,--noexecstack \
#   -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ \
#   -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ \
#   -DANDROID -DNDEBUG "

CFLAGS="-DANDROID"
  
EXTRA_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mvectorize-with-neon-quad"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -llog"

FFMPEG_FLAGS="--prefix=/${SCRATCH}/build \
  --target-os=linux \
  --arch=arm \
  --enable-cross-compile \
  --cross-prefix=arm-linux-androideabi- \
  --disable-ffplay \
  --disable-ffprobe \
  --disable-ffserver \
  --disable-neon \
  --disable-network \
  --disable-demuxer=sbg \
  --enable-parsers \
  --enable-demuxers \
  --enable-gpl \
  --enable-pic \
  --enable-decoders \
  --enable-encoders \
  --enable-version3 \
  --enable-decoder=mjpeg --enable-demuxer=mjpeg --enable-parser=mjpeg \
  --enable-demuxer=image2 --enable-muxer=mp4"

#  --enable-demuxer=image2 --enable-muxer=mp4 --enable-encoder=libx264"

#  --enable-libx264  \
#  --extra-cflags=\"-I../x264\" \
#  --extra-ldflags=\"-L../x264\" \

./configure $FFMPEG_FLAGS --extra-cflags="$CFLAGS $EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS"  
  
make -j4 

# pull all of the object files together into a static library
$TOOLCHAIN/bin/arm-linux-androideabi-ar rcs libffmpeg_android.a libavutil/*.o libavutil/arm/*.o libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libswresample/*.o libswresample/arm/*.o   libswscale/*.o libavfilter/*.o libavfilter/libmpcodecs/*.o   ./ffmpeg_opt.o  ./ffmpeg_filter.o   compat/*.o libpostproc/*.o  libavdevice/*.o libswscale/*.o libswscale/arm/*.o



