`timescale 1ns / 1ps



module VGA_img_rom (
    input  logic [$clog2(320*240)-1:0] addr,
    output logic [               15:0] data_out
);

    logic [15:0] memory_array[0:320*240-1];

    initial begin
        $readmemh("dog_320x240_rgb565.mem", memory_array);
    end
     
    assign data_out = memory_array[addr];
endmodule