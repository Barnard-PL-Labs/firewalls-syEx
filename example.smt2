(set-logic QF_AUFBV )
(declare-fun dst_port () (Array (_ BitVec 32) (_ BitVec 8) ) )
(declare-fun proto () (Array (_ BitVec 32) (_ BitVec 8) ) )
(assert (or (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv9987 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  (_ bv22 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) )  (let ( (?B1 (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (and  (and  (and  (and  (and  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  false (=  (_ bv22 16) ?B1 ) ) ) (=  false (=  (_ bv80 16) ?B1 ) ) ) (=  false (=  (_ bv443 16) ?B1 ) ) ) (=  false (=  (_ bv30033 16) ?B1 ) ) ) (=  false (=  (_ bv9987 16) ?B1 ) ) ) (=  false (=  (_ bv13001 16) ?B1 ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  (_ bv30033 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  (_ bv443 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) )  (let ( (?B1 (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) (?B2 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (and  (and  (and  (and  (and  (=  false (=  (_ bv6 32) ?B2 ) ) (=  false (=  (_ bv22 16) ?B1 ) ) ) (=  false (=  (_ bv80 16) ?B1 ) ) ) (=  false (=  (_ bv443 16) ?B1 ) ) ) (=  false (=  (_ bv30033 16) ?B1 ) ) ) (=  false (=  (_ bv17 32) ?B2 ) ) ) (=  false (=  (_ bv9987 16) ?B1 ) ) ) (=  false (=  (_ bv13001 16) ?B1 ) ) ) )  (and  (=  (_ bv443 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) )  (and  (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv13001 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv30033 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) )  (let ( (?B1 (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (and  (and  (and  (and  (and  (and  (=  false (=  (_ bv22 16) ?B1 ) ) (=  false (=  (_ bv80 16) ?B1 ) ) ) (=  false (=  (_ bv443 16) ?B1 ) ) ) (=  false (=  (_ bv30033 16) ?B1 ) ) ) (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (=  false (=  (_ bv9987 16) ?B1 ) ) ) (=  false (=  (_ bv13001 16) ?B1 ) ) ) )  (and  (=  (_ bv80 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) )  (and  (=  (_ bv22 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) (=  (_ bv9987 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) (=  (_ bv13001 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) )  (let ( (?B1 (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) ) (and  (and  (=  false (=  (_ bv6 32) ?B1 ) ) (=  (_ bv80 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) (=  false (=  (_ bv17 32) ?B1 ) ) ) ) ))

(assert (or (and  (=  (_ bv17 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv9987 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv30033 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv443 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv13001 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv22 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) )  (and  (=  (_ bv6 32) (concat  (select  proto (_ bv3 32) ) (concat  (select  proto (_ bv2 32) ) (concat  (select  proto (_ bv1 32) ) (select  proto (_ bv0 32) ) ) ) ) ) (=  (_ bv80 16) (concat  (select  dst_port (_ bv1 32) ) (select  dst_port (_ bv0 32) ) ) ) ) ))
(check-sat)
(exit)