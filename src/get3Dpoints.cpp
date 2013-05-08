//Includes all the headers necessary to use the most common public pieces of the ROS system.
#include <ros/ros.h>
//Use image_transport for publishing and subscribing to images in ROS
#include <image_transport/image_transport.h>
//Use cv_bridge to convert between ROS and OpenCV Image formats
#include <cv_bridge/cv_bridge.h>
//Include headers for OpenCV Image processing
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/nonfree/features2d.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/legacy/legacy.hpp>

#include <visualization_msgs/Marker.h>
#include <geometry_msgs/Point.h>
#include <geometry_msgs/PoseStamped.h>
#include "sensor_msgs/image_encodings.h"
#include <sensor_model_ardrone/Feature_msg.h>
#include <sensor_model_ardrone/Measurement_data.h>
#include <stdexcept>

#include <cmath>
#include <math.h>

using namespace cv;
using namespace std;
//namespace enc = sensor_msgs::image_encodings;


using namespace sensor_msgs::image_encodings;
//image_transport::Publisher img_pub;
ros::Publisher marker_pub;
ros::Publisher pose_pub;
ros::Publisher measurement_pub;
static const char WINDOW[] = "Output";

int edgeThresh = 1;
int lowThreshold = 15;
int ratio = 3;
int kernel_size = 3;

Mat image_t_minus_1;
Mat image_t_minus_2;
Mat image_t_minus_3;
float rC[3] = {0};
float qC[4] = {0};
//Mat qC = Mat(1,4,CV_64F);
float focal = 209.12;
float radial_distortion = 0.00000003;
float u0c = 160.194;
float v0c = 121.474;
float timeStep = 0.1;
float vx = 0.5;

Mat image_t_minus_4 ,image_t_minus_5 ,image_t_minus_6;
int frame_it = 0, frame_num = 1;

class SIFT_Feature{

public:
	float r[3];
	float q[4];
	float u0, v0, ut, vt;
	KeyPoint data;
	geometry_msgs::Point position;
		
	void initiate(float trans[], float quat[], float U0, float V0, float Ut, float Vt, KeyPoint feat_data){
		memcpy (r, trans, sizeof (trans));
		memcpy (q, quat, sizeof (quat));
		u0 = U0;
		v0 = V0;
		ut = Ut;
		vt = Vt;
		data = feat_data;
	}
};

vector<SIFT_Feature> candidates;

Mat edgeDetector(Mat image){

	Mat dst, detected_edges, image_gray;
	
	/// Create a matrix of the same type and size as src (for dst)
	//dst.create( image.size(), image.type() );
	//blur( image, dst, Size( 5, 5 ), Point(-1,-1) );
	GaussianBlur( image, dst, Size( 3, 3 ), 0, 0 );
	/// Convert the image to grayscale
	
	cvtColor( image, image_gray, CV_BGR2GRAY );
	
	/// Reduce noise with a kernel 3x3
	blur( image, detected_edges, Size(3,3) );
	
	/// Canny detector
	Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
	
	/// Using Canny's output as a mask, we display our result
	dst = Scalar::all(0);
	
	image.copyTo( dst, detected_edges);
	return dst;
	
}

Mat quat_to_rot(float q[]){
	Mat R = Mat(3,3,CV_64F);
	
	R.at<float>(0,0) = (q[0]*q[0] + q[1]*q[1] - q[2]*q[2] - q[3]*q[3]);
	R.at<float>(0,1) = 2*(q[1]*q[2] - q[0]*q[3]);
	R.at<float>(0,2) = 2*(q[0]*q[2] - q[1]*q[3]);
	R.at<float>(1,0) = 2*(q[1]*q[2] - q[0]*q[3]);
	R.at<float>(1,1) = (q[0]*q[0] + q[1]*q[1] - q[2]*q[2] - q[3]*q[3]);
	R.at<float>(1,2) = 2*(q[2]*q[3] - q[0]*q[1]);
	R.at<float>(2,0) = 2*(q[1]*q[3] - q[0]*q[2]);
	R.at<float>(2,1) = 2*(q[1]*q[2] - q[2]*q[3]);
	R.at<float>(2,2) = (q[0]*q[0] + q[1]*q[1] - q[2]*q[2] - q[3]*q[3]);
	
	return R;
	//return return_mat;
}

