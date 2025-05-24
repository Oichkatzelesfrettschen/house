import Net.IPv4
import Net.PacketParsing
import Net.Packet
import Kernel.Bits
import Data.Array.Unboxed

main :: IO ()
main = case doParse parse packet of
         Just p  -> print (options (p :: Packet InPacket))
         Nothing -> putStrLn "parse failed"
  where
    packet = toInPack (listArray (0,length bytes-1) bytes)
    bytes = [0x46,0x00,0x00,0x18,0x00,0x01,0x00,0x00,64,17,0,0,
             192,168,0,1,192,168,0,2,1,1,0,0]

