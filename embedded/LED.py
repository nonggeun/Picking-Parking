# -*- coding: utf-8 -*-
# LED.py
import cv2
import numpy as np
from PIL import Image
import os
import time
from threading import Lock


class LEDController:
    def __init__(self,img_dir='./colors'):
        self.images = {}
        self.img_dir = img_dir
        self.width = 1920
        self.height = 1200
        self.current_color = None
        self.window_lock = Lock()
        os.environ['DISPLAY'] = ':0'

        time.sleep(2)

        # cv2.namedWindow('LED', cv2.WINDOW_NORMAL)
        # cv2.moveWindow('LED', 0, 0)
        # cv2.resizeWindow('LED', self.width, self.height)
        #
        # cv2.setWindowProperty('LED', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)


        try:
            # 전체 화면 윈도우 설정
            cv2.namedWindow('LED', cv2.WND_PROP_FULLSCREEN)
            cv2.setWindowProperty('LED', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
            print("Display window initialized")
        except Exception as e:
            print(f"Failed to initialize display: {e}")
            # X11 권한 문제 가능성 안내
            print("Check if X11 permissions are properly set")

        # self.create_color_images()

    def create_color_images(self):
        colors = {
            'R': (0, 0, 255),  # Red (BGR)
            'G': (0, 255, 0),  # Green (BGR)
            'Y': (0, 255, 255),  # Yellow (BGR)
            'Black': (255, 255, 255)
        }

        for color_name, bgr_value in colors.items():
            img = np.full((self.height, self.width, 3), bgr_value, dtype=np.uint8)
            self.images[color_name] = img
            print('Color {} image created ({}x{})'.format(color_name, self.width, self.height))
        # print(f'~~~~~~~~~~~~~{self.images}~~~~~~~~~~~~~~~~~~~~~~~~~')

    # def set_color(self, color):
    #     if color in self.images:
    #         print(f'색상 변경 시작!!!!!!!!!!!!!{color}')
    #         try:
    #             cv2.imshow('LED', self.images[color])
    #             cv2.setWindowProperty('LED', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
    #             cv2.waitKey(1)
    #             print('Color {} displayed ({}x{})'.format(color, self.width, self.height))
    #         except Exception as e:
    #             print('Failed to display color: {}'.format(e))
    #     else:
    #         print(f'없는 색깔이야!!!!!!!!!!!!!!!{color}')


    def set_color(self, color):
        """색상 변경"""
        if color not in self.images:
            print(f"Invalid color: {color}")
            return False

        with self.window_lock:
            try:
                # 현재 색상과 같으면 스킵
                if self.current_color == color:
                    return True

                # 이미지 표시
                cv2.imshow('LED', self.images[color])
                cv2.waitKey(1)  # 필수: 화면 업데이트를 위해

                self.current_color = color
                print(f"Display changed to {color}")
                return True

            except Exception as e:
                print(f"Failed to set color {color}: {e}")
                return False

    def cleanup(self):
        """정리"""
        with self.window_lock:
            try:
                cv2.destroyAllWindows()
                print("Display cleanup completed")
            except Exception as e:
                print(f"Cleanup error: {e}")