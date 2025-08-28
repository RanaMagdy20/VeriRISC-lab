
`default_nettype none
module controller(

    // input wire phase,
    input wire zero,
    input wire [2:0] opcode,
    input wire [2:0]  phase,


    output reg sel, rd, ld_ir, inc_pc, halt, ld_ac, data_e, ld_pc, wr

    );

    
    localparam  INST_ADDR =0,
                INST_FETCH=1,
                INST_LOAD=2,
                IDLE=3,
                OP_ADDR=4,
                OP_FTCH=5,
                ALU_OP=6,
                STORE = 7;

    always @(*) 
    begin
        case (phase)
            INST_ADDR:
            begin
                sel = 1;
                rd = 0;
                ld_ir = 0;
                inc_pc = 0;
                halt = 0;
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            INST_FETCH:
            begin
                sel = 1; 
                rd = 1;
                ld_ir = 0; 
                inc_pc = 0;
                halt = 0;
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            INST_LOAD:
            begin
                sel = 1;
                rd = 1;
                ld_ir = 1; 
                inc_pc = 0;
                halt = 0; 
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            IDLE:
            begin
                sel  = 1;
                rd = 1;
                ld_ir = 1;
                inc_pc = 0; 
                halt = 0;
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            OP_ADDR:
            begin
                sel  = 0;
                rd = 0;
                ld_ir = 0; 
                inc_pc = 1;
                halt = (opcode== 3'b000) ? 1 : 0;
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            OP_FTCH:
            begin
                sel  = 0;
                rd = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) ? 1 : 0;
                ld_ir = 0;
                inc_pc = 0;
                halt = 0; 
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
            ALU_OP:
            begin
                sel = 0; 
                rd = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) ? 1 : 0;
                ld_ir = 0;
                inc_pc = (opcode == 3'b001 && zero) ? 1 : 0;
                halt =  0;
                ld_ac = 0;
                data_e = (opcode == 3'b110) ? 1 : 0;
                ld_pc = (opcode == 3'b111) ? 1 : 0;
                wr = 0;
                end
            STORE: 
            begin
                sel = 0;
                rd = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) ? 1 : 0;
                ld_ir = 0;
                inc_pc = 0;
                halt = 0;
                ld_ac = (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) ? 1 : 0;
                data_e = (opcode == 3'b110) ? 1 : 0;
                ld_pc = (opcode == 3'b111) ? 1 : 0;
                wr = (opcode == 3'b110) ? 1 : 0;
                end
            default: 
            begin
                sel = 0; 
                rd = 0;
                ld_ir = 0; 
                inc_pc = 0;
                halt = 0;
                ld_ac = 0;
                data_e = 0;
                ld_pc = 0;
                wr = 0;
            end
        endcase
        
    end

endmodule

