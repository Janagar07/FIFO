module sync_fifo(
  input clk, reset, wr_en, rd_en,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg empty, a_empty, h_empty, h_full, a_full, full,
  output reg [3:0] count);
  
  reg [7:0] mem [7:0];
  reg [2:0] wr_ptr, rd_ptr;
  
  function is_empty;
    input [3:0] c;
    is_empty = (c == 0);
  endfunction
  
  function is_a_empty;
    input [3:0] c;
    is_a_empty = (c==1);
  endfunction
  
  function is_h_empty;
    input [3:0] c;
    is_h_empty = (c == 4);
  endfunction
  
  function is_h_full;
    input [3:0] c;
    is_h_full = (c == 4);
  endfunction
  
  function is_a_full;
    input [3:0] c;
    is_a_full = (c == 7);
  endfunction
  
  function is_full;
    input [3:0] c;
    is_full = (c == 8);
  endfunction
  
  always @ (*) begin
   empty = is_empty (count);
   a_empty = is_a_empty(count);
   h_empty = is_h_empty(count);
   h_full = is_h_full(count);
   a_full = is_a_full(count);
   full = is_full(count);
  end
  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 0;
   	  wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end
    
    else
      begin
        if(wr_en && !rd_en && !full) begin
          mem[wr_ptr] <= data_in;
          wr_ptr <= wr_ptr + 1;
        count <= count + 1;
        end
        
        if (rd_en && !wr_en && !empty) begin
          data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
        end
      end
  end
endmodule
    