(define (domain sornet)

(:requirements :strips :typing :disjunctive-preconditions :conditional-effects :universal-preconditions :negative-preconditions)

(:types robot obj surface)

(:constants
    left
    right
    far
    center 
    trash - surface

    panda - robot

    red_block
    green_block
    blue_block
    yellow_block - obj
)

(:predicates
    ;; objx same objy
    (same ?x - obj ?y - obj)
    ;; robot x has object y
    (has_obj ?x - robot ?y - obj)
    ;; robot x gripper is free
    (is_free ?x - robot)
    ;; obj x in surface y
    (on_surface_obj ?x - obj ?y - surface)
    ;; robot x in surface y
    (on_surface_robot ?x - robot ?y - surface)
    ;; is object x top is clear
    (top_is_clear ?x - obj)
    ;; object x is on object y(stacked)
    (stacked ?x - obj ?y - obj)
    ;; x is top object in surface y
    (is_top_obj ?x - obj ?y - surface)
)


(:action move_robot
    :parameters (?r - robot ?from - surface ?to - surface)
    :precondition (and 
        (on_surface_robot ?r ?from)
    )
    :effect (and
        (not (on_surface_robot ?r ?from))
        (on_surface_robot ?r ?to)
        (forall (?x - obj)
            (when (and (has_obj ?r ?x))
                (and
                    (not (on_surface_obj ?x ?from))
                    (on_surface_obj ?x ?to)
                )
            )
        )
    )
)

(:action pick
    :parameters (?r - robot ?o - obj ?s - surface)
    :precondition (and 
        (on_surface_obj ?o ?s)
        (on_surface_robot ?r ?s)
        (is_top_obj ?o ?s)
        (is_free ?r)
    )
    :effect (and
        (has_obj ?r ?o)
        (not (is_free ?r))

        (forall (?x - obj)
            (when (and (stacked ?o ?x))
                (and
                    (not (stacked ?o ?x))
                    (is_top_obj ?x ?s)
                )
            )
        )
        (not (is_top_obj ?o ?s))
    )
)

(:action drop
    :parameters (?r - robot ?s - surface ?o - obj)
    :precondition (and
        (not (is_free ?r))
        (on_surface_robot ?r ?s)
        (has_obj ?r ?o)
    )
    :effect (and
        (is_free ?r)
        (forall (?x - obj)
            (when (and (is_top_obj ?x ?s))
                (and
                    (not (is_top_obj ?x ?s))
                    (is_top_obj ?o ?s)
                    (stacked ?o ?x)
                )
            )
        )
        (not (has_obj ?r ?o))
    )
)

(:action exchange
    :parameters (?r - robot ?s1 - surface ?s2 - surface ?o1 - obj ?o2 - obj)
    :precondition (and 
        (not (same ?o1 ?o2))
        (is_free ?r)
        (on_surface_robot ?r ?s1)
        (on_surface_obj ?o1 ?s1)
        (on_surface_obj ?o2 ?s2)
        (is_top_obj ?o1 ?s1)
        (is_top_obj ?o2 ?s2)
    )
    :effect (and 
        (not (on_surface_obj ?o1 ?s1))
        (not (on_surface_obj ?o2 ?s2))
        (on_surface_obj ?o1 ?s2)
        (on_surface_obj ?o2 ?s1)
        (is_top_obj ?o1 ?s2)
        (not (is_top_obj ?o1 ?s1))
        (is_top_obj ?o2 ?s1)
        (not (is_top_obj ?o2 ?s2))

        (forall (?x - obj)
            (when (and (stacked ?o1 ?x))
                (and
                    (stacked ?o2 ?x)
                    (not (stacked ?o1 ?x))
                )
            )
        )
        (forall (?x - obj)
            (when (and (stacked ?o2 ?x))
                (and
                    (stacked ?o1 ?x)
                    (not (stacked ?o2 ?x))
                )
            )
        )
    )
)
)