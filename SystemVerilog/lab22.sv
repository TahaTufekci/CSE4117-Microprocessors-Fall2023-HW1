module lab22(grounds, display, clk, key_one, key_zero);

  input logic key_one;
  input logic key_zero;
  output logic [3:0] grounds;
  output logic [6:0] display;
  input clk;
  logic key_zero_prev;
  logic key_one_prev;
  logic check;
  logic increment_data;
  logic increment_speed;
  logic [3:0] data [3:0];
  logic [1:0] count;
  logic [25:0] clk1;
  logic [4:0] scan_speed;  // Eklenen scan_speed sinyali

  always_ff @(posedge clk1[scan_speed])
  begin
    grounds <= {grounds[2:0], grounds[3]};
    count <= count + 1;
  end

  always_ff @(posedge clk)
  begin
    clk1 <= clk1 + 1;

    key_one_prev <= key_one;

    if (key_one && !key_one_prev && increment_data)
    begin
      if (data[check] == 4'hf)
      begin
        data[check + 1] <= data[check + 1] + 1;
        if (data[check + 1] == 4'hf)
        begin
          data[check + 2] <= data[check + 2] + 1;
          if (data[check + 2] == 4'hf)
          begin
            data[check + 3] <= data[check + 3] + 1;
          end
        end
      end
      data[check] <= data[check] + 1;
      increment_data <= 0;
    end
    else if (!key_one)
    begin
      increment_data <= 1;
    end
  end

  always_comb
    case (data[count])
      0: display = 7'b1111110;
      1: display = 7'b0110000;
      2: display = 7'b1101101;
      3: display = 7'b1111001;
      4: display = 7'b0110011;
      5: display = 7'b1011011;
      6: display = 7'b1011111;
      7: display = 7'b1110000;
      8: display = 7'b1111111;
      9: display = 7'b1111011;
      4'hA: display = 7'b1110111;
      4'hB: display = 7'b0011111;
      4'hC: display = 7'b1001110;
      4'hD: display = 7'b0111101;
      4'hE: display = 7'b1001111;
      4'hF: display = 7'b1000111;
      default: display = 7'b1111111;
    endcase

  initial begin
    data[0] = 4'hA;
    data[1] = 4'hE;
    data[2] = 4'hF;
    data[3] = 4'hF;
    count = 2'b00;
    grounds = 4'b1110;
    clk1 = 26'b0;
    check = 2'b00;
    key_one_prev = 1'b0;
    key_zero_prev = 1'b0;
    increment_data = 1'b0;
	 increment_speed = 1'b0;
    scan_speed = 5'b01111;  // Başlangıçta scan hızını 15 olarak ayarla
  end

  // Key_zero düğmesine basıldığında scan_speed'i değiştiren kod
  always_ff @(posedge clk) begin
   key_zero_prev <= key_zero;
    if (key_zero && !key_zero_prev && increment_speed) begin
      case (scan_speed)
        5'b11001: scan_speed <= 5'b01111;  // Eğer scan_speed 25 ise, 15 yap
        5'b10011: scan_speed <= 5'b11001;  // Eğer scan_speed 19 ise, 25 yap
        5'b01111: scan_speed <= 5'b10011;  // Eğer scan_speed 15 ise, 19 yap
        default: scan_speed <= 5'b01111;
      endcase
		increment_speed <= 0;
    end
	 else if (!key_zero)
    begin
      increment_speed <= 1;
    end
  end

endmodule