FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/sensor_model_ardrone/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_cpp"
  "../msg_gen/cpp/include/sensor_model_ardrone/Measurement_data.h"
  "../msg_gen/cpp/include/sensor_model_ardrone/Feature_Keypoint.h"
  "../msg_gen/cpp/include/sensor_model_ardrone/Feature_msg.h"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
