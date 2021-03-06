#!/usr/bin/env bash

TF_CFLAGS=( $(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))') )
TF_LFLAGS=( $(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))') )

nvcc -std=c++11 -c -o tf_metric2weight_gpu.cu.o tf_metric2weight_gpu.cu \
  ${TF_CFLAGS[@]} -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

g++ -std=c++11 -shared -o tf_metric2weight_so.so tf_metric2weight.cpp \
  tf_metric2weight_gpu.cu.o ${TF_CFLAGS[@]} -fPIC -I/usr/local/cuda/include -lcudart -L/usr/local/cuda/lib64 ${TF_LFLAGS[@]}
