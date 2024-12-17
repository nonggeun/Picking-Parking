import subprocess
import cv2
import numpy as np
import os
import torch
import sys
from pathlib import Path


class ObjectDetector:
    _instance = None
    _model = None
    _device = None

    def __new__(cls, show_detection=False):
        if cls._instance is None:
            cls._instance = super(ObjectDetector, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self, show_detection=False):
        if self._initialized:
            return

        self.show_detection = show_detection

        if ObjectDetector._model is None:
            current_dir = Path(__file__).resolve().parent
            yolov5_path = current_dir / 'yolov5'
            if str(yolov5_path) not in sys.path:
                sys.path.append(str(yolov5_path))

            from yolov5.models.common import DetectMultiBackend
            from yolov5.utils.torch_utils import select_device

            ObjectDetector._device = select_device('')
            ObjectDetector._model = DetectMultiBackend(
                str(current_dir / 'best.pt'),
                device=ObjectDetector._device
            )

        self.model = ObjectDetector._model
        self.device = ObjectDetector._device
        self._initialized = True

    def capture_image(self, save_path='img.jpg'):
        """Capture image from Jetson Nano camera using gstreamer"""
        gstreamer_cmd = [
            'gst-launch-1.0', '-q',
            'nvarguscamerasrc',
            'num-buffers=1', '!',
            'video/x-raw(memory:NVMM),width=1280,height=720,format=NV12,framerate=30/1', '!',
            'nvvidconv', 'flip-method=0', '!',
            'video/x-raw,format=BGRx', '!',
            'videoconvert', '!',
            'video/x-raw,format=BGR', '!',
            'jpegenc', '!',
            'filesink', f'location={save_path}'
        ]

        try:
            subprocess.run(gstreamer_cmd, check=True)
            if not os.path.exists(save_path):
                print("Failed to save image")
                return False

            return True

        except subprocess.CalledProcessError as e:
            print(f"Error running gstreamer: {e}")
            return False
        except Exception as e:
            print(f"Error: {str(e)}")
            return False

    def run_detection(self, source='img.jpg', conf_thres=0.25):
        """Run YOLOv5 detection on the captured image"""
        from yolov5.utils.general import (check_img_size, non_max_suppression, scale_boxes)
        from yolov5.utils.augmentations import letterbox

        # Load image
        im0 = cv2.imread(source)
        if im0 is None:
            print(f"Error: Could not read image from {source}")
            return False

        # Preprocess image for YOLO
        stride = self.model.stride
        imgsz = check_img_size((640, 640), s=stride)
        im = letterbox(im0, imgsz, stride=stride, auto=True)[0]
        im = im.transpose((2, 0, 1))[::-1]
        im = np.ascontiguousarray(im)
        im = torch.from_numpy(im).to(self.device)
        im = im.float()
        im /= 255
        if len(im.shape) == 3:
            im = im[None]

        # YOLO Inference
        pred = self.model(im)
        pred = non_max_suppression(pred, conf_thres, 0.45)

        # Process detections
        det = pred[0]
        detected = len(det) > 0

        if detected and self.show_detection:
            det[:, :4] = scale_boxes(im.shape[2:], det[:, :4], im0.shape).round()

            # Draw boxes
            for *xyxy, conf, cls in reversed(det):
                c = int(cls)
                label = f'{self.model.names[c]} {conf:.2f}'
                x1, y1, x2, y2 = map(int, xyxy)
                cv2.rectangle(im0, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(im0, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

            # Display result
            cv2.imshow('Detection Result', cv2.resize(im0, (320, 320)))
            cv2.waitKey(1)

        return detected

    def detect_once(self):
        """Capture one image and perform detection"""
        if not self.capture_image():
            print("Failed to capture image")
            return False

        return self.run_detection()
