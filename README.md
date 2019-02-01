# openvino + docker + GUI

#### Build the Dockerfile with your UID and GID (*1000* by default)
``docker build -t openvino . --build-arg uid=$UID --build-arg gid=$GID``

*wait*... the build can take a moment

#### Run the image with your DISPLAY ENV and [share the X11 socket](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)
```docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/media:/workdir/media openvino```

#### Build the inference sample
```cd /opt/intel/computer_vision_sdk/inference_engine/samples/ && ./build_samples.sh```

#### Optional: set a MODELS env
```MODELS=$INSTALLDIR/deployment_tools/intel_models/```

#### Run an example
```cd ~/inference_engine_samples_build/intel64/Release && ./object_detection_demo_ssd_async -i /workdir/PATH_TO_YOUR_VIDEO -m $MODELS/pedestrian-and-vehicle-detector-adas-0001/FP32/pedestrian-and-vehicle-detector-adas-0001.xml -d CPU```