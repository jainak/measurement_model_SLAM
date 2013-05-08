
(cl:in-package :asdf)

(defsystem "sensor_model_ardrone-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Measurement_data" :depends-on ("_package_Measurement_data"))
    (:file "_package_Measurement_data" :depends-on ("_package"))
    (:file "Feature_Keypoint" :depends-on ("_package_Feature_Keypoint"))
    (:file "_package_Feature_Keypoint" :depends-on ("_package"))
    (:file "Feature_msg" :depends-on ("_package_Feature_msg"))
    (:file "_package_Feature_msg" :depends-on ("_package"))
  ))