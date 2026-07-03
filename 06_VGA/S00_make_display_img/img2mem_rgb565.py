from PIL import Image

# 1. 파일 및 해상도 설정
input_image_path = 'img00.jpg'          # 원본 이미지
output_mem_path = 'image_rgb565_pure.mem' # 생성될 메모리 파일
preview_image_path = 'preview_rgb565.png' # [추가] 미리보기 이미지 이름
TARGET_WIDTH = 320
TARGET_HEIGHT = 240

# 2. 이미지 불러오기 및 리사이즈
img = Image.open(input_image_path).convert('RGB')
img = img.resize((TARGET_WIDTH, TARGET_HEIGHT), Image.Resampling.LANCZOS)

# [추가] 미리보기를 그릴 빈 캔버스 준비
preview_img = Image.new('RGB', (TARGET_WIDTH, TARGET_HEIGHT))

# 3. 변환 및 미리보기 생성
with open(output_mem_path, 'w') as f:
    for y in range(TARGET_HEIGHT):
        row_pixels = []
        for x in range(TARGET_WIDTH):
            # 원본 8비트 픽셀 (0~255)
            r, g, b = img.getpixel((x, y))
            
            # --- [과정 A] 하드웨어용 16비트 다운스케일링 ---
            # 8비트를 5비트, 6비트, 5비트로 깎아냄
            r5 = (r >> 3) & 0x1F
            g6 = (g >> 2) & 0x3F
            b5 = (b >> 3) & 0x1F
            
            rgb565 = (r5 << 11) | (g6 << 5) | b5
            hex_str = f"{rgb565:04X}"
            row_pixels.append(hex_str)
            
            # --- [과정 B] PC 미리보기용 24비트 업스케일링 ---
            # 깎여나간 5비트(최대 31)와 6비트(최대 63)를 PC 모니터 스케일(255)로 다시 늘려줌
            # 수학적으로 (값 * 255) // 최대값 을 하면 원래 색감 비율을 정확히 맞출 수 있습니다.
            r_preview = (r5 * 255) // 31
            g_preview = (g6 * 255) // 63
            b_preview = (b5 * 255) // 31
            
            # 복원된 픽셀을 미리보기 캔버스에 찍기
            preview_img.putpixel((x, y), (r_preview, g_preview, b_preview))
        
        f.write(" ".join(row_pixels) + "\n")

# [추가] 미리보기 캔버스를 이미지 파일로 저장
preview_img.save(preview_image_path)

print(f"✅ 변환 완료! 메모리 파일: '{output_mem_path}'")
print(f"✅ 미리보기 완료! 이미지 파일: '{preview_image_path}'를 열어보세요.")