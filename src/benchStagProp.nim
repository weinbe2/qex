import qex
import stdUtils
import field
import qcdTypes
import gaugeUtils
import stagD
import profile
import os

qexInit()
#var defaultLat = [4,4,4,4]
#var defaultLat = [8,8,8,8]
var defaultLat = @[8,8,8,8]
#var defaultLat = @[12,12,12,12]
defaultSetup()
var v1 = lo.ColorVector()
var v2 = lo.ColorVector()
var r = lo.ColorVector()
threads:
  g.random
  g.setBC
  g.stagPhase
  v1 := 0
  #for e in v1:
  #  template x(d:int):expr = lo.vcoords(d,e)
  #  v1[e][0].re := foldl(x, 4, a*10+b)
  #  #echo v1[e][0]
#echo v1.norm2
if myRank==0:
  v1{0}[0] := 1
  #v1{2*1024}[0] := 1
echo v1.norm2
var s = newStag(g)
var m = 0.000001
threads:
  v2 := 0
  echo v2.norm2
  threadBarrier()
  s.D(v2, v1, m)
  threadBarrier()
  #echoAll v2
  echo v2.norm2
#echo v2
var sp = initSolverParams()
sp.maxits = 10000
s.solve(v2, v1, m, sp)
resetTimers()
s.solve(v2, v1, m, sp)
threads:
  echo "v2: ", v2.norm2
  echo "v2.even: ", v2.even.norm2
  echo "v2.odd: ", v2.odd.norm2
  s.D(r, v2, m)
  threadBarrier()
  r := v1 - r
  threadBarrier()
  echo r.norm2
#echo v2
qexFinalize()
