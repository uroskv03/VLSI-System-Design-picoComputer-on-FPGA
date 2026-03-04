module cpu #(parameter ADDR_WIDTH = 6,
             parameter DATA_WIDTH = 16)
            (input clk,
             input rst_n,
             input [DATA_WIDTH-1:0] mem,
             input [DATA_WIDTH-1:0] in,
             input control,
             output status,
             output we,
             output [ADDR_WIDTH-1:0] addr,
             output [DATA_WIDTH-1:0] data,
             output [DATA_WIDTH-1:0] out,
             output [ADDR_WIDTH-1:0] pc,
             output [ADDR_WIDTH-1:0] sp);
    
    wire [ADDR_WIDTH-1:0] pc_out;
    reg [ADDR_WIDTH-1:0] pc_in;
    reg pc_ld, pc_inc;
    
    wire [ADDR_WIDTH-1:0] sp_out;
    reg [ADDR_WIDTH-1:0] sp_in;
    reg sp_ld, sp_inc, sp_dec;
    
    wire [31:0] ir_out;
    reg [31:0] ir_in;
    reg ir_ld;
    
    reg [ADDR_WIDTH-1:0] mar_in;
    reg [DATA_WIDTH-1:0] mdr_in;
    
    
    wire [DATA_WIDTH-1:0] acc_out;
    reg [DATA_WIDTH-1:0] acc_in;
    reg acc_ld, acc_cl;
    
    
    wire [DATA_WIDTH-1:0] acc1_out;
    reg [DATA_WIDTH-1:0] acc1_in;
    reg acc1_ld, acc1_cl;
    
    reg we1;
    
    wire [3:0] op_code;
    assign op_code = ir_out[15:12];
    
    
    reg [2:0] oc;// oc1;
    reg [DATA_WIDTH-1:0] a, b;
    wire [DATA_WIDTH-1:0] alu_out;
    
    register #(.DATA_WIDTH(ADDR_WIDTH)) pc_reg (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(pc_ld), .in(pc_in),
    .inc(pc_inc), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(pc_out)
    );
    
    register #(.DATA_WIDTH(ADDR_WIDTH)) sp_reg (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(sp_ld), .in(sp_in),
    .inc(sp_inc), .dec(sp_dec), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(sp_out)
    );
    
    register #(.DATA_WIDTH(32)) ir_inst (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(ir_ld), .in(ir_in),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(ir_out)
    );
    
    
    /*register #(.DATA_WIDTH(ADDR_WIDTH)) mar_inst (
     .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(mar_ld), .in(mar_in),
     .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
     .out(mar_out)
     );
     
     register #(.DATA_WIDTH(DATA_WIDTH)) mdr_inst (
     .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(mdr_ld), .in(mdr_in),
     .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
     .out(mdr_out)
     );*/
    
    
    register #(.DATA_WIDTH(DATA_WIDTH)) acc_inst (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(acc_ld), .in(acc_in),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(acc_out)
    );
    
    register #(.DATA_WIDTH(DATA_WIDTH)) acc_inst1 (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(acc1_ld), .in(acc1_in),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(acc1_out)
    );
    
    alu #(.DATA_WIDTH(DATA_WIDTH)) alu1 (
    .oc(oc), .a(a), .b(b), .f(alu_out)
    );
    
    reg x_ind_ld, y_ind_ld, z_ind_ld;
    wire [ADDR_WIDTH-1:0] x_ind_out, y_ind_out, z_ind_out;
    
    register #(.DATA_WIDTH(ADDR_WIDTH)) x_ind (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(x_ind_ld), .in(mem[ADDR_WIDTH-1:0]),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(x_ind_out)
    );
    
    register #(.DATA_WIDTH(ADDR_WIDTH)) y_ind (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(y_ind_ld), .in(mem[ADDR_WIDTH-1:0]),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(y_ind_out)
    );
    
    register #(.DATA_WIDTH(ADDR_WIDTH)) z_ind (
    .clk(clk), .rst_n(rst_n), .cl(1'b0), .ld(z_ind_ld), .in(mem[ADDR_WIDTH-1:0]),
    .inc(1'b0), .dec(1'b0), .sr(1'b0), .ir(1'b0), .sl(1'b0), .il(1'b0),
    .out(z_ind_out)
    );
    
    
    localparam OP_MOV  = 4'd0;
    localparam OP_ADD  = 4'd1;
    localparam OP_SUB  = 4'd2;
    localparam OP_MUL  = 4'd3;
    localparam OP_DIV  = 4'd4;
    localparam OP_IN   = 4'b0111;
    localparam OP_OUT  = 4'b1000;
    localparam OP_STOP = 4'b1111;
    
    reg [5:0] state_next, state_reg;
    
    localparam RST     = 5'b00000; //0
    localparam FETCH1  = 5'b00001; //1
    localparam DECODE1 = 5'b00010; //2
    localparam FETCH2  = 5'b00011; //3
    localparam DECODE2 = 5'b00100; //4
    localparam EXEC    = 5'b00101; //5
    localparam MOV1    = 5'b00110; //6
    localparam WRITE   = 5'b00111; //7
    localparam ALU1    = 5'b01000; //8
    localparam ALU2    = 5'b01001; //9
    localparam OUT1    = 5'b01010; //10
    localparam HALT    = 5'b01011; //11
    localparam STOPX   = 5'b01100; //12
    localparam STOPY   = 5'b01101; //13
    localparam STOPZ   = 5'b01110; //14
    localparam INDX    = 5'b01111; //15
    localparam INDY    = 5'b10000; //16
    localparam INDZ    = 5'b10001; //17
    
    
    /*wire [ADDR_WIDTH-1:0] addrX = (ir_out[11]) ? ir_out[21:16] : {3'b0, ir_out[10:8]};
     wire [ADDR_WIDTH-1:0] addrY  = (ir_out[7])  ? ir_out[21:16] : {3'b0, ir_out[6:4]};
     wire [ADDR_WIDTH-1:0] addrZ  = (ir_out[3])  ? ir_out[21:16] : {3'b0, ir_out[2:0]};*/
    
    /*wire [ADDR_WIDTH-1:0] adrX = {3'b0, ir_out[10:8]};
     wire [ADDR_WIDTH-1:0] adrY  = {3'b0, ir_out[6:4]};
     wire [ADDR_WIDTH-1:0] adrZ  = {3'b0, ir_out[2:0]};*/
    
    
    wire [ADDR_WIDTH-1:0] adrX = (ir_out[11]) ? x_ind_out : {3'b0, ir_out[10:8]};
    wire [ADDR_WIDTH-1:0] adrY = (ir_out[7])  ? y_ind_out : {3'b0, ir_out[6:4]};
    wire [ADDR_WIDTH-1:0] adrZ = (ir_out[3])  ? z_ind_out : {3'b0, ir_out[2:0]};
    
    assign we   = we1;
    assign addr = mar_in;
    assign data = mdr_in;
    assign pc   = pc_out;
    assign sp   = sp_out;
    assign out  = acc1_out;
    
    assign status = (state_reg == EXEC && op_code == OP_IN);
    
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= RST;
        end
        else begin
            state_reg <= state_next;
            
        end
    end
    
    always @(*) begin
        state_next = state_reg;
        pc_in      = 6'b0; pc_ld      = 1'b0; pc_inc      = 1'b0;
        sp_in      = 6'b0; sp_ld      = 1'b0; sp_inc      = 1'b0; sp_dec      = 1'b0;
        ir_in      = 32'b0; ir_ld      = 1'b0;
        mar_in     = 6'b0;
        mdr_in     = 16'b0;
        acc_in     = 16'b0; acc_ld     = 1'b0; acc_cl     = 1'b0;
        acc1_in    = 16'b0; acc1_ld    = 1'b0; acc1_cl    = 1'b0;
        oc         = 3'b0; a         = 16'b0;   b         = 16'b0;
        
        we1      = 1'b0;
        //a      = {DATA_WIDTH{1'b0}};
        x_ind_ld = 1'b0; y_ind_ld = 1'b0; z_ind_ld = 1'b0;
        
        case (state_reg)
            
            RST: begin
                pc_in      = 6'd8;
                pc_ld      = 1'b1;
                sp_in      = 6'd63;
                sp_ld      = 1'b1;
                state_next = FETCH1;
            end
            
            FETCH1: begin
                mar_in     = pc_out;
                state_next = DECODE1;
            end
            
            DECODE1: begin
                ir_in  = { 16'b0, mem};
                ir_ld  = 1'b1;
                pc_inc = 1'b1;
                if (mem[11]) begin
                    mar_in     = {3'b0,  mem[10:8]};
                    state_next = INDX;
                end
                else if (mem[7]) begin
                    mar_in     = {3'b0,  mem[6:4]};
                    state_next = INDY;
                end
                else if (mem[3]) begin
                    mar_in     = {3'b0,  mem[2:0]};
                    state_next = INDZ;
                end
                else begin
                    state_next = EXEC;
                end
                //state_next = FETCH2;
            end
            
            FETCH2: begin
                mar_in     = pc_out;
                state_next = DECODE2;
            end
            
            DECODE2: begin
                ir_in  = { 16'b0, mem};
                ir_ld  = 1'b1;
                pc_inc = 1'b1;
                if (mem[11]) begin
                    mar_in     = {3'b0,  mem[10:8]};
                    state_next = INDX;
                end
                else if (mem[7]) begin
                    mar_in     = {3'b0,  mem[6:4]};
                    state_next = INDY;
                end
                else if (mem[3]) begin
                    mar_in     = {3'b0,  mem[2:0]};
                    state_next = INDZ;
                end
                else begin
                    state_next = EXEC;  //moze i direktno u stanje za instrukciju
                end
            end
            
            EXEC: begin
                case (op_code)
                    OP_MOV: begin
                        if (ir_out[3:0] == 4'b0000) begin
                            mar_in     = adrY;
                            state_next = MOV1;
                        end
                        else begin
                            state_next = FETCH1;
                        end
                    end
                    OP_ADD, OP_SUB, OP_MUL, OP_DIV: begin
                        mar_in     = adrZ;
                        //oc1      = ir_out[14:12];
                        state_next = ALU1;
                    end
                    OP_IN: begin
                        if (control) begin
                            mar_in     = adrX;
                            mdr_in     = in;
                            we1        = 1'b1;
                            state_next = FETCH1;
                        end
                        else begin
                            state_next = EXEC;
                        end
                        
                    end
                    OP_OUT: begin
                        mar_in     = ir_out[10:8];
                        state_next = OUT1;
                    end
                    OP_STOP: begin
                        if (adrX) begin
                            mar_in = adrX;
                            
                            state_next = STOPX;
                        end
                        else begin
                            if (adrY) begin
                                mar_in = adrY;
                                
                                state_next = STOPY;
                            end
                            else begin
                                if (adrZ) begin
                                    mar_in = adrZ;
                                    
                                    state_next = STOPZ;
                                end
                                else begin
                                    state_next = HALT;
                                end
                            end
                            
                        end
                        
                    end
                    default: begin
                        state_next = HALT;
                    end
                endcase
                
            end
            MOV1: begin
                mar_in     = adrX;
                mdr_in     = mem;
                we1        = 1'b1;
                state_next = FETCH1;
            end
            // WRITE: begin
                //     state_next = FETCH1;
            // end
            ALU1: begin
                mar_in     = adrY;
                acc_in     = mem;
                acc_ld     = 1'b1;
                state_next = ALU2;
            end
            ALU2: begin
                oc         = ir_out[14:12]-1;
                mar_in     = adrX;
                b          = acc_out;
                a          = mem;
                mdr_in     = alu_out;
                we1        = 1'b1;
                state_next = FETCH1;
            end
            OUT1: begin
                acc1_in    = mem;
                acc1_ld    = 1'b1;
                state_next = FETCH1;
            end
            HALT: begin
                state_next = HALT;
            end
            
            STOPX: begin
                acc1_in = mem;
                acc1_ld = 1'b1;
                if (adrY) begin
                    mar_in = adrY;
                    
                    state_next = STOPY;
                end
                else begin
                    if (adrZ) begin
                        mar_in = adrZ;
                        
                        state_next = STOPZ;
                    end
                    else begin
                        state_next = HALT;
                    end
                end
                
            end
            STOPY: begin
                acc1_in = mem;
                acc1_ld = 1'b1;
                if (adrZ) begin
                    mar_in = adrZ;
                    
                    state_next = STOPZ;
                end
                else begin
                    state_next = HALT;
                end
            end
            STOPZ: begin
                acc1_in    = mem;
                acc1_ld    = 1'b1;
                state_next = HALT;
            end
            INDX: begin
                x_ind_ld = 1'b1;
                if (ir_out[7]) begin
                    mar_in = {3'b0, ir_out[6:4]};
                    
                    state_next = INDY;
                end
                else if (ir_out[3]) begin
                    mar_in = {3'b0, ir_out[2:0]};
                    
                    state_next = INDZ;
                end
                else begin
                    state_next = EXEC;
                end
            end
            
            INDY: begin
                y_ind_ld = 1'b1;
                if (ir_out[3]) begin
                    mar_in = {3'b0, ir_out[2:0]};
                    
                    state_next = INDZ;
                end
                else begin
                    state_next = EXEC;
                end
            end
            
            INDZ: begin
                z_ind_ld   = 1'b1;
                state_next = EXEC;
            end
            
        endcase
    end
    
endmodule
