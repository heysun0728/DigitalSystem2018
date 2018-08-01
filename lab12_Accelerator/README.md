# Accelerator

以 ARM Master 端(Processing System)發送 16 筆 32bits 的數值以及其該存放的記憶體位址給加速器(Programmable Logic)，透過控制暫存器拉起與下降，決定何時做計算以及寫入 SRAM，再以 C 於 ARM 平 台上實作。

其中乘法部分使用前幾次作業所寫的乘法器電路

* 作業Part1：完成範例 f(x)=x^2
* 作業Part2：修改範例 f(x)=x^3
* 作業Part3：修改範例 f(x)=
