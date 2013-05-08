; Auto-generated. Do not edit!


(cl:in-package sensor_model_ardrone-msg)


;//! \htmlinclude Feature_msg.msg.html

(cl:defclass <Feature_msg> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (px
    :reader px
    :initarg :px
    :type cl:float
    :initform 0.0)
   (py
    :reader py
    :initarg :py
    :type cl:float
    :initform 0.0)
   (f
    :reader f
    :initarg :f
    :type sensor_model_ardrone-msg:Feature_Keypoint
    :initform (cl:make-instance 'sensor_model_ardrone-msg:Feature_Keypoint))
   (posX
    :reader posX
    :initarg :posX
    :type cl:float
    :initform 0.0)
   (posY
    :reader posY
    :initarg :posY
    :type cl:float
    :initform 0.0)
   (posZ
    :reader posZ
    :initarg :posZ
    :type cl:float
    :initform 0.0))
)

(cl:defclass Feature_msg (<Feature_msg>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Feature_msg>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Feature_msg)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name sensor_model_ardrone-msg:<Feature_msg> is deprecated: use sensor_model_ardrone-msg:Feature_msg instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:header-val is deprecated.  Use sensor_model_ardrone-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'px-val :lambda-list '(m))
(cl:defmethod px-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:px-val is deprecated.  Use sensor_model_ardrone-msg:px instead.")
  (px m))

(cl:ensure-generic-function 'py-val :lambda-list '(m))
(cl:defmethod py-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:py-val is deprecated.  Use sensor_model_ardrone-msg:py instead.")
  (py m))

(cl:ensure-generic-function 'f-val :lambda-list '(m))
(cl:defmethod f-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:f-val is deprecated.  Use sensor_model_ardrone-msg:f instead.")
  (f m))

(cl:ensure-generic-function 'posX-val :lambda-list '(m))
(cl:defmethod posX-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:posX-val is deprecated.  Use sensor_model_ardrone-msg:posX instead.")
  (posX m))

(cl:ensure-generic-function 'posY-val :lambda-list '(m))
(cl:defmethod posY-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:posY-val is deprecated.  Use sensor_model_ardrone-msg:posY instead.")
  (posY m))

(cl:ensure-generic-function 'posZ-val :lambda-list '(m))
(cl:defmethod posZ-val ((m <Feature_msg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_model_ardrone-msg:posZ-val is deprecated.  Use sensor_model_ardrone-msg:posZ instead.")
  (posZ m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Feature_msg>) ostream)
  "Serializes a message object of type '<Feature_msg>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'px))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'py))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'f) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'posX))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'posY))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'posZ))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Feature_msg>) istream)
  "Deserializes a message object of type '<Feature_msg>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'px) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'py) (roslisp-utils:decode-double-float-bits bits)))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'f) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'posX) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'posY) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'posZ) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Feature_msg>)))
  "Returns string type for a message object of type '<Feature_msg>"
  "sensor_model_ardrone/Feature_msg")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Feature_msg)))
  "Returns string type for a message object of type 'Feature_msg"
  "sensor_model_ardrone/Feature_msg")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Feature_msg>)))
  "Returns md5sum for a message object of type '<Feature_msg>"
  "140431f548ab202fcb69c43ce5985859")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Feature_msg)))
  "Returns md5sum for a message object of type 'Feature_msg"
  "140431f548ab202fcb69c43ce5985859")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Feature_msg>)))
  "Returns full string definition for message of type '<Feature_msg>"
  (cl:format cl:nil "Header header~%~%float64 px~%float64 py~%~%Feature_Keypoint f~%~%float64 posX~%float64 posY~%float64 posZ~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_Keypoint~%Header header~%~%float64 x~%float64 y~%~%float64 size~%float64 angle~%float64 response~%int32 octave~%int32 class_id~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Feature_msg)))
  "Returns full string definition for message of type 'Feature_msg"
  (cl:format cl:nil "Header header~%~%float64 px~%float64 py~%~%Feature_Keypoint f~%~%float64 posX~%float64 posY~%float64 posZ~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.secs: seconds (stamp_secs) since epoch~%# * stamp.nsecs: nanoseconds since stamp_secs~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_model_ardrone/Feature_Keypoint~%Header header~%~%float64 x~%float64 y~%~%float64 size~%float64 angle~%float64 response~%int32 octave~%int32 class_id~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Feature_msg>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     8
     8
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'f))
     8
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Feature_msg>))
  "Converts a ROS message object to a list"
  (cl:list 'Feature_msg
    (cl:cons ':header (header msg))
    (cl:cons ':px (px msg))
    (cl:cons ':py (py msg))
    (cl:cons ':f (f msg))
    (cl:cons ':posX (posX msg))
    (cl:cons ':posY (posY msg))
    (cl:cons ':posZ (posZ msg))
))
