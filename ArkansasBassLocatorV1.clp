(defrule begin (ready-to-go yes) =>
	(printout t "Arkansas Fish Locator" crlf)
	(start))
	
(deffunction ask-question (?question $?allowed-values)
(printout t ?question)
(bind ?answer (read))
?answer)

(deffunction start ()
(if (eq (ask-question "Is the month March or April?(yes/no) ") yes)
	then
		(assert (month-is good))
		(run)
	else
		(assert (month-is bad))
		(run))
)

(defrule good-month (month-is good) => 
	(assert (spawn-time yes)))
	
(defrule bad-month (month-is bad) => 
	(assert (spawn-time no)))
	
(deffacts startup (ready-to-go yes))
	
(defrule Time-one (time-is morning) => 
	(assert (fish-time best)))

(defrule Time-two (time-is midday) => 
	(assert (fish-time worst)))

(defrule Time-three (time-is afternoon) => 
	(assert (fish-time best)))

(defrule Water-temp-more (water-temp-above-55F yes) => 
	(assert (fish-attitude fast)))
	
(defrule Water-temp-less (water-temp-above-55F no) => 
	(assert (fish-attitude slow)))

(defrule Pressure-fall (pressure-is falling) => 
	(assert (fish-feeding-rate hyper)))
	
(defrule Pressure-rise (pressure-is rising) => 
	(assert (fish-feeding-rate sluggish)))
	
(defrule Pressure-stable (pressure-is stable) => 
	(assert (fish-feeding-rate normal)))
	
(defrule Water-height-deep (water-height-is three-below) => 
	(assert (fish-location deep)))
	
(defrule Water-height-mid (water-height-is two-below-to-one) => 
	(assert (fish-location mid)))
	
(defrule Water-height-shallow (water-height-is above-one) => 
	(assert (fish-location shallow)))
	
(defrule Water-clarity-most (water-clarity muddy) =>
	(assert (fish-near-cover most)))

(defrule Water-clarity-some (water-clarity murky) =>
	(assert (fish-near-cover some)))
	
(defrule Water-clarity (water-clarity clear) =>
	(assert (fish-near-cover few)))

(defrule Water-Type-stream (body-of-water stream) =>
	(assert (water-type stream)))

(defrule Water-Type-lake (body-of-water lake) =>
	(assert (water-type lake)))
	
(defrule Water-Type-river (body-of-water river) =>
	(assert (water-type river)))
	
(defrule Wind-effect (or (body-of-water lake) (body-of-water river)) (wind-speed slow) =>
	(assert (water-type stream)))
	
(defrule fish-today (fish-condition good) =>
	(assert (good-day yes))
	(printout t "Let's fish!" crlf))
	
(defrule fish-today (fish-condition bad) =>
	(printout t "Let's not fish!" crlf))
	