{-# LANGUAGE NumericUnderscores #-}

{-# OPTIONS_GHC "-Wno-orphans" #-}

module Blinker where

import Clash.Explicit.Prelude
import Clash.Xilinx.ClockGen

-- Create a domain for the input clock. Note: this needs to have asynchronous
-- resets, which is why we base it on 'vSystem' rather than 'vXilinxSystem'.
createDomain vSystem{vName="DomIn", vResetPolarity=ActiveLow}
-- Define a synthesis domain with a clock with a period of 50000 /ps/,
-- i.e. 20 MHz
createDomain vXilinxSystem{vName="Dom20", vPeriod=50000}

{-# ANN topEntity
  (Synthesize
    { t_name   = "blinker"
    , t_inputs = [ PortName "CLK100MHZ"
                 , PortName "ck_rst"
                 ]
    , t_output = PortName "led"
    }) #-}
topEntity ::
  Clock DomIn ->
  Reset DomIn ->
  Signal Dom20 Bit
topEntity clk100 rstBtn = led
 where
  (clk20, rst20) = clockWizard clk100 rstBtn
  en = enableGen
  led = register clk20 rst20 en 0 $ liftA2 xor led toggle
  toggle = fmap (boolToBit . (== maxBound)) cnt
  cnt :: Signal Dom20 (Index 10_000_000)
  cnt = register clk20 rst20 en 0 $ satSucc SatWrap <$> cnt
{-# OPAQUE topEntity #-}
