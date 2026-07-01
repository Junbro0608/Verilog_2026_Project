from ultralytics import YOLO

def main():
    # 1. 모델 로드
    # 가벼운 실시간 처리를 원하면 'yolov8n-pose.pt' (Nano)
    # 더 높은 정확도를 원하면 'yolov8s-pose.pt', 'yolov8m-pose.pt' 등을 선택합니다.
    print("모델을 로딩 중입니다...")
    model = YOLO('yolov8n-pose.pt') 

    # 2. 모델 학습 (Training)
    print("학습을 시작합니다...")
    results = model.train(
        data='coco8-pose.yaml',   # 앞서 만든 데이터셋 설정 파일 경로
        epochs=100,            # 전체 데이터셋을 반복 학습할 횟수
        imgsz=320,             # 입력 이미지 크기 (기본 640x640)
        batch=16,              # 배치 사이즈 (GPU 메모리에 맞춰 조절: 8, 16, 32 등)
        device='cpu',              # GPU를 사용할 경우 0, CPU만 쓸 경우 'cpu'
        patience=20,           # 20 Epoch 동안 성능 향상이 없으면 조기 종료(Early Stopping)
        project='Pose_Project',# 학습 결과가 저장될 상위 폴더 이름
        name='run_1',          # 이번 학습 세션의 이름
        save=True              # 최고 성능 모델 자동 저장 (best.pt)
    )
    print("학습이 완료되었습니다. 결과가 Pose_Project/run_1 폴더에 저장되었습니다.")

    # 3. 모델 검증 (Validation)
    print("검증 데이터셋으로 모델을 평가합니다...")
    metrics = model.val()
    print(f"mAP50-95: {metrics.box.map}") # 바운딩 박스 정확도
    print(f"Pose mAP50-95: {metrics.pose.map}") # 관절 추정 정확도

    # 4. 모델 추론 (Inference / Prediction)
    print("웹캠을 켜서 실시간 자세 추정 테스트를 진행합니다...")
    # 'test_image.jpg' 대신 숫자 0(기본 웹캠)을 입력하고, 화면에 띄우기 위해 show=True 옵션 추가
    predict_results = model(1, show=True)

    # 5. 하드웨어 배포를 위한 모델 내보내기 (Export)
    print("추후 에지(Edge) 디바이스나 커스텀 가속기 배포를 위해 ONNX 포맷으로 변환합니다...")
    model.export(format='onnx')

if __name__ == '__main__':
    # Windows 환경 등에서 멀티프로세싱 충돌 방지를 위해 __main__ 블록 내에서 실행
    main()