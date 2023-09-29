import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class BlinkyTester extends AnyFlatSpec with ChiselScalatestTester {
  val TEST_CLK_FREQ = 100
  "Blinky" should "pass" in {
    test(new Blinky(TEST_CLK_FREQ)).withAnnotations(Seq(WriteVcdAnnotation)) { dut => 
      // Reset module
      dut.reset.poke(true.B)
      dut.clock.step()
      dut.reset.poke(false.B)

      // Run test
      for (i <- 0 until 10 * TEST_CLK_FREQ) {
        dut.clock.step()
        if (i % TEST_CLK_FREQ == 0) {
            println(if (dut.io.led.peekBoolean()) "*" else "o")
        }
      }
    }
  }
}
