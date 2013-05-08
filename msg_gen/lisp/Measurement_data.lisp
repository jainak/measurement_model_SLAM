; Auto-generated. Do not edit!


(cl:in-package sensor_model_ardrone-msg)


;//! \htmlinclude Measurement_data.msg.html

(cl:defclass <Measurement_data> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (features
    :reader features
    :initarg :features
    :type (cl:vector sensor_model_ardrone-msg:Feature_msg)
   :initform (cl:make-array 0 :element-type 'sensor_model_ardrone-msg:Feature_msg :initial-element (cl:make-instance 'sensor_model_ardrone-msg:Feature_msg))))
)

(cl:defclass Measurement_data (<Measurement_data>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Measurement_data>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Measurement_data)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name sensor_model_ardrone-msg:<Measurement_data> is deprecated: use sensor_model_ardrone-msg:Measurement_data instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Measurement_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:header-val is deprecated.  Use sensor_model_ardrone-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'features-val :lambda-list '(m))
(cl:defmethod features-val ((m <Measurement_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:features-val is deprecated.  Use sensor_model_ardrone-msg:features instead.")
  (features m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Measurement_data>) ostream)
  "Serializes a message object of type '<Measurement_data>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'features))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'features))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Measurement_data>) istream)
  "Deserializes a message object of type '<Measurement_data>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'features) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'features)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'sensor_model_ardrone-msg:Feature_msg))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Measurement_data>)))
  "Returns string type for a message object of type '<Measurement_data>"
  "sensor_model_ardrone/Measurement_data")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Measurement_data)))
  "Returns string type for a message object of type 'Measurement_data"
  "sensor_model_ardrone/Measurement_data")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Measurement_data>)))
  "Returns md5sum for a message object of type '<Measurement_data>"
  "3811ed9c9a95cff36a423c1adf3afc4c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Measurement_data)))
  "Returns md5sum for a message object of type 'Measurement_data"
  "3811ed9c9a95cff36a423c1adf3afc4c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Measurement_data>)))
  "Returns full string definition for message of type '<Measurement_data>"
  (cl:format cl:nil "Header header~%~%Feature_msg[] features~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_msg~%Header header~%~%float64 px~%float64 py~%~%Feature_Keypoint f~%~%float64 posX~%float64 posY~%float64 posZ~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_Keypoint~%Header header~%~%float64 x~%float64 y~%~%float64 size~%float64 angle~%float64 response~%int32 octave~%int32 class_id~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Measurement_data)))
  "Returns full string definition for message of type 'Measurement_data"
  (cl:format cl:nil "Header header~%~%Feature_msg[] features~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_msg~%Header header~%~%float64 px~%float64 py~%~%Feature_Keypoint f~%~%float64 posX~%float64 posY~%float64 posZ~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_Keypoint~%Header header~%~%float64 x~%float64 y~%~%float64 size~%float64 angle~%float64 response~%int32 octave~%int32 class_id~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Measurement_data>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'features) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Measurement_data>))
  "Converts a ROS message object to a list"
  (cl:list 'Measurement_data
    (cl:cons ':header (header msg))
    (cl:cons ':features (features msg))
))
