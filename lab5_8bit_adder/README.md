# 8bit_Adder


![](https://github.com/heysun0728/8bit_Adder/blob/master/8bitadder.png)

使用 test bench 作為驗證手段，test bench 將輸入信號傳送到16-bit adder，再將運算結果傳回來

依照所需測試的範圍，撰寫 test bench 測試程式(testbench_cont_8bit_adder.v)，驗證設計之 8-bit adder 輸出結果是否符合設計功能

## 執行
<pre><code>iverilog –o 8bit_adder.out cont_8bit_adder.v testbench_cont_8bit_adder.v
vvp 8bit_adder.out
gtkwave cont_8bit_adder.vcd
</pre></code>