FILE(REMOVE_RECURSE
  "../msg_gen"
  "../src/sensor_model_ardrone/msg"
  "../msg_gen"
  "CMakeFiles/ROSBUILD_genmsg_lisp"
  "../msg_gen/lisp/Measurement_data.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_Measurement_data.lisp"
  "../msg_gen/lisp/Feature_Keypoint.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_Feature_Keypoint.lisp"
  "../msg_gen/lisp/Feature_msg.lisp"
  "../msg_gen/lisp/_package.lisp"
  "../msg_gen/lisp/_package_Feature_msg.lisp"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/ROSBUILD_genmsg_lisp.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
