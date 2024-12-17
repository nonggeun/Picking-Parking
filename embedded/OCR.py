import cv2
import os
from google.cloud import vision

class CameraOCRManager:
    def __init__(self):
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = './certs/OCR_api_key.json'
        self.client = vision.ImageAnnotatorClient()
        
    def capture_and_process(self):
        try:
            # img.jpg 파일 읽기
            frame = cv2.imread('img.jpg')
            if frame is None:
                raise Exception("img.jpg 파일 로드 실패")

            # 이미지 표시
           # cv2.imshow('Image', frame)
           # print('이미지 로드 완료')
           # cv2.waitKey(3000)

            # OCR
            success, encoded_image = cv2.imencode('.jpg', frame)
            content = encoded_image.tobytes()
            cv2.destroyAllWindows()
            
            image = vision.Image(content=content)
            image_context = vision.ImageContext(
                language_hints=['ko']
            )
            response = self.client.text_detection(image=image, image_context=image_context)
            
            if not response.text_annotations:
                print('OCR 실패')
                return False
            else:
                result = response.text_annotations[0].description
                print(result)
                return result
            
        except Exception as e:
            print(f"OCR 에러: {e}")
            return ""