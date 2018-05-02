(* SimpLogic.ec Prove P->Q <=> (!Q=>!P) *)
prover ["!"].  (* no SMT solvers *)
lemma lemma_PQ (P : bool, Q : bool) :
    (P => Q) => ((! Q )=> (! P)).
    proof.
    move => P_Q not_Q.
      case (P).
    move => is_P.
      have is_Q : Q.
      apply(P_Q).
      trivial.
      trivial.
    trivial.
qed.  

lemma lemma_not_PQ (P : bool, Q : bool) :
    ((! Q )=> (! P)) => (P => Q).
    proof.
    move => not_PQ is_P.
    case ( Q ) => [//| not_Q].
      have // : ! P.
      apply(not_PQ).
    trivial.
  qed.

lemma eq_P_Q (P : bool, Q : bool) :
      (P => Q) <=> ((! Q )=> (! P)).
    proof.
      split; [apply lemma_PQ | apply lemma_not_PQ].
  qed.

 