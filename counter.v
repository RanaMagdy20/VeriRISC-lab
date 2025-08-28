`default_nettype none
module counter
(
    input wire clk,rst,
    input wire load,en,
    input wire [4:0] cnt_in,
    output wire [4:0] cnt_out
);
   reg [4:0]count; 
   assign cnt_out = count;
    always @(posedge clk or posedge rst) 
    begin
        if(rst)
            count<='b0;
        else if (load)
            count <= cnt_in;
        else if(en)
            count<=count+1;

    end
endmodule