`default_nettype none
module regfile(

    // input wire phase,
    input wire load, clk, rst,
    input wire [7:0] data_in,
    output wire [7:0] data_out

    );

    reg [7:0] data_out_reg;
    assign data_out = data_out_reg;
    
    always @(posedge clk or posedge rst) 
    begin
       if(rst)
            data_out_reg <= 'b0;
       else if(load)
            data_out_reg<= data_in;
    end

endmodule