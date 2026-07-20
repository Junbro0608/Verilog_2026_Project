# ==========================================
# Include Directories
# ==========================================
# .mem 파일들을 $readmemh로 읽어오기 위해 경로 추가
+incdir+./rtl/Slave
+incdir+./tb/input_img.mem

# ==========================================
# RTL - Common
# ==========================================
./rtl/clk_wiz.sv


# ==========================================
# RTL - Slave Modules
# ==========================================
./rtl/Slave/top_slave.sv
./rtl/Slave/Cam_WriteController.sv
./rtl/Slave/Cam_frameBuffer.sv
./rtl/Slave/DownScaleImage.sv
./rtl/Slave/OV7670_MemController.sv
./rtl/Slave/OV7670_Music_Scale_Detect.sv
./rtl/Slave/OV7670_SCCB_Controller.sv
./rtl/Slave/VGA_Decoder.sv
./rtl/Slave/VGA_pixel_delay.sv
./rtl/Slave/frameBuffer.sv
./rtl/Slave/frame_sender.sv
./rtl/Slave/i2c_slave.sv
./rtl/Slave/spi_slave.sv
./rtl/Slave/ycocg_encoder.sv

# ==========================================
# Testbench & UVM Environment
# ==========================================
./tb/tb_VGA.sv
