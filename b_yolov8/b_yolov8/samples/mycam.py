# 运行这个可以开始测试摄像头
# ---------------------------------------------------------------------------------
# 直接运行会打开摄像头使用yolov8n.pt检测（前提是电脑带摄像头）
# 鼠标点击一下检测窗口，多按几下q就可以退出摄像头检测了
# ---------------------------------------------------------------------------------
import cv2
from ultralytics import YOLO

model = YOLO("yolov8n.pt")

results = model(source=0, stream=True)

for result in results:
    plotted = result.plot()

    cv2.imshow("YOLO Inference", plotted)

    if cv2.waitKey(1) & 0xFF == ord("q"):
        break