;nyquist plug-in
;version 3
;type process
;name "TubeScreamer"
;codetype sal

set dist-table = 
    seq(const(-1), 
          (1.5 * pwlv(-1, 2, 1) - 0.5 
               * pwlv(-1, 2, 1) 
               * pwlv(-1, 2, 1) 
               * pwlv(-1, 2, 1)) , 
        const(1) )

function norm(sound)
  return snd-normalize(sound) * .5


function soft-clip(sound)
  return .48 * shape( 2.083 * sound, dist-table, 2 )
 
function gain(sound, amount)
  return (1 + (106.383 * .01 * amount + 11.851)  * .01) * 20  * sound

function high-pass(sound)
  return hp(sound, 720.484)

function overdrive(sound, amount)
  return clip(soft-clip(gain(high-pass(sound), amount))
         + .48 * sound, 2.5 )

overdrive(s)
