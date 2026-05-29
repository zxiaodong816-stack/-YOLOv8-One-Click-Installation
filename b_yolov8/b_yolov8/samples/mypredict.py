# 运行这个可以开始预测
# ---------------------------------------------------------------------------------
# 直接运行将会使用yolov8n.pt这个模型检测ultralytics/assets里的两张图片
# 检测结果将会自动保存，保存位置在检测结束后会打印出来，默认情况下：
#   第一次运行保存在runs/detect/predict里
#   第二次运行保存在runs/detect/predict2里
#   第三次运行保存在runs/detect/predict3里
#   ...
# ---------------------------------------------------------------------------------
# 修改yolov8n.pt为其他模型就可以调用其他模型检测，比如：
#   model = YOLO(r'yolov8n.pt')
# 修改为：
#   model = YOLO(r'yolov8s.pt')
# 就会自动从官网下载yolov8s.pt这个模型，并且使用这个模型检测（下载可能需要魔法）
# 修改为：
#   model = YOLO(r'runs\detect\train3\best.pt')
# 就会使用你自己训练好的模型检测（前提是这个best.pt是存在的）
# ---------------------------------------------------------------------------------
# 修改ultralytics/assets为其他图片路径/图片文件夹路径/视频路径就可以检测其他的对象
# 比如：
#   model.predict(r'ultralytics/assets', save=True)
# 修改为：
#   model.predict(r'C:\Users\lybwc\Desktop\abc.jpg', save=True)
# 就会检测C:\Users\lybwc\Desktop\abc.jpg这张图片并保存结果（前提是这张图片是存在的）
# 修改为：
#   model.predict(r'C:\Users\lybwc\Desktop\def.mp4', save=True)
# 就会检测C:\Users\lybwc\Desktop\def.mp4这个视频并保存结果（前提是这个视频是存在的）
# ---------------------------------------------------------------------------------
from ultralytics import YOLO

model = YOLO(r'yolov8n.pt')
model.predict(r'ultralytics/assets', save=True)
