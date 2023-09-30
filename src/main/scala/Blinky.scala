import chisel3._
import chisel3.util.Counter
import circt.stage.ChiselStage

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
  ChiselStage.emitSystemVerilogFile(
    // Main chisel module
    gen = new Blinky(clkFreq = 100000000),
    // Options for firrtl
    args = Array("--target-dir", "rtl"),
    // Options for firtool. For now these options are required for open source toolchain
    firtoolOpts = Array("--lowering-options=disallowLocalVariables,disallowPackedArrays")
  )
}