Mat hc(float u0, float v0, float ut, float vt){
		
	//float returnVal[3] = {(u0 - ut)/focal, (v0 - vt)/focal, 1 };
	//cout << "returnVal hc:" << returnVal[0] << " " << returnVal[1] << " " << returnVal[2] << endl;
	Mat returnMat = Mat(3,1,CV_64F);//, returnVal);
	//returnMat.at<float>(0,0) = (u0 - ut)/focal;
	//returnMat.at<float>(1,0) = (v0 - vt)/focal;
	
	
	returnMat.at<float>(0,0) = (u0c - ut)/focal;
	returnMat.at<float>(1,0) = (v0c - vt)/focal;
	returnMat.at<float>(2,0) = 1;
	
	return returnMat;
}

Mat calculate3DPoint( Mat ht, float alpha, float beta, float baseline){
	
	float elevation = atan2(-ht.at<float>(0,1), sqrt(pow(ht.at<float>(0,0),2) + pow(ht.at<float>(0,2),2)));
	float azimuth = atan2(ht.at<float>(0,0), ht.at<float>(0,2));
	float depth = abs((baseline*sin(beta))/sin(alpha));
	Mat world_co = Mat(1,3,CV_64F);
	//cout << "Azimuth:" << azimuth << endl;
	ROS_INFO("Azimuth %f", azimuth);
	ROS_INFO("Elevation %f", elevation);
	//cout << "Elevation:" << elevation << endl;
	
	double thresh_parallax = 0.0001;
	double thresh_depth = 4.0;
	//double thresh_x_axis = 50.0;
	if(abs(alpha) > thresh_parallax && depth < thresh_depth){
		world_co.at<float>(0,0) = rC[0] + depth*cos(elevation)*cos(azimuth);
		world_co.at<float>(0,1) = rC[1] + depth*cos(elevation)*sin(azimuth);//*cos(elevation);
		world_co.at<float>(0,2) = rC[2] + depth*sin(elevation);
	}else{
		world_co.at<float>(0,0) = 0.0;
		world_co.at<float>(0,1) = 0.0;
		world_co.at<float>(0,2) = 0.0;
	}

	return world_co;
}

Mat transpose(Mat h){
	Mat returnMat = Mat(1,3,CV_64F);
	
	returnMat.at<float>(0,0) = h.at<float>(0,0);
	returnMat.at<float>(0,1) = h.at<float>(1,0);
	returnMat.at<float>(0,2) = h.at<float>(2,0);
	
	return returnMat;
}

