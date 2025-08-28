module tristate_buffer(
    input wire[7:0] data_in,
    input wire en,
    output wire [7:0] data_out
);
assign data_out = (en) ? data_in : {8{1'bz}};

endmodule