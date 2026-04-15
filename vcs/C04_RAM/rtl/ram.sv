module ram (
    input               clk,
    //write
    input               write,
    input        [ 7:0] addr,
    input        [15:0] wdata,
    //read
    output logic [15:0] rdata
);

    logic [15:0] mem[0:(2**8)-1];
    always_ff @(posedge clk) begin : blockName
        if (write) begin
            mem[addr] <= wdata;
        end else begin
            rdata <= mem[addr];
        end
    end

endmodule