Mat calculateParallax(SIFT_Feature f, float ut, float vt){
	//cout << "p0:" << f.u0 << "," << f.v0 << endl;
	//cout << "p1:" << f.ut << "," << f.vt << endl;
	//cout << "pt:" << ut << "," << vt << endl;
	
	
	Mat h1, ht;
	//Calculate undistorted pixels
	float r1 = sqrt((f.ut - u0c)*(f.ut - u0c) + ((f.vt - v0c)*(f.vt - v0c)));
	float u1u = ((f.ut - u0c)/sqrt(1.0 - 2.0*radial_distortion*r1*r1)) + u0c;
	float v1u = ((f.vt - v0c)/sqrt(1.0 - 2.0*radial_distortion*r1*r1)) + v0c;
	
	float rt = sqrt((ut - u0c)*(ut - u0c) + ((vt - v0c)*(vt - v0c)));
	float utu = ((ut - u0c)/sqrt(1.0 - 2.0*radial_distortion*rt*rt)) + u0c;
	float vtu = ((vt - v0c)/sqrt(1.0 - 2.0*radial_distortion*rt*rt)) + v0c;
		
	Mat hc1 = hc(f.u0, f.v0, u1u, v1u);
	Mat hct = hc(f.u0, f.v0, utu, vtu);
	
	//Mat hc1 = hc(f.u0, f.v0, f.ut, f.vt);
	//Mat hct = hc(f.u0, f.v0, ut, vt);
	//cout << "hc1: " << hc1.at<float>(0,0) << " " << hc1.at<float>(1,0) << " " << hc1.at<float>(2,0) << endl;
	//cout << "hct: " << hct.at<float>(0,0) << " " << hct.at<float>(1,0) << " " << hct.at<float>(2,0) << endl;
	
	Mat rot_1 = quat_to_rot(qC);
	Mat rot_t = quat_to_rot(qC);
	
	//gemm(rot_1,hc1, 1, NULL, 0, h1, 0);
	//gemm(rot_t,hct, 1, NULL, 0, ht, 0);
	h1 = transpose(hc1);
	ht = transpose(hct);
	
	//cout << "h1: " << h1.at<float>(0,0) << " " << h1.at<float>(0,1) << " " << h1.at<float>(0,2) << endl;
	//cout << "ht: " << ht.at<float>(0,0) << " " << ht.at<float>(0,1) << " " << ht.at<float>(0,2) << endl;
	Mat b1 = Mat(1,3,CV_64F);
	b1.at<float>(0,0) = 2.0*vx*timeStep;
	b1.at<float>(0,1) = 0;
	b1.at<float>(0,2) = 0;
	
	Mat b2 = Mat(1,3,CV_64F);
	b2.at<float>(0,0) = -2.0*vx*timeStep;
	b2.at<float>(0,1) = 0;
	b2.at<float>(0,2) = 0;
	
	float alpha = 0.0, beta = 0.0, gamma = 0.0, h1norm = 0.0, htnorm = 0.0, base = 0.0;
	
	for (int i = 0; i < 3; i++){
		beta += (b1.at<float>(0,i) * h1.at<float>(0,i));
		gamma += (b2.at<float>(0,i) * ht.at<float>(0,i));
	}
	h1norm = sqrt(h1.at<float>(0,0)*h1.at<float>(0,0) + h1.at<float>(0,1)*h1.at<float>(0,1) + h1.at<float>(0,2)*h1.at<float>(0,2));
	htnorm = sqrt(ht.at<float>(0,0)*ht.at<float>(0,0) + ht.at<float>(0,1)*ht.at<float>(0,1) + ht.at<float>(0,2)*ht.at<float>(0,2));
	base = sqrt(b1.at<float>(0,0)*b1.at<float>(0,0) + b1.at<float>(0,1)*b1.at<float>(0,1) + b1.at<float>(0,2)*b1.at<float>(0,2));
	
	beta = acos(beta/(h1norm*base));
	gamma = acos(gamma/(htnorm*base));
	
	alpha = 3.14 - (beta + gamma);
	ROS_INFO("Alpha: %f", alpha);
	//cout << "beta: " << beta << " Gamma: " << gamma << endl;
	//cout << "h1norm: " << h1norm << " htnorm: " << htnorm << endl;
	//cout << "Alpha " << alpha << endl;
	//Mat world_co = Mat(1,3,CV_64F);
	
	Mat world_co  = calculate3DPoint(ht, alpha, beta, base);
	
	//cout << "3D point: " << world_co.at<float>(0,0) << "," << world_co.at<float>(0,1) << "," << world_co.at<float>(0,2) << endl << endl;
	return world_co;
	
}

void updateRobotTransform(){
	
	rC[0] = rC[0] + vx*timeStep;
	//cout << "POS:" << rC[0] << endl;
}

visualization_msgs::Marker points;
geometry_msgs::PoseStamped pose;

