import chisel3._
import chisel3.util.Counter

class Blinky(clkFreq: Int) extends Module {
  val io = IO(new Bundle{
    val led = Output(Bool())
  })
  
  val ledReg = RegInit(false.B)

  val (_, tick) = Counter(0 until clkFreq)

  when (tick) {
    ledReg := ~ledReg
  }

  io.led := ledReg
}

object BlinkyMain extends App {
  println("Generating SystemVerilog")
  emitVerilog(new Blinky(100000000), Array("--target-dir", "rtl"))
}