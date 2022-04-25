(define (problem sornet-1)

(:domain sornet)

(:objects 
)

(:init 
    (same red_block red_block)
    (same green_block green_block)
    (same blue_block blue_block)
    (same yellow_block yellow_block)

    (is_free panda)

    (top_is_clear red_block)
    (top_is_clear green_block)
    (top_is_clear blue_block)
    (top_is_clear yellow_block)

    (on_surface_obj red_block center)
    (on_surface_obj green_block right)
    (on_surface_obj blue_block far)
    (on_surface_obj yellow_block left)

    (on_surface_robot panda center)

    (is_top_obj red_block center)
    (is_top_obj green_block right)
    (is_top_obj blue_block far)
    (is_top_obj yellow_block left)

)

(:goal

    (and
    (is_free panda)

    (on_surface_obj red_block left)
    (on_surface_obj green_block left)
    (on_surface_obj blue_block left)
    (on_surface_obj yellow_block center)

    (stacked red_block green_block)
    (stacked green_block blue_block)    

    (is_top_obj red_block left)
    (top_is_clear red_block)

    (on_surface_robot panda center)

    )

)

)