FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/sensor_model_ardrone/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_py"
  "../src/sensor_model_ardrone/msg/__init__.py"
  "../src/sensor_model_ardrone/msg/_Measurement_data.py"
  "../src/sensor_model_ardrone/msg/_Feature_Keypoint.py"
  "../src/sensor_model_ardrone/msg/_Feature_msg.py"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_py.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