void matchFeatures(Mat input_image, Mat image_t1, Mat image_t2, Mat image_t3){
	//Set pose to be published
	pose.header.frame_id = "\my_frame";
	pose.header.stamp = ros::Time::now();
    pose.pose.position.x = rC[0];
	pose.pose.position.y = rC[1];
	pose.pose.position.z = rC[2];

	pose.pose.orientation.x = qC[0];
	pose.pose.orientation.y = qC[1];
	pose.pose.orientation.z = qC[2];
	pose.pose.orientation.w = qC[3];
	
	//Set type of point to be published
    points.header.frame_id = "/my_frame";
    points.header.stamp = ros::Time::now();
    points.ns = "sensor_data_pointcloud";
    points.action = visualization_msgs::Marker::ADD;
    points.pose.orientation.w = 1.0;
    points.id = 1;
    points.type = visualization_msgs::Marker::POINTS;
    // POINTS markers use x and y scale for width/height respectively
    points.scale.x = 0.1;
    points.scale.y = 0.1;
    // Points are green
    points.color.g = 1.0f;
    points.color.a = 1.0;
	
	ROS_INFO("Matching features...");
	Mat im1, im2, im3, im4;
	
	im1 = input_image;
	im2 = image_t1;
	im3 = image_t2;
	im4 = image_t3;
	
	Mat disparity_image = im3.clone();
	
	//SiftFeatureDetector detector;
	SurfFeatureDetector detector;
	vector<KeyPoint> keypoints1, keypoints2, keypoints3, keypoints4;
	Mat descriptors1, descriptors2, descriptors3, descriptors4;
	
	detector.detect(im1, keypoints1);
	detector.detect(im2, keypoints2);
	detector.detect(im3, keypoints3);
	detector.detect(im4, keypoints4);
	
	
	//SiftDescriptorExtractor extractor;
	SurfDescriptorExtractor extractor;
	extractor.compute( im1, keypoints1, descriptors1 );
	extractor.compute( im2, keypoints2, descriptors2 );
	extractor.compute( im3, keypoints3, descriptors3 );
	extractor.compute( im4, keypoints4, descriptors4 );

	//FlannBasedMatcher matcher;
	FlannBasedMatcher matcher;// = new BFMatcher(NORM_HAMMING,false);
	vector<DMatch> matches;
	matcher.match(descriptors1, descriptors2, matches);
	
	double max_dist = 0; double min_dist = 100;
	
	//-- Quick calculation of max and min distances between keypoints
	for( int i = 0; i < descriptors1.rows; i++ ){ 
		double dist = matches[i].distance;
		if( dist < min_dist ) 
			min_dist = dist;
		if( dist > max_dist ) 
			max_dist = dist;
  	}

  	//cout << "-- Max dist : %f \n", max_dist );
  	//cout << "-- Min dist : %f \n", min_dist );

  	//-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist )
  	//-- PS.- radiusMatch can also be used here.
  	vector<DMatch> good_matches;

  	for( int i = 0; i < descriptors1.rows; i++ ){ 
  		if( matches[i].distance < 4*min_dist ){
  			good_matches.push_back( matches[i]); 
  		}
  	}

	ROS_INFO("Updating transform... ");
	updateRobotTransform();
	//updateCandidates(im1, keypoints2, good_matches);
	vector<KeyPoint> consistent_candidates;
	vector<sensor_model_ardrone::Feature_msg> feature_pub;
	int flag_frame_drop = 1;
	
	for (int i = 0; i < keypoints2.size(); i++){
		bool match_flag = false;
		bool consistent_feature = false;
		Mat des_temp;
		vector<DMatch> match_check;
		vector<KeyPoint> k1;
		k1.push_back(keypoints2[i]);
		extractor.compute( im3, k1, des_temp );
		//Get all matches of descriptor of keypoint from im(t) with descriptors at t-1
		matcher.match(descriptors3, des_temp, match_check);
		//cout << "Size:" << match_check.size() << endl;
		//cout << "Size1:" << keypoints2.size() << endl;
		
		min_dist = 100;
		max_dist = 0;
		
		for( int k = 0; k < des_temp.rows; k++ ){ 
			double dist = match_check[i].distance;
			if( dist < min_dist ) 
				min_dist = dist;
			if( dist > max_dist ) 
				max_dist = dist;
  		}
  		int match_ind = 0;
  		float pix_thresh = 5.0;
  		for (int k = 0; k < match_check.size(); k++){
			if( match_check[k].distance <= 4*min_dist ){
				if (abs(keypoints3[match_check[k].queryIdx].pt.x - k1[match_check[k].trainIdx].pt.x) < pix_thresh && abs(keypoints3[match_check[k].queryIdx].pt.y - k1[match_check[k].trainIdx].pt.y) < pix_thresh){
		  				consistent_feature = true;
		  				match_ind = k;
		  				break;
		  		}else{
  					consistent_feature = false;
  				}
  			}
  			else{
  				consistent_feature = false;
  			}
		}
		//match_flag = false;
		for (int j = 0; j < good_matches.size(); j++){
			if (i == good_matches[j].trainIdx)
				match_flag = true;
			else
				match_flag = false;
			//cout << "x:" << keypoints1[good_matches[j].queryIdx].pt.x << endl;
			SIFT_Feature f;
			
			f.initiate(rC, qC, keypoints3[match_check[match_ind].queryIdx].pt.x, keypoints3[match_check[match_ind].queryIdx].pt.y, keypoints2[good_matches[j].trainIdx].pt.x, keypoints2[good_matches[j].trainIdx].pt.y, keypoints3[match_check[match_ind].queryIdx]);
			/*cout << "k3:"<<keypoints3[match_check[match_ind].queryIdx].pt.x << "," << keypoints3[match_check[match_ind].queryIdx].pt.y << endl;
			cout << "k2:"<<keypoints2[good_matches[j].trainIdx].pt.x << "," << keypoints2[good_matches[j].trainIdx].pt.y << endl;
			cout << "k1:" << keypoints1[good_matches[j].queryIdx].pt.x << "," << keypoints1[good_matches[j].queryIdx].pt.y << endl;*/
			if (match_flag && consistent_feature){
				//Add new feature candidtes
				Mat pointMapping = calculateParallax(f, keypoints1[good_matches[j].queryIdx].pt.x, keypoints1[good_matches[j].queryIdx].pt.y);
				line(disparity_image, keypoints1[good_matches[j].queryIdx].pt, keypoints3[match_check[match_ind].queryIdx].pt, Scalar(255,0,255), 2, 8);
				circle(disparity_image, keypoints1[good_matches[j].queryIdx].pt, 1.5, Scalar(255,255,0), -1, 8);
				circle(disparity_image, keypoints3[match_check[match_ind].queryIdx].pt, 1.5, Scalar(255,255,0), -1, 8);  
				
				geometry_msgs::Point p;
				sensor_model_ardrone::Feature_msg feat_msg;
			    p.x = pointMapping.at<float>(0,0);
      			p.y = pointMapping.at<float>(0,1);
      			p.z = pointMapping.at<float>(0,2);
				flag_frame_drop = 0;
				
				double x_thresh = 0.3;
				double y_thresh = 0.3;
				double z_thresh = 0.3;
				if (abs(p.x-rC[0]) > x_thresh && abs(p.y-rC[0]) > y_thresh && abs(p.z-rC[0]) > z_thresh){
					f.position = p;
					consistent_candidates.push_back(f.data);
					candidates.push_back(f);
					points.points.push_back(p);
					
					feat_msg.px = f.ut;
					feat_msg.py = f.vt;
					
					feat_msg.f.x = f.data.pt.x;
					feat_msg.f.y = f.data.pt.y;
					feat_msg.f.size = f.data.size;
					feat_msg.f.response = f.data.response;
					feat_msg.f.octave = f.data.octave;
					feat_msg.f.class_id = f.data.class_id;
					
					feat_msg.posX = p.x;
					feat_msg.posY = p.y;
					feat_msg.posZ = p.z;
					
					feature_pub.push_back(feat_msg);
					
					break;				
				}else
					continue;
				
				
			}
			if (!consistent_feature){
				//Update feature
				//continue;
				//candidates.push_back(f);
			}
		}
	}
	
	//cout << "K1:" << keypoints1.size() << "\t K2:" << keypoints2.size() << "\t M:" << matches.size() << endl;
	
	// Display keypoints at time t
	/*Mat outputMatch, out1, out2, out3, out4;
	Scalar keypointColor = Scalar(255, 0, 0);     // Blue keypoints.
	drawKeypoints(im1, keypoints1, out1, keypointColor, DrawMatchesFlags::DEFAULT);
	imshow("time 0", out1);
	
	// Display keypoints at time t-1
	keypointColor = Scalar(255, 255, 255);     // Black keypoints.
	drawKeypoints(im2, keypoints2, out2, keypointColor, DrawMatchesFlags::DEFAULT);
	imshow("time 1", out2);
	
	
	Scalar matchesColor = Scalar(0, 0, 255);     // Red matches good matches
	drawMatches( im1, keypoints1, im2, keypoints2, good_matches, outputMatch, matchesColor, keypointColor, vector<char>());
	imshow(WINDOW, outputMatch);	
	
	// Display new candidate keypoints
	keypointColor = Scalar(0, 255, 0);     // Green Consistent keypoints
	drawKeypoints(im3, consistent_candidates, out3, keypointColor, DrawMatchesFlags::DEFAULT);
	imshow(" time 2", out3);
	*/
	//Display disparity image
	/*matchesColor = Scalar(0, 0, 255);     // Red matches good matches
	drawMatches( im1, k1, im2, keypoints2, good_matches, outputMatch, matchesColor, keypointColor, vector<char>());
	imshow(WINDOW, outputMatch);	
	*/
	//ROS_INFO("FLAG: %d",flag_frame_drop);
	if (flag_frame_drop==1){
		geometry_msgs::Point p;
		p.x = 0.0;
      	p.y = 0.0;
      	p.z = 0.0;
		points.points.push_back(p);
	}
	imshow(WINDOW, disparity_image);
	
	marker_pub.publish(points);
	sensor_model_ardrone::Measurement_data data;
	data.features = feature_pub;
	ROS_INFO("Feature vector size: %d, Measurement size: %d", feature_pub.size(),data.features.size());
	measurement_pub.publish(data);
	pose_pub.publish(pose);
	
	
	waitKey(3);
	//return points;
	
}

