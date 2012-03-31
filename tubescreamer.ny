;nyquist plug-in
;version 1
;type process
;name "TubesCreamer"
;control drive "Drive" real "Amount" 50 0 100
;codetype sal
;debugflags trace

;; TubeScreamer plugin by Kyle Verrier


;; Create a distortion table with an 'S' shape for soft clipping shaping at
;; amplitude of 1. Function is the cubic polynomial, 1.5x - 0.5x^3
;; Visual Referece: http://bit.ly/GYVFSN
set dist-table =
    seq( (1.5 * pwlv(-1, 2, 1) - 0.5
               * pwlv(-1, 2, 1)
               * pwlv(-1, 2, 1)
               * pwlv(-1, 2, 1)),
        const(1) )


;; Multiply original audio to clip softly at 0.48 Vpeak
;; Then multiply to reduce to original level
define function soft-clip(sound)
begin
  return .96 * shape( 1.04166667 *  clip(sound, 1) , dist-table, 1 )
end


;; Clipping Circuit:
;;               Original
;;                  +
;; HP Filter -> Amplify -> Clip Softly
;;                 -->
;;              Clip Hard

define function clipping-circuit(sound)
begin
  return clip(soft-clip(hp(sound,720.484) * (1.06383 * drive + 11.851)) + sound, 1.4) * .5
end

;; Post Clipping Circuit:
;; Clipping Circuit -> LP Filter
define function main()
begin
  return lp(clipping-circuit(s), 723.431)
end
