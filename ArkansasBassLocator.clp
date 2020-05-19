; Taylor Barber
; AI Final Project
; 12/11/2018
; ArkansasBassLocator.clp
; This program ask questions about environmental conditions and
; gives a description of where the fish will most likely be and
; what types of lures will work best.
;=================================
; Functions
;=================================

(deffunction Find-Depth-Location (?depth)
	(if (eq ?depth deep)
		then
		(bind ?depth 1)
	else (if (eq ?depth shallow)
			then
			(return 3)
		 else (if (eq ?depth mid)
				then
				(return 2)
				else
				(return 4)))))

(deffunction Find-Wind-Location (?wind)
	(if (eq ?wind windy)
		then
		(return 4)
		else
		(return 1)))
		
(deffunction Find-Time-Location (?time)
	(if (eq ?time yes)
		then 
		(return 4)
		else
		(return 1)))
		
(deffunction Find-Amount-Location (?amount)
	(if (eq ?amount few)
		then
		(return 1)
		else (if (eq ?amount some)
				then
				(return 3)
				else
				(return 4))))
				
(deffunction Find-Fish-Location (?time ?depth ?wind ?amount)
	(return (+ (Find-Depth-Location ?depth) (Find-Time-Location ?time) (Find-Wind-Location ?wind) (Find-Amount-Location ?amount))))

;=================================
; Question List
;=================================
	
(defrule month-right 
	=> 
	(printout t "Is the month March or April?(yes/no) " crlf)
	(bind ?month (read))
	(assert (spawn-time ?month)))

(defrule water-temp 
	=>
	(printout t "Is the temperature above 55 degrees Farenheit?(yes/no) " crlf)
	(bind ?temp (read))
	(assert (water-temp-above-55F ?temp)))
	
(defrule pressure-direction
	=>
	(printout t "Is the barometric pressure rising, falling, or stable? " crlf)
	(bind ?pressure (read))
	(assert (pressure-is ?pressure)))
	
(defrule water-depth (water-type river | lake)
	=>
	(printout t "Is the water depth around average depth?(yes/no) " crlf)
	(bind ?depth (read))
	(assert (average-depth ?depth)))

(defrule water-is-mid (average-depth no)
	=>
	(printout t "Is water depth around 1 to 2 feet above?(yes/no) " crlf)
	(bind ?depth (read))
	(assert (water-depth-mid ?depth)))
	
(defrule water-is-above-average (average-depth no) (water-depth-mid no)
	=>
	(printout t "Is the water depth well above 2.5 to 3 ft higher than normal?(yes/no) " crlf)
	(bind ?depth (read))
	(assert (water-depth-high ?depth)))
	
(defrule water-is-below-average (average-depth no) (water-depth-mid no) (water-depth-high no)
	=>
	(printout t "Is the water around 1 to 2 ft less than average?(yes/no) " crlf)
	(bind ?depth (read))
	(assert (water-depth-low ?depth)))
	
(defrule water-clarity-is (water-type river | lake)
	=>
	(printout t "How clear is the water?(clear/murky/muddy) " crlf)
	(bind ?clarity (read))
	(assert (water-clarity ?clarity)))
	
(defrule wind-speed-is (water-type river | lake)
	=>
	(printout t "Is the wind speed average(1-10mph) or windy(11mph or more)? " crlf)
	(bind ?wind-speed (read))
	(assert (wind-speed ?wind-speed)))
	
(defrule water-type-is
	=>
	(printout t "What body of water are you fishing in?(river/stream/lake)" crlf)
	(bind ?type (read))
	(assert (water-type ?type)))
	
(defrule system-start
	=>
	(printout t "Arkansas Bass Locator" crlf)
	(printout t "Terms to know:" crlf)
	(printout t "feeding - how many bass are actually searching for food to eat." crlf)
	(printout t "moving - how fast the majority of the bass will swim when chasing food." crlf)
	(printout t "ledges - sudden drop offs from shallow to deep water." crlf)
	(printout t "shelf - high places in deep water." crlf)
	(printout t "cover - something for bass to use to hide under or near; such as a log or a rock." crlf crlf))
	
;=================================
; Fish Behavior Rules
;=================================

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
	
(defrule Water-depth-deep (water-depth-low yes) => 
	(assert (fish-location deep)))
	
(defrule Water-depth-vegetation (water-depth-mid yes) => 
	(assert (fish-location bush)))
	
(defrule Water-depth-shallow (water-depth-high yes) => 
	(assert (fish-location shallow)))
	
(defrule Water-depth-average (average-depth yes) => 
	(assert (fish-location mid)))
	
(defrule Water-clarity-most (water-clarity muddy) =>
	(assert (fish-near-cover most)))