void initializeRobotConfig(){
	rC[0] = 0;
	rC[1] = 0;
	rC[2] = 2;
	
	//float R[3][3] = {1,0,0, 0,1,0, 0,0,1};
	float R[3][3] = {209.12 ,-0.000008 , -0.00106482, 0, 209.139, -0.000412, 0.00000509, 0.00000197, 43735.1};
	
	qC[0] = sqrt(1 + R[0][0]*R[0][0] + R[1][1]*R[1][1] + R[2][2]*R[2][2]);
	qC[1] = (R[2][1]-R[1][2])/(4*qC[0]);	
	qC[2] = (R[0][2]-R[2][0])/(4*qC[0]);	
	qC[3] = (R[1][0]-R[0][1])/(4*qC[0]);	
}


//void imageCallback(const sensor_msgs::ImageConstPtr& original_image){
void imageCallback(Mat frame){
	/*cv_bridge::CvImagePtr cv_ptr;
	try
	{
		//Always copy, returning a mutable CvImage
		//OpenCV expects color images to use BGR channel order.
		cv_ptr = cv_bridge::toCvCopy(original_image, BGR8);
	}
	catch (cv_bridge::Exception& e)
	{
		//if there is an error during conversion, display it
		ROS_ERROR("tutorialROSOpenCV::main.cpp::cv_bridge exception: %s", e.what());
		return;
	}
	//---------------------------------------------

	
	//LIVE video feed from uvc_cam
	//Mat frame = cv_ptr->image;*/
	//visualization_msgs::Marker points;
	if (frame_it % 5 == 0){
		if (frame_num > 6){
	    	//imshow("CHECK1", image_t_minus_1);
	    	//imshow("CHECK2", frame);
	    	matchFeatures(frame, image_t_minus_1, image_t_minus_3, image_t_minus_3);
	    	image_t_minus_6 = image_t_minus_5.clone();
	    	image_t_minus_5 = image_t_minus_4.clone();
	    	image_t_minus_4 = image_t_minus_3.clone();
	    	image_t_minus_3 = image_t_minus_2.clone();
	    	image_t_minus_2 = image_t_minus_1.clone();
	    	image_t_minus_1 = frame.clone();
	    	
	    }else if (frame_num == 1){
	    	//cout << "First frame \n";
	    	image_t_minus_6 = frame.clone();
	    	frame_num++;
	    }else if (frame_num == 2){
	    	//cout << "First frame \n";
	    	image_t_minus_5 = frame.clone();
	    	frame_num++;
	    }else if (frame_num == 3){
	    	//cout << "First frame \n";
	    	image_t_minus_4 = frame.clone();
	    	frame_num++;
	    }else if (frame_num == 4){
	    	//cout << "Second frame \n";
	    	image_t_minus_3 = frame.clone();
	    	frame_num++;
	    }else if (frame_num == 5){
	    	//cout << "Third frame \n";
	    	image_t_minus_2 = frame.clone();
	    	frame_num++;
	    }else if (frame_num == 6){
	    	//cout << "Third frame \n";
	    	image_t_minus_1 = frame.clone();
	    	frame_num++;
	    }
	}
	frame_it++;
	
	

	
}

