module mem#(
    parameter AWIDTH = 5, 
    parameter DWIDTH = 8
)(
    input wire rd, clk, wr,
    input wire [AWIDTH-1:0] address_in,
    inout wire [DWIDTH-1:0] data
);
//Memory 2D array
    reg [DWIDTH-1:0] array [0:255];

//Combinational read operation
    assign data = (rd) ? array[address_in] : {DWIDTH{1'bz}}; 

//Synchronous write operation    
    always @(posedge clk) begin
        if (wr)
            array[address_in] <= data;
    end
endmodule