(defrule Water-clarity-some (water-clarity murky) =>
	(assert (fish-near-cover some)))
	
(defrule Water-clarity (water-clarity clear) =>
	(assert (fish-near-cover few)))
	
;=======================================
; Lure Selection Result Rules
;=======================================

(defrule lure-result-zero (fish-feeding-rate hyper) (spawn-time yes) (fish-attitude fast) 
	=>
	(printout t "The bass will be extremely active feeding and moving fast, using baits with fast action will work very well." crlf)
	(printout t "Baits such as: jerkbaits, jigs, spinnerbaits, crankbaits or plugs, and fast-action topwater baits should work well in these conditons. " crlf))

(defrule lure-result-seven (fish-feeding-rate normal) (spawn-time yes) (fish-attitude fast)
	=>
	(printout t "The bass will be very active feeding and moving fast, using baits with fast action will work well." crlf)
	(printout t "Baits such as: jerkbaits, jigs, spinnerbaits, crankbaits or plugs, and fast-action topwater baits should work well in these conditons. " crlf))
	
(defrule lure-result-one (fish-feeding-rate sluggish) (spawn-time yes) (fish-attitude slow) 
	=>
	(printout t "The bass will be somewhat active feeding but moving slowly, using baits with slow to medium action will work very well." crlf)
	(printout t "Baits such as: jerkbaits, jigs, crankbaits or plugs, and slow or medium action topwater baits should work well in these conditons. " crlf))

(defrule lure-result-two (fish-feeding-rate hyper | normal) (spawn-time no) (fish-attitude fast)
	=>
	(printout t "The bass will be fairly active feeding and fast moving, using baits with medium to fast action will work well." crlf)
	(printout t "Baits such as: jerkbaits, jigs, spinnerbaits, crankbaits or plugs, and fast or medium action topwater baits should work fairly well in these conditons. " crlf))
	
(defrule lure-result-three (fish-feeding-rate hyper | normal) (spawn-time yes) (fish-attitude slow)
	=>
	(printout t "The bass will be very active feeding but slower moving, using baits with medium action will work well." crlf)
	(printout t "Baits such as: spinner baits, jerkbaits, jigs, and medium moving crankbaits should work well in these conditons. " crlf))
	
(defrule lure-result-four (fish-feeding-rate hyper | normal) (spawn-time no) (fish-attitude slow)
	=>
	(printout t "The bass will be moderately active feeding and will be slower moving, using baits with slow action will work well." crlf)
	(printout t "Baits such as: jerkbaits, jigs, and slower moving crankbaits will get you moderate success in these conditons. " crlf))
	
(defrule lure-result-six (fish-feeding-rate sluggish) (spawn-time yes | no) (fish-attitude fast)
	=>
	(printout t "The bass will be fast moving but not so interested in feeding, fast action baits will work." crlf)
	(printout t "Baits such as: jerkbaits, jigs, spinnerbaits, crankbaits or plugs, and fast-action topwater baits should work in these conditons. " crlf))
	
(defrule lure-result-eight (fish-feeding-rate sluggish) (spawn-time no) (fish-attitude slow)
	=>
	(printout t "The bass will be slow moving and not so interested in feeding, slow action baits will give the best chance for catching fish." crlf)
	(printout t "Baits such as: jerkbaits, jigs, and slow crankbaits or plugs will be the best in these conditons. " crlf))
	
;======================================
; Bass Location Result Rules
;======================================

(defrule Run-Find (spawn-time ?time) (fish-location ?depth) (wind-speed ?wind) (fish-near-cover ?amount) (fish-feeding-rate ?) (fish-attitude ?) (water-type lake | river)
	=>
	(assert (average-location (div (Find-Fish-Location ?time ?depth ?wind ?amount) 4))))
	
(defrule deep-location (average-location 1)
	=>
	(printout t "The bass will most likely be in the deepest water they can find: on a shelf or on ledges." crlf))

(defrule -most-deep-location (average-location 2)
	=>
	(printout t "Some bass will be in shallow water close to cover, but most will be on a shelf or ledges." crlf))

(defrule most-shallow-location (average-location 3)
	=>
	(printout t "Some bass will be on a shelf or ledges, but most bass will be in shallow water close to cover." crlf))
	
(defrule shallow-location (average-location 4)
	=>
	(printout t "The bass will most likely be in the shallowest water close to cover." crlf))
	
(defrule water-type-is-stream (water-type stream) (spawn-time ?) (fish-feeding-rate ?) (fish-attitude ?)
	=>
	(printout t "Fish in areas where fast water meets still water, and also fish in slow moving water with cover." crlf))
