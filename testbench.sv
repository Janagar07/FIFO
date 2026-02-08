module sync_fifo_tb;
  reg clk, reset, wr_en, rd_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire  empty, a_empty, h_empty, h_full, a_full, full;
  reg [3:0] count;
  
  sync_fifo uut (.clk(clk), .reset(reset), .wr_en(wr_en), .rd_en(rd_en), .data_in(data_in), .data_out(data_out), .empty(empty), .a_empty(a_empty), .h_empty(h_empty), . h_full(h_full), .a_full(a_full), .full(full), .count(count));
  
  
  initial begin
    clk = 0;
    forever #5 clk = ~ clk;
  end
  
  
  initial begin
    $dumpfile("sync_fifo.vcd");
    $dumpvars(0, sync_fifo_tb);
  end
  
  initial begin
    reset = 1; wr_en = 0; rd_en = 0; data_in = 0;
    #15;
    reset = 0;
    
    $display("------------ STARTS WRITE--------------------------");
    $display(" TIME|clk | wr_en | rd_en  | data_in  | data_out | COUNT | wr_ptr | rd_ptr | EMPTY | A_EMPTY  | H_EMPTY  | H_FULL  | A_FULL  | FULL");
    
      repeat(8) begin
        @ (posedge clk)
        wr_en = 1; rd_en = 0;
    data_in = $random;
        #1;
        $display("%4t | %b  |  %b    |   %b    |   %h     |   %h     |   %0d   |   %0d    |   %0d    |   %b   |    %b     |    %b     |    %b    |    %b    |   %b",
        $time, clk, wr_en, rd_en, data_in, data_out, count, uut.wr_ptr, uut.rd_ptr, 
        empty, a_empty, h_empty, h_full, a_full, full);
      end
        
    @(posedge clk)
    wr_en = 0;
    $display("-------------STARTS READ---------------------------");
        
    repeat(8) begin
      @ (posedge clk)
        wr_en = 0; rd_en = 1;
      #1;
      $display("%4t | %b  |  %b    |   %b    |   %h     |   %h     |   %0d   |   %0d    |   %0d    |   %b   |    %b     |    %b     |    %b    |    %b    |   %b",
        $time, clk, wr_en, rd_en, data_in, data_out, count, uut.wr_ptr, uut.rd_ptr, 
        empty, a_empty, h_empty, h_full, a_full, full);
      end
      
    @(posedge clk)
    rd_en = 0;
      $display(" SIMULATION FINISHED ");
      #20;
      $finish;
  end
  endmodule
      
      
      
        
        
    
    