int main(int argc, char **argv)
{
	ros::init(argc, argv, "sensor_data_pointcloud");
	ros::NodeHandle nh;
	image_transport::ImageTransport it(nh);
	ROS_INFO("Initializing robot config");
	initializeRobotConfig();
	
	//ros::Rate r(30);
	marker_pub = nh.advertise<visualization_msgs::Marker>("/points_keypoints", 1);
	pose_pub = nh.advertise<geometry_msgs::PoseStamped>("/pose_ardrone", 1);
	measurement_pub = nh.advertise<sensor_model_ardrone::Measurement_data>("/measurement_ardrone", 1);
	
	namedWindow(WINDOW, CV_WINDOW_AUTOSIZE);
	
	//image_transport::Subscriber sub = it.subscribe("camera/image_raw", 1, imageCallback);
	VideoCapture cap("run3.mp4"); // open the video
	//VideoCapture cap("ardrone3.mp4"); // open the video
	if(!cap.isOpened())  // check if we succeeded
        return -1;
        
	while(true){
		Mat frame;
		cap >> frame; // get a new frame from video
		//imshow(WINDOW, frame);
		//ROS_INFO("Next frame: %d", frame_it);
		imageCallback(frame);
		if(waitKey(10) >= 0) 
			break;
	}

	//img_pub = it.advertise("camera/siftDrone", 1);
	destroyWindow(WINDOW);
	ros::spin();
	//ROS_INFO is the replacement for printf/cout.
	ROS_INFO("siftDrone::main.cpp::No error.");

